---
description: Run one stage of the Financial Shorts Engine (voice | scout | study | ideate | script | produce | review | status)
argument-hint: <stage> [extra args, e.g. a URL, script id, or pasted stats]
---

Stage requested: `$ARGUMENTS`

1. Re-read `CLAUDE.md` (sections 5–7 especially). Files in `frameworks/` override its defaults.
2. Session-start context: read the last 10 rows of `published/log.csv`, `ideas/backlog.md`, and `ideas/insights.md`.
3. Map the first word of the arguments to a stage and run **only** that stage, exactly as CLAUDE.md §5 defines it:

| Arg | Stage | Output |
|-----|-------|--------|
| `voice` / `0` | 0 · VOICE | `about-me.md`, `voice.md` |
| `scout` / `1` | 1 · SCOUT | `research/YYYY-MM-DD.md` (run `python tools/scout/rss_spider.py` first, then curate) |
| `study` / `2` | 2 · STUDY | `breakdowns/<slug>.md` (needs a URL in the arguments) |
| `ideate` / `3` | 3 · IDEATE | `ideas/matrix.md`, `ideas/backlog.md` |
| `script` / `4` | 4 · SCRIPT | `scripts/###-<slug>.md` (next free id unless one is given) |
| `produce` / `5` | 5 · PRODUCE | `briefs/###-brief.md` (only for scripts with `status: approved`) |
| `review` / `6` | 6 · REVIEW | `published/log.csv`, `ideas/insights.md` |
| `status` | — | A short table: what exists in each folder, the next recommended stage, anything blocked |

4. Rules that apply to every stage:
   - If `about-me.md` or `voice.md` is missing, label every script `DRAFT — voice not set`.
   - Every script goes through the §6 compliance check. Any failure → `status: blocked` + the fix.
   - If a tool or skill is missing or fails, say so plainly and continue with what works. Never fake an output.
   - Confirm with me before anything that spends paid credits.
   - Save outputs as files, then end with a 3-line summary: what was made, where it is, and the next stage.

If no stage was given, run `status`.
