# FORK.md — ansulev/humanizer

Fork of [blader/humanizer](https://github.com/blader/humanizer). This file is ours; upstream
has no `FORK.md`, so it never conflicts. `README.md` and `SKILL.md` stay as close to upstream
as possible — see [Divergence](#divergence).

## What this fork adds

| Path | What |
|---|---|
| `humanizer-es/SKILL.md` | Spanish layer — AI slop lexicon, `¿ ¡`, tildes/ñ, tú/usted register |
| `humanizer-ca/SKILL.md` | Catalan layer — castellanismes, pronoms febles, punt volat (l·l), apostrophes, accents, variety kept |
| `SKILL.md` (4 hunks) | Input resolution, language auto-routing, copy mode |

The two language skills are **not** translations of the 35 patterns. The structural patterns
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

## Where the live copies run

The repo is the publishable source. The skills agents actually load live in the shared
harness SoT:

```
~/.agents/skills/humanizer/SKILL.md
~/.agents/skills/humanizer-es/SKILL.md
~/.agents/skills/humanizer-ca/SKILL.md
```

Reached by claude, grok, antigravity and opencode through that shared dir. Codex reads its
own `skills/`; if `codex debug prompt-input | grep humanizer` comes up empty, symlink it.

**These are twin copies.** Edit `~/.agents` (live), then copy into this repo when publishing.
Editing the repo copy alone changes nothing at runtime.

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

After merging, copy any changed skill back into `~/.agents/skills/` or the live harnesses keep
running the old prompt.

## Divergence

Measured against upstream `e2e92e7`:

```
SKILL.md               32 lines, 4 hunks   <- the only conflict surface
humanizer-ca/SKILL.md 168 lines            <- upstream has no such file
humanizer-es/SKILL.md 136 lines            <- upstream has no such file
336 insertions, 0 deletions
```

No deletions, so we never fight upstream over removed text. A whole-file rewrite on their
side (as in `2.11.0`) will still conflict; ordinary releases usually will not.

**Do not add fork documentation to `README.md`.** It is upstream's highest-churn file — their
latest commit `e2e92e7` is a README rewrite, and `2.11.0` rewrote all repo guidance. Anything
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
