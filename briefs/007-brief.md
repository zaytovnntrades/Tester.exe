# Production brief 007: What leverage is (Trading Basics, part 3)

- **Script:** `scripts/007-what-is-leverage.md` (status: approved, with the shorter hook from review fix H)
- **Role in the series:** part 3 of Trading Basics. Post it after 006 (stop loss). Its end card points to 004 (max daily loss).
- **Visuals:** built in this repo. Rebuild the clean video with `node tools/studio/render.js tools/studio/007-draft.html renders/clean/007-clean.mp4 clean`.
- **Voice and captions:** added by the director in CapCut (see `briefs/capcut-handoff.md`; text in `briefs/vo/007-vo.txt`). Steady, lower, unhurried voice. Blunt coach. The same voice as every other video.
- **Format:** 1080×1920 vertical (9:16), 30 fps
- **Duration:** about 31 seconds of voice (78 words at 2.5 words per second) plus a 1-second end-card hold. Final length follows the real voiceover: send the six clip lengths and the scenes are re-timed to match.
- **Style:** faceless. Motion graphics and text only. Black background, white text; charts in green (up) and red (down).
- **Platform:** TikTok first. Keep all text inside the safe area: clear of the top 220 px and bottom 420 px, and 120 px off the right edge. Check these against TikTok's current layout before the final export.

## Costs
The visuals are drawn in code and cost nothing. Voice and captions are made in CapCut, where some voices and tools need a paid plan: that is the director's call.

## Final voiceover text (read exactly as written)
> A small account can control a big trade. That's the danger.
>
> It magnifies everything. Your wins. And your losses.
>
> Here's how. You put down a small deposit. It's called margin. It controls a much bigger position.
>
> So a small move in price becomes a big move in your account. Both ways.
>
> Futures and forex are leveraged. Losses can be bigger than your deposit. Fast.
>
> Learn it on sim. With the smallest size. I'm on sim. Survive first. Follow.

**Pronunciation notes:**
- A clear pause before "That's the danger." It's the turn of the hook.
- "Your wins. And your losses." Slightly more weight on "losses".
- "margin" as in the edge of a page: MAR-jin.
- "Both ways." and "Fast." are each their own beat, after a pause.
- "forex" is said FOR-ex.
- "I'm on sim." is plain and matter-of-fact, not apologetic.

## Scene list
Timings are estimates from word counts. They get locked to the real voice clips.

| # | Scene | Seconds | Visual | On-screen text |
|---|-------|---------|--------|----------------|
| 1 | Hook | 0.0–4.4 | A small white square (ACCOUNT) on the left, joined by a line to a box on the right (TRADE). The TRADE box grows to several times the size. On "That's the danger" its outline and label turn red. | `Small account.` · `Big trade.` · `That's the danger.` (red) · `ACCOUNT` · `TRADE` |
| 2 | Stakes | 4.4–7.6 | Two small candles, a white one (gain) and a red one (loss). A magnifying lens slides over the white one and it grows; then over the red one, and it grows by exactly the same amount. | `Leverage = magnifier` · `GAIN` · `LOSS` |
| 3 | Beat 1: margin | 7.6–14.4 | A short solid bar on the left. Its label reads DEPOSIT, then changes to MARGIN when the word is spoken. On the last sentence a tall outlined bar grows next to it. | `How it works` · `DEPOSIT` → `MARGIN` / `(your deposit)` · `POSITION` / `(what you control)` |
| 4 | Beat 2: both ways | 14.4–20.4 | Two gauges on a shared zero line. PRICE rises a little; YOUR ACCOUNT rises a lot (both white). Then both swing below the line: PRICE dips a little, YOUR ACCOUNT drops a lot (both red). | `Small move → big move` · `PRICE` · `YOUR ACCOUNT` · `Both ways.` (red) |
| 5 | Beat 3: the warning | 20.4–25.6 | The red warning banner is up for the whole scene. Below it, a white DEPOSIT bar. A red LOSS bar grows from zero, reaches the deposit's length (marked with a dashed line) and keeps going past it. | `Futures · Forex` / `= leveraged` · `⚠ LEVERAGE MAGNIFIES LOSSES` · `DEPOSIT` · `LOSS` · `can be bigger than your deposit` |
| 6 | CTA | 25.6–31.2 (+1.0 hold) | A large SIM stamp lands centre screen on "I'm on sim", then moves to the corner as the end card comes in. | `Learn it on sim.` · `Smallest size.` · `SIM` · `Survive first.` · `Follow` · `Next: the one number that protects your account` · `Zaytovnn Trades` |

**On every scene, bottom of the safe area, small but readable:** `Educational only — not financial advice.`

## Captions (added in CapCut)
2 to 4 words at a time, about two-thirds down the screen, above the disclaimer line. Key words in red `#FF2D3D`: danger, losses, margin, leveraged, sim, survive.

## Chart and data needs
- **Every bar, box and gauge is an illustration.** No axes, no values, no real market data. `illustration` label in scenes 3, 4 and 5.
- **No numbers and no ratios anywhere.** No "10×", no margin amounts, no contract sizes. Real margin differs by product and broker, and none of it is sourced in `research/` (rule §6.6). The sizes of the shapes show "small" and "big" without stating a ratio.
- **Equal growth in scene 2.** The gain candle and the loss candle must grow by the same amount. That is the whole point of the scene.

## Look
- Colours: black background, white text. Charts: **green = up or gain, red = down or loss** (changed 2026-11-13). Red is also the warning accent. Green means gain; white means neutral; red means loss or danger. Keep that consistent in every scene.
- Font: the same heavy sans-serif as the other videos.
- Cut pace: a visible change every 2 to 3 seconds, hard cuts between scenes.

## Music and sound
- Mood: uneasy and building through scenes 1 to 5, then settling when "Learn it on sim" arrives. No vocals. Well under the voice.
- Sound effects: a stretch sound as the TRADE box grows, a lens swish in scene 2, a rising tone as the LOSS bar passes the deposit mark, a stamp on `SIM`.
- Use a track you're allowed to use on a business or creator account.

## Compliance must-haves (from the script's §6 check)
- The `LEVERAGE MAGNIFIES LOSSES` banner stays up for all of scene 5, at least 3 seconds (rule §6.4).
- The line stays "Losses **can be** bigger than your deposit". It is true for futures; for forex it depends on the country and broker. Don't harden it to "will be" or soften it away.
- "I'm on sim" matches `about-me.md`. No P&L and no account screenshots anywhere.
- No product or broker is named or shown. Nothing recommends trading futures or forex.
- Disclaimer on screen for the whole video.

## Post package (from the script)
- **Caption:** Leverage explained: small deposit, big position, and why losses grow as fast as wins. Trading basics, part 3. Educational only, not advice.
- **Hashtags:** #tradingforbeginners #leverage #futurestrading #tradingbasics #riskmanagement
- **Pinned comment:** Part 3 of Trading Basics. Did anyone explain margin to you before you first heard "leverage"? 👇
- **Cover:** a small box and a huge box joined by a line, "SMALL ACCOUNT. BIG TRADE." and a red warning triangle.
- **Before posting:** check TikTok's current rules on labelling AI-generated content and switch the label on if a synthetic voice counts.

## Deliverables
1. `007-clean.mp4` from this repo: 1080×1920, no voice, no captions.
2. `007-final.mp4` from CapCut: with voice, captions and music.
3. A cover image, 1080×1920.
