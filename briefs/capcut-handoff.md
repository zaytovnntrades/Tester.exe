# CapCut handoff: voiceover and captions

You add the voice and the captions in CapCut. I build everything else here.
CapCut's menus change between versions and between phone and desktop, so the button names below may differ slightly on your screen.

## What you get from me
| File | What it is |
|------|------------|
| `renders/clean/###-clean.mp4` | The video with no voice, no music and **no captions**. On-screen text, labels, source lines and the disclaimer are still in it. |
| `briefs/vo/###-vo.txt` | The voiceover text. Six short paragraphs, one per scene, in order. |

Ready now: 005, 006, 007 (Trading Basics), 004, 001, 002.

## The fast way (recommended): voice first, then I re-time the video
The clean videos are timed by estimate (2.5 words per second). A real voice will run faster or slower, so the pictures drift out of step. This order fixes that:

1. **Make the voice in CapCut.** New project → add a text block → paste the **first paragraph** from `###-vo.txt` → Text to speech → pick your voice → generate. Repeat for all six paragraphs, so you have six separate audio clips.
2. **Read off the six clip lengths.** Tap each audio clip; CapCut shows its length in seconds.
3. **Send me the six numbers**, like this: `005: 4.8, 4.1, 6.3, 8.9, 5.7, 6.6`
4. **I re-render the video to those exact lengths** (free, about a minute) and send it back. Every scene change then lands on your voice.
5. **Drop the new video into the same CapCut project** under the six voice clips, placed end to end with no gaps.
6. **Add captions** (settings below), music, and export.

## The quick way: fit the voice to the video as it is
Use this if you just want a first version out.
1. Import `###-clean.mp4` into CapCut.
2. Generate the six voice clips as above.
3. Place each clip at its scene start (table below). If a clip runs longer than its scene, raise that clip's speed slightly; if shorter, leave the gap.
4. Add captions, music, export.

### Scene start times in the clean videos (seconds)
| Video | Scene 1 | 2 | 3 | 4 | 5 | 6 | Voice ends |
|-------|---------|---|---|---|---|---|-----------|
| 005 · candle | 0.0 | 5.2 | 9.6 | 15.6 | 23.6 | 29.6 | 36.0 |
| 006 · stop loss | 0.0 | 4.0 | 9.6 | 18.0 | 22.4 | 28.0 | 32.4 |
| 007 · leverage | 0.0 | 4.4 | 7.6 | 14.4 | 20.4 | 25.6 | 31.2 |
| 004 · max daily loss | 0.0 | 5.0 | 10.5 | 16.5 | 22.0 | 28.5 | 34.0 |
| 001 · $130M red flags | 0.0 | 5.0 | 11.0 | 18.0 | 24.0 | 31.5 | 38.5 |
| 002 · Fed day | 0.0 | 5.5 | 13.5 | 19.0 | 25.0 | 31.0 | 37.5 |

Each video holds its end card for 1 second after the voice ends.

## Voice settings
- **One voice for every video.** Pick a steady, lower, unhurried voice. Blunt coach, not excited. Write its name down here once chosen: `__________`
- **Speed:** start at normal (1.0×). The scripts are written for about 2.5 words per second.
- **Check these words by ear** after generating:
  - "S-E-C" and "M-E-S", "M-N-Q" are typed with hyphens in the text files so the voice reads them as letters. If it sounds wrong, try "S E C" with spaces.
  - "Investor dot gov" (video 001) is typed out in words on purpose.
  - "wicks" (video 005) should rhyme with "sticks".
- **Don't change the words.** They've passed the compliance check. If a line sounds wrong, tell me and I'll rewrite it and re-check it.

## Caption settings
- **Source:** auto captions from the voice clips. Then proofread every line: auto captions often mishear "MES", "SEC", "wicks" and "sim".
- **Length:** 2 to 4 words on screen at a time.
- **Font:** a heavy sans-serif. White, with a dark background box or a thick black outline.
- **Highlight colour:** red `#FF2D3D`, on the key word only. Key words per video:
  - 005: candle, body, wicks, open, high, low, close, survive
  - 006: exit, stop, out, guarantee, sim, survive
  - 007: danger, losses, margin, leveraged, sim, survive
  - 004: bad, number, spiral, before, done, survive
  - 001: risk-free, signals, registered, survive
  - 002: nothing, split, hike, losses, size, sim, survive
- **Position:** about two-thirds of the way down the screen. That spot is left empty in every clean video. Keep captions **above** the grey disclaimer line and never on top of it.
- **Video 001 only:** when the caption shows the words *risk-free*, keep the on-screen "RISK-FREE RETURNS" stamp and its ALLEGED tag fully visible.

## Before you export: compliance check (CLAUDE.md §6)
- The disclaimer line "Educational only — not financial advice." is visible in every second. Captions, stickers and CapCut's own watermark must not cover it.
- Nothing added in CapCut: no price targets, no "buy" or "sell", no profit claims, no money emojis, no words from the banned list (guaranteed, risk-free, easy money, get rich, can't lose, quit your job).
- Source lines stay readable: video 001 scene 2 (SEC) and video 002 scene 2 (Federal Reserve).
- Music: use a track you're allowed to use on a business or creator account.
- Check TikTok's current rule on labelling AI-generated content, and switch the label on if a synthetic voice counts.
- Check CapCut's terms for the voice you picked: confirm it's allowed for the kind of posting you do.

## Export
1080×1920, 30 fps, highest quality. Name the file `###-final.mp4`.
