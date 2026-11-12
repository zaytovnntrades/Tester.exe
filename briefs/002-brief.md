# Production brief 002: Why Fed day is for trading smaller

- **Script:** `scripts/002-fed-day-trade-smaller.md` (status: approved)
- **Role in the series:** this is the "Part 2" that video 001 promises ("the day the market itself turns on you"). Post it straight after 001.
- **Format:** 1080×1920 vertical (9:16), 30 fps
- **Duration:** about 37.5 seconds (94 words at 2.5 words per second). Final length follows the voiceover: time the scenes to the audio.
- **Style:** faceless. Motion graphics and text only. Same look as videos 001 and 004.
- **Voice and captions:** added by the director in CapCut (see `briefs/capcut-handoff.md`; text in `briefs/vo/002-vo.txt`). Steady, lower, unhurried voice. Blunt coach. The same voice as every other video.
- **Visuals:** built in this repo. Rebuild the clean video with `node tools/studio/render.js tools/studio/002-draft.html renders/clean/002-clean.mp4 clean`.
- **Platform:** TikTok first. Keep all text inside the safe area: clear of the top 220 px and bottom 420 px, and 120 px off the right edge. Check these against TikTok's current layout before the final export.
- **Shelf life:** the video refers to the October 28, 2026 Fed decision. Post it before the next Fed meeting (check the date on the Fed's own calendar). After that, it needs a new hook.

## Costs
The visuals are drawn in code and cost nothing. Voice and captions are made in CapCut, where some voices and tools need a paid plan: that is the director's call.

## Final voiceover text (read exactly as written)
> October twenty-eighth. The Fed did nothing. That's the kind of day that hurts beginners.
>
> Rates held. Three and three-quarters to four percent. But the vote split. Ten to two. Both dissenters wanted a hike.
>
> Split votes mean nobody's sure what's next. Unsure markets can swing hard. Both ways.
>
> MES and MNQ are leveraged. Leverage magnifies your losses. Exactly as much as your gains.
>
> So Fed day isn't for guessing. Cut your size. Or stay on sim. I'm on sim.
>
> The Fed did nothing. Make sure it does nothing to your account. Survive first. Follow.

**Pronunciation notes:**
- "MES" and "MNQ" are read as letters: "M-E-S" and "M-N-Q". If the voice tool reads them as words, type them with hyphens in the tool.
- "The Fed" as written. Don't expand it to "Federal Reserve".
- "Ten to two" is a vote count, not a time. A short pause before and after it.
- Full stops are real pauses. "Both ways." and "I'm on sim." each get their own beat.

## Scene list
Timings are estimates from word counts. Lock them to the real audio.

| # | Scene | Seconds | Visual | On-screen text |
|---|-------|---------|--------|----------------|
| 1 | Hook | 0.0–5.5 | Black background. A flat white line labelled "RATES" holds perfectly still. **Within the first 2 seconds**, a second line behind it (price, drawn as an illustration) starts whipping up and down. | `Oct 28` · `The Fed did NOTHING.` then `So why is it risky?` |
| 2 | Stakes | 5.5–13.5 | The rate range lands large. Then twelve dots appear in a row: ten grey, two red. The two red dots pulse on "wanted a hike". Source line fades in. | `3.75–4.00%` · `HELD` · then `Vote: 10–2` · `2 wanted a HIKE` · source line: `Source: Federal Reserve FOMC statement, Oct 28, 2026` |
| 3 | Beat 1: uncertainty | 13.5–19.0 | The twelve dots split apart into two groups. Below them, illustrated candles get taller in both directions, up and down. | `Split vote` → `Nobody's sure` → `Bigger swings. Both ways.` |
| 4 | Beat 2: leverage | 19.0–25.0 | A small red candle. A magnifying glass slides over it and it becomes a large red candle. Then the same for a green one, same size, to show it cuts both ways. | `MES · MNQ = leveraged` · `⚠️ Leverage magnifies LOSSES` |
| 5 | Beat 3: the plan | 25.0–31.0 | A calendar page with "FED DAY" circled in red. A position-size slider is pulled down to small. On "I'm on sim", a `SIM` badge stamps into the corner. | `Fed day plan:` · `1. Cut your size` · `2. Or stay on sim` |
| 6 | CTA | 31.0–37.5 | Back to scene 1's flat "RATES" line (the loop). A second flat line appears beside it, labelled "YOUR ACCOUNT", and stays flat too. End on the channel name. | `The Fed did nothing.` · `Survive first.` · `Follow` · `Zaytovnn Trades` |

**On every scene, bottom of the safe area, small but readable:** `Educational only — not financial advice.`

## Captions (added in CapCut)
2 to 4 words at a time, about two-thirds down the screen, above the disclaimer line, key word in red `#FF2D3D` (nothing, split, hike, losses, size, sim, survive).

## Chart and data needs
- **The only real figures are the three from the Fed statement:** the 3.75–4.00% range, the 10–2 vote, and two dissenters who preferred a quarter-point raise. They trace to `research/2026-11-11.md#4`. Show nothing else as fact.
- **The price line and candles are illustrations, not market data.** No axes, no ticker, no prices, no times. We have no sourced price data for that day, so the video must not look like it shows what the market actually did. Add a tiny `illustration` label in scenes 1 and 3.
- **No contract math.** No tick values, margin amounts or dollar figures: none are sourced yet.
- **No names on screen.** The two dissenters are in the source, but the video doesn't need them.

## Look
- Colours: near-black background, white text, one accent red. The two red dots in scene 2 are the visual centre of the video.
- Font: the same heavy sans-serif as videos 001 and 004.
- Cut pace: a visible change every 2 to 3 seconds, hard cuts between scenes.

## Music and sound
- Mood: quiet and uneasy at the start (the "nothing happened" calm), tension rising through scenes 2 and 3, then settling to steady from scene 5 when the plan arrives. No vocals. Well under the voice.
- Sound effects: a low hum for the flat line, a sharp crackle when the price line starts whipping, two distinct ticks for the red dots, a slide for the size slider, a stamp for `SIM`.
- Use music you have the rights to: the toolkit's own library or TikTok's commercial library.

## Compliance must-haves (from the script's §6 check)
- `⚠️ Leverage magnifies LOSSES` stays on screen for the whole of scene 4, at least 3 seconds (rule §6.4).
- The source line in scene 2 stays on screen for at least 2 seconds.
- Illustrated lines and candles carry the `illustration` label.
- No direction calls, no price levels, no "the market will". The video teaches sizing only.
- The `SIM` badge appears with "I'm on sim". No P&L anywhere.
- Disclaimer on screen for the whole video.

## Post package (from the script)
- **Caption:** The Fed held rates, but the vote split 10–2. Why event days are for trading small. Leverage magnifies losses. Educational only, not advice.
- **Hashtags:** #futurestrading #MES #MNQ #riskmanagement #tradingforbeginners
- **Pinned comment:** Do you trade on Fed days, go smaller, or sit out? Tell me which and why 👇 Source: Federal Reserve FOMC statement, Oct 28, 2026.
- **Cover:** "The Fed did NOTHING" in white, "…so why is it risky?" in red underneath. Flat line graphic. Dark background.
- **Before posting:** check TikTok's current rules on labelling AI-generated content and switch the label on if a synthetic voice counts.

## Deliverables
1. `002-fed-day-trade-smaller.mp4`: 1080×1920, H.264, about 37 seconds.
2. A cover image, 1080×1920.
3. The voiceover audio file on its own, so hook variants can be re-cut later without paying for the whole read again.
