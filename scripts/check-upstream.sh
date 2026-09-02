#!/bin/bash
# check-upstream.sh — report upstream changes and classify them for a CUSTOMIZED fork.
#
# This fork diverges from upstream on purpose (language variants, an internal clean-text
# note). So this never auto-merges. It fetches upstream, then splits upstream's changes into:
#   SAFE     — files upstream changed that YOU have not touched → apply cleanly.
#   CONFLICT — files upstream changed that YOU also customized → manual merge, review first.
# and prints the exact commands to act. Read-only: it writes nothing to your tree.
#
# Exit 0 = up to date. Exit 3 = upstream has new work (so it is usable as a cron watcher).
#
# Generic: works on any fork with `origin` + `upstream` remotes. Run from the repo, or pass -C.
set -uo pipefail

REPO="$PWD"
[[ "${1:-}" == "-C" && -n "${2:-}" ]] && REPO="$2"
GIT=(git -C "$REPO")

log()  { echo "[check-upstream] $*"; }
die()  { echo "[ERROR] $*" >&2; exit 1; }

"${GIT[@]}" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not a git repo: $REPO"
"${GIT[@]}" remote | grep -qx upstream || die "no 'upstream' remote. Add it: git remote add upstream <url>"

BRANCH="$("${GIT[@]}" symbolic-ref --short HEAD 2>/dev/null || echo main)"
# Upstream's default branch (main/master), resolved from its HEAD, falling back to main.
UP_HEAD="$("${GIT[@]}" symbolic-ref --short refs/remotes/upstream/HEAD 2>/dev/null | sed 's|^upstream/||')"
UP="upstream/${UP_HEAD:-main}"

log "fetching upstream …"
"${GIT[@]}" fetch --quiet --tags upstream || die "fetch failed"
"${GIT[@]}" rev-parse --verify --quiet "$UP" >/dev/null || die "no $UP after fetch (wrong branch name?)"

BASE="$("${GIT[@]}" merge-base "$BRANCH" "$UP")"
AHEAD="$("${GIT[@]}" rev-list --count "$UP..$BRANCH")"   # your commits on top of the base
BEHIND="$("${GIT[@]}" rev-list --count "$BRANCH..$UP")"  # upstream commits you lack

echo
echo "  fork branch : $BRANCH  ($AHEAD commit(s) ahead of the shared base)"
echo "  upstream    : $UP  ($BEHIND new commit(s) you don't have)"
NEWTAG="$("${GIT[@]}" describe --tags --abbrev=0 "$UP" 2>/dev/null || true)"
[[ -n "$NEWTAG" ]] && echo "  latest upstream tag reachable from $UP: $NEWTAG"

if [[ "$BEHIND" -eq 0 ]]; then
  echo
  log "up to date — upstream has nothing new on $UP. Nothing to apply."
  exit 0
fi

echo
echo "── new upstream commits ($BEHIND) ──────────────────────────────────────────"
"${GIT[@]}" log --oneline --no-decorate "$BRANCH..$UP"

# Classify changed files: what UPSTREAM changed vs what YOU changed since the shared base.
mapfile -t UP_FILES   < <("${GIT[@]}" diff --name-only "$BASE" "$UP")
mapfile -t MINE_FILES < <("${GIT[@]}" diff --name-only "$BASE" "$BRANCH")

is_mine() { local f="$1" m; for m in "${MINE_FILES[@]}"; do [[ "$m" == "$f" ]] && return 0; done; return 1; }

SAFE=(); CONFLICT=()
for f in "${UP_FILES[@]}"; do
  if is_mine "$f"; then CONFLICT+=("$f"); else SAFE+=("$f"); fi
done

echo
echo "── SAFE to apply (upstream changed, you did NOT) ───────────────────────────"
if [[ "${#SAFE[@]}" -eq 0 ]]; then echo "  (none)"; else printf '  %s\n' "${SAFE[@]}"; fi

echo
echo "── MANUAL MERGE (upstream AND you changed these) ───────────────────────────"
if [[ "${#CONFLICT[@]}" -eq 0 ]]; then echo "  (none)"; else printf '  %s\n' "${CONFLICT[@]}"; fi

cat <<EOF

── how to act ──────────────────────────────────────────────────────────────
Review a single file's upstream change:
  git -C "$REPO" diff $BASE $UP -- <file>
Apply ONLY the safe files (leaves your customizations untouched):
  git -C "$REPO" checkout $UP -- ${SAFE[*]:-<none>}
Merge everything and resolve conflicts by hand (for the manual-merge files):
  git -C "$REPO" merge $UP
Or cherry-pick one upstream commit:
  git -C "$REPO" cherry-pick <sha>

Nothing was changed in your tree. Re-run after applying to confirm 0 behind.
EOF

exit 3
