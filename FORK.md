# FORK.md — ansulev/humanizer

Fork of [blader/humanizer](https://github.com/blader/humanizer). This file is ours; upstream
has no `FORK.md`, so it never conflicts. `README.md` and `SKILL.md` stay as close to upstream
as possible — see [Divergence](#divergence).

## What this fork adds

| Path | What |
|---|---|
| `humanizer-es/SKILL.md` | Spanish layer — AI slop lexicon, `¿ ¡`, tildes/ñ, tú/usted register |
| `humanizer-ca/SKILL.md` | Catalan layer — castellanismes, pronoms febles, punt volat (l·l), apostrophes, accents, variety kept |
| `SKILL.md` (4 additions, 2 diff hunks) | Input resolution, language auto-routing, clean-text handoff, copy mode |

The two language skills are **not** translations of the 25 patterns. The structural patterns
(dashes, curly quotes, bold, emojis, false ranges, chatbot artifacts, filler) are
language-neutral and stay in the root skill. Each layer owns only what is specific to its
language: the slop lexicon and the orthography models get wrong. That keeps them ~4 KB each
instead of ~30 KB, and stops them drifting from upstream on every release.

### Root SKILL.md changes

1. **Input resolution** — "the text above/below" with nothing pasted resolves to the adjacent
   block; asks when ambiguous; never rewrites code, terminal output, or system messages.
2. **Language auto-routing** — routes on the language of *the text*, not of the request, then
   reads and applies that layer in one pass. It does not tell the user to invoke another skill
   and does not translate.
3. **Copy mode** — upstream §4 strips sales language, which neuters real marketing copy. Copy
   mode keeps concrete benefit, proof, offer and CTA, and drops superlatives with no fact
   behind them. The no-invented-facts rule keeps **no** copy exception: a claim without a fact
   gets asked about, never fabricated.
4. **clean-text handoff** — this skill changes wording, not bytes. Invisible Unicode, exotic
   spaces, bidi and tag characters belong to the sibling `clean-text` skill (our slim
   derivation of `blader/watermarks-remover`), so the method never reimplements that pass.
   Upstream has no equivalent split.

## Where the live copies run

The repo is the publishable source. The skills agents actually load live in the shared
harness SoT:

```
~/.agents/skills/humanizer/SKILL.md
~/.agents/skills/humanizer-es/SKILL.md
~/.agents/skills/humanizer-ca/SKILL.md
```

These are **always-on** skills `[promoted 2026-09-11]`, moved out of the seonove pack: Angel
writes in three languages every day, so clean+humanize is not a per-domain concern. A skill in
`skills/` costs only its name and description in context — the body loads on invocation — so the
promotion is cheap despite this file's size.

Promotion is a **move**, never a symlink from `skills/` into `cc-skills/`: `pack-unload.sh`
removes any `skills/` link resolving under `cc-skills/`, so a symlinked promotion would be
silently undone the first time anyone unloaded the seonove pack.

They are reached by claude, grok, antigravity and opencode through the shared `~/.agents` dir.
Codex reads its own `skills/`; if
`codex debug prompt-input | grep humanizer` comes up empty, symlink it.

**These are twin copies**, and the sync is scripted in both directions:

```bash
~/.agents/scripts/check-forks.sh --all              # is this fork behind upstream?
git merge upstream/main                             # take their work (see below)
~/.agents/scripts/sync-skills-from-forks.sh --check # what would land in the harness
~/.agents/scripts/sync-skills-from-forks.sh --apply # copy repo -> live harness
```

The sync runs **repo → harness**. So land a change here first and push it out, rather than
editing `~/.agents` and back-copying — an edit that lives only in the harness is invisible to
this repo and gets overwritten on the next `--apply`.

## Updating from upstream

```bash
cd /mnt/data/10_PROJECTS/_forks/humanizer
git fetch upstream                        # nothing local changes yet
git log --oneline HEAD..upstream/main     # what's new
git merge upstream/main                   # replay their work under ours
# resolve, then
git push origin main
```

Merge, not rebase — this history is already pushed.

`rerere.enabled=true` is set locally: resolve a conflict once and git replays that resolution
next time the same one appears. Our hunks hit the same neighbourhoods every release, so each
is resolved roughly once, ever.

After merging, run `~/.agents/scripts/sync-skills-from-forks.sh --apply` or the live harnesses
keep running the old prompt. `scripts/check-upstream.sh` classifies an upstream release into
files you never touched (safe to take) and files you customized (merge by hand).

## Divergence

Measured against upstream `9862685` `[re-measured 2026-09-11]`:

```
SKILL.md               36 lines, 2 hunks   <- the only conflict surface
humanizer-ca/SKILL.md 165 lines            <- upstream has no such file
humanizer-es/SKILL.md 134 lines            <- upstream has no such file
335 insertions, 0 deletions
```

Re-measure with `git diff --numstat upstream/main -- SKILL.md humanizer-es/SKILL.md
humanizer-ca/SKILL.md`. The two hunks sit at `SKILL.md:40` (how to find the text, invisible
characters, language routing — now a `###` under *How to work*) and `SKILL.md:382` (copy mode,
before *When not to act*).

No deletions, so we never fight upstream over removed text. A whole-file rewrite on their
side will still conflict; ordinary releases usually will not.

**The rewrite this file predicted happened — `34ca949`, 2026-09-11.** Upstream rebuilt the
skill around 25 patterns ordered by strength (it was 35 in a flat list), renamed *Check for
false positives* to *When not to act*, and made *Voice* / *What to return* subsections of
*How to work*. The re-apply was still 36 insertions and 0 deletions, but **the cross-references
inside our hunks had to be renumbered** — sales language moved §4 → **§16**, the English word
lists §7 → **§12**, and the no-invented-facts rule became step 2 of *How to work*. That is the
part a mechanical re-apply gets wrong and nothing warns you about: the text merges cleanly and
then points at the wrong sections. **Re-check every `§n` in our hunks after any upstream
renumbering.**

**Do not add fork documentation to `README.md`.** It is upstream's highest-churn file — their
`e2e92e7` was a README rewrite and `2.11.0` rewrote all repo guidance. Anything
put there conflicts on the next release for no operational gain. This file exists so that does
not have to happen.

Upstream `AGENTS.md` requires `SKILL.md`/`README.md` sync and matching version strings across
`metadata.version`, the README entry and `plugin.json`. That rule governs PRs back to upstream.
We are not upstreaming the language layers, so it does not bind this fork, and **version
strings are left untouched** — upstream owns that number.

## Not upstreamed, on purpose

The language layers are ANSULEV-specific (Catalan copywriting, SEONOVE marketing) and depend
on the sibling-skill layout. Copy mode contradicts upstream's §4 by design. None of it belongs
in a PR to blader/humanizer unless they ask for it.
