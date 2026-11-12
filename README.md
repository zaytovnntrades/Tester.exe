# Financial Shorts Engine

A Claude Code workspace for a survival-first trading-education Shorts channel.
All the rules live in `CLAUDE.md`. Run one stage at a time with `/pipeline <stage>`.

| Order | Command | Output |
|-------|---------|--------|
| once | `/pipeline voice` | `about-me.md`, `voice.md` |
| 1 | `/pipeline scout` | `research/YYYY-MM-DD.md` |
| 2 | `/pipeline study <short-url>` | `breakdowns/<slug>.md` |
| 3 | `/pipeline ideate` | `ideas/matrix.md`, `ideas/backlog.md` |
| 4 | `/pipeline script` | `scripts/###-<slug>.md` |
| 5 | `/pipeline produce 001` | `briefs/001-brief.md` |
| 6 | `/pipeline review` + paste stats | `published/log.csv`, `ideas/insights.md` |
| any | `/pipeline status` | what's done, what's next |

## Scout setup
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r tools/scout/requirements.txt
python tools/scout/rss_spider.py --dev   # cached while you tweak feeds.txt
```

## Plugins to install (outside this repo)
- Eyes: claude-video plugin (the `watch` skill)
- Writer: social-media-skills plugin
- Studio: claude-code-video-toolkit, cloned next to this repo at `../claude-code-video-toolkit` (not in use right now: see below)

## How videos get made right now
1. Visuals are drawn in code here: `node tools/studio/render.js tools/studio/005-draft.html renders/clean/005-clean.mp4 clean`
2. Voice and captions are added in CapCut. Steps: `briefs/capcut-handoff.md`. Text to paste: `briefs/vo/`.
3. Send the six voice-clip lengths back and the video is re-timed to match: add `"clean&d=4.8,4.1,6.3,8.9,5.7,6.6"` as the last argument.

Rendered videos land in `renders/`, which is not committed.
