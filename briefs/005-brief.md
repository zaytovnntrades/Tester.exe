# Production brief 005: How to read a candle (Trading Basics, part 1)

- **Script:** `scripts/005-how-to-read-a-candle.md` (status: approved)
- **Role in the series:** part 1 of Trading Basics. Post it first; 006 (stop loss) and 007 (leverage) follow.
- **Reference draft:** a silent version already exists. Rebuild it with `node tools/studio/render.js tools/studio/005-draft.html renders/005-draft-silent.mp4`. Use it as the layout reference.
- **Format:** 1080×1920 vertical (9:16), 30 fps
- **Duration:** about 36 seconds (90 words at 2.5 words per second). Final length follows the voiceover: time the scenes to the audio.
- **Style:** faceless. Motion graphics and text only. Black background, white text; charts in green (up) and red (down), the same as the other channel videos.
- **Voice and captions:** added by the director in CapCut (see `briefs/capcut-handoff.md`; text in `briefs/vo/005-vo.txt`). Steady, lower, unhurried voice. Blunt coach. The same voice as every other video.
- **Platform:** TikTok first. Keep all text inside the safe area: clear of the top 220 px and bottom 420 px, and 120 px off the right edge. Check these against TikTok's current layout before the final export.

## Costs
The visuals are drawn in code and cost nothing. Voice and captions are made in CapCut, where some voices and tools need a paid plan: that is the director's call.

## Final voiceover text (read exactly as written)
> You'll see this shape on almost every trading chart. Can you read it?
>
> It's called a candle. If you can't read it, you're guessing.
>
> One candle is one slice of time. A minute. An hour. A day. You choose.
>
> The thick part is the body. Where price opened and where it closed. Its colour tells you up or down.
>
> The thin lines are wicks. They show the highest and lowest price in that time.
>
> Four prices. One shape. Open, high, low, close. Learn that before anything else. Survive first. Follow.

**Pronunciation notes:**
- Full stops are real pauses. "A minute. An hour. A day." is three separate beats, evenly spaced.
- "Open, high, low, close" is a list: a short, even pause at each comma, the same weight on all four words.
- "Wicks" rhymes with "sticks".
- Slow down slightly through the body line ("The thick part is the body…"). It carries the most new information in the video.

## Scene list
Timings are estimates from word counts. Lock them to the real audio.

| # | Scene | Seconds | Visual | On-screen text |
|---|-------|---------|--------|----------------|
| 1 | Hook | 0.0–5.2 | A row of candles across the screen. **One tall, clear candle is ringed within the first 2 seconds**, and the ring pulses. (In the silent draft the ringed candle is too thin: make it one of the tallest in the row.) | `On almost every chart.` then `Can you read it?` (red) |
| 2 | Stakes | 5.2–9.6 | Hard cut to that one candle alone, large, centre screen. Nothing else. | `It's called a candle.` then `Can't read it? You're guessing.` |
| 3 | Beat 1: time | 9.6–15.6 | Five candles on a time axis with tick marks. The middle one is white, the others dimmed. A red bracket sits under the middle candle. A big label under it changes on each spoken word. | `1 candle = 1 slice of time` · label cycles: `1 MINUTE` → `1 HOUR` → `1 DAY` → `YOU CHOOSE` |
| 4a | Beat 2: body | 15.6–20.6 | The big candle, shifted left. A red box outlines the thick part. Pointer lines come out to the right: first to the bottom edge, then to the top edge. | `The body` · `BODY` (red) · `OPEN` (bottom) · `CLOSE` (top) |
| 4b | Beat 2: colour | 20.6–23.6 | Hard cut to two candles side by side: a white one and a red one, same size. | `Colour = direction` · `UP` / `closed higher` · `DOWN` / `closed lower` · small: `Colours vary by platform.` |
| 5 | Beat 3: wicks | 23.6–29.6 | The big candle again. The thin lines turn red. Pointers to the top tip, then the bottom tip. | `The wicks` · `HIGH` / `highest price in that time` · `LOW` / `lowest price in that time` |
| 6 | CTA | 29.6–36.0 | The candle with all four labels landing one by one as they're spoken, in this order: open, high, low, close. Then the end card with the channel name. Hold the end card 1 second after the voice stops. | `4 prices. 1 shape.` · `OPEN` `HIGH` `LOW` `CLOSE` · `Learn this first.` · `Survive first.` · `Follow` · `Next: Part 2 · The stop loss` · `Zaytovnn Trades` |

**On every scene, bottom of the safe area, small but readable:** `Educational only — not financial advice.`

## Captions
Burned-in captions of the voiceover, 2 to 4 words at a time, key word highlighted in red (candle, body, wicks, open, high, low, close, survive). In the silent draft they sit below the visuals, not centre screen, so they don't cover the candle. Keep them there.

## Chart and data needs
- **Every candle is an illustration.** No axes with prices, no ticker, no real market data, no times of day. Add a tiny `illustration` label in scene 1.
- **No numbers anywhere.** The time labels ("1 MINUTE", "1 HOUR", "1 DAY") are the only digits, and they name chart settings, not market figures.
- **Up is green, down is red** in this video (changed from white on 2026-11-13). The wicks scene highlights the wicks in white, because red now means down. Scene 4b must keep the `Colours vary by platform.` note, because many platforms use green and red.
- **The labelled candle is an up candle** in scenes 4a, 5 and 6, so OPEN is at the bottom of the body and CLOSE is at the top. Don't swap in a down candle without swapping the labels.

## Look
- Colours: black background, white text. Charts: **green = up or gain, red = down or loss** (changed 2026-11-13). Red is also the warning accent.
- Font: the same heavy sans-serif as the other videos.
- Cut pace: a visible change every 2 to 3 seconds. Scenes 2 and 5 are single-object shots, so the labels and pointers must do the moving.

## Music and sound
- Mood: calm, curious, steady. This is a lesson, not a warning, so it should feel lighter than the survival videos. No vocals. Well under the voice.
- Sound effects: a soft tick for each time label in scene 3, a light click as each pointer label lands, one firmer hit on `Survive first.`
- Use music you have the rights to: the toolkit's own library or TikTok's commercial library.

## Compliance must-haves (from the script's §6 check)
- `illustration` label in scene 1.
- `Colours vary by platform.` stays in scene 4b.
- No prices, no P&L, no trade calls. The video explains how a chart is drawn and nothing else.
- Disclaimer on screen for the whole video.

## Post package (from the script)
- **Caption:** How to read a candlestick: open, high, low, close. Trading basics, part 1. Educational only, not financial advice.
- **Hashtags:** #tradingforbeginners #candlesticks #learntotrade #tradingbasics #daytrading
- **Pinned comment:** Part 1 of Trading Basics. Did you already know what the wicks mean? Yes / No 👇
- **Cover:** one big candle with four arrows and "READ THIS FIRST". Dark background.
- **Before posting:** check TikTok's current rules on labelling AI-generated content and switch the label on if a synthetic voice counts.

## Review fixes (all approved by the director and applied)
- **E:** `Next: Part 2 · The stop loss` is on the end card.
- **F:** the caption no longer says "in 36 seconds".
- **G:** the ringed candle in scene 1 is tall and clear.

## Deliverables
1. `005-how-to-read-a-candle.mp4`: 1080×1920, H.264, about 37 seconds.
2. A cover image, 1080×1920.
3. The voiceover audio file on its own, so hook variants can be re-cut later without paying for the whole read again.

## Polished Reel (Remotion, 2026-11-13)
- Source: `tools/reel/src/Reel005.tsx`. Words are this brief's voiceover, unchanged.
- Render with captions: `cd tools/reel && npx remotion render src/index.ts Reel005 ../../renders/reel/005-reel-captions.mp4`
- Render without captions (for CapCut): add `--props='{"captions":false}'`
- Re-time to the CapCut voice: add the six clip lengths, e.g. `--props='{"captions":false,"durations":[5.6,4.1,6.3,8.9,5.7,6.6]}'`
- Voice: CapCut, male "sly villain" voice. Faceless for now: no portraits were provided.
