# CapCut handoff: voice and captions for the 30 lessons

You add the voice and captions in CapCut. Everything else is built here.
CapCut's buttons differ between versions and between phone and desktop, so names below may not match your screen exactly.

## What you get for each day
| File | What it is |
|------|------------|
| `renders/clean/dNN-clean.mp4` | The lesson video: no voice, no music, **no captions**. Headlines, charts, labels and the disclaimer are in it. |
| `briefs/vo/dNN-vo.txt` | The voiceover: six short paragraphs, one per scene, in order. |
| `scripts/dNN-*.md` | The full script: caption, hashtags, pinned comment. |

`renders/` isn't saved in git. Rebuild any day with `bash tools/render-all.sh d04`.

## The voice
**The male "sly villain" voice in CapCut**, the same one every day. Steady pace. Don't change any words: they passed the compliance and learning-order checks. If a line sounds wrong, tell me and I'll rewrite and re-check it.

## Best route: voice first, then I re-time the video
1. In CapCut, turn each of the six paragraphs into its own voice clip (text to speech).
2. Read off each clip's length in seconds.
3. Send me the six numbers, e.g. `d04: 2.1, 6.4, 4.9, 10.2, 8.6, 4.5`.
4. I re-render that day so every scene change lands on your voice (free, about a minute).
5. Put the re-timed video under your six clips, end to end with no gaps. Add captions and music, then export.

Quick route: use the video as it is and place each clip at its scene start (`briefs/scene-times.md`).

## Captions
- Auto captions from the voice, then proofread every line. Watch for: bid, ask, wicks, sim, FOMO, pip, tick.
- 2–4 words at a time, heavy white font, dark box behind.
- Key word in red `#FF2D3D` for warnings, or green `#22C55E` for up or gain ideas, matching the headline on screen.
- About two-thirds down the screen, **above** the grey disclaimer line. Never on top of it.

## Before you export (CLAUDE.md §6)
- The disclaimer is visible the whole time. Nothing covers it, including CapCut's own watermark.
- Days 20–22: "Leverage magnifies losses." stays visible.
- Add nothing in CapCut that the script doesn't have: no prices, profits, "buy"/"sell" calls or money emojis.
- Music: only tracks you're allowed to use on a creator or business account.
- AI voice label: check TikTok's and Instagram's current rules for synthetic voices and switch the label on if they apply.

## Export
1080×1920, 30 fps, highest quality. Name it `dNN-final.mp4`.
