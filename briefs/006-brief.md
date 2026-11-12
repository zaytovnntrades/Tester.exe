# Production brief 006: What a stop loss is (Trading Basics, part 2)

- **Script:** `scripts/006-what-is-a-stop-loss.md` (status: approved)
- **Role in the series:** part 2 of Trading Basics. Post it after 005 (candles) and before 007 (leverage).
- **Visuals:** built in this repo. Rebuild the clean video with `node tools/studio/render.js tools/studio/006-draft.html renders/clean/006-clean.mp4 clean`.
- **Voice and captions:** added by the director in CapCut (see `briefs/capcut-handoff.md`; text in `briefs/vo/006-vo.txt`). Steady, lower, unhurried voice. Blunt coach. The same voice as every other video.
- **Format:** 1080×1920 vertical (9:16), 30 fps
- **Duration:** about 32 seconds of voice (81 words at 2.5 words per second) plus a 1-second end-card hold. Final length follows the real voiceover: send the six clip lengths and the scenes are re-timed to match.
- **Style:** faceless. Motion graphics and text only. Black, white and one red.
- **Platform:** TikTok first. Keep all text inside the safe area: clear of the top 220 px and bottom 420 px, and 120 px off the right edge. Check these against TikTok's current layout before the final export.

## Costs
The visuals are drawn in code and cost nothing. Voice and captions are made in CapCut, where some voices and tools need a paid plan: that is the director's call.

## Final voiceover text (read exactly as written)
> Every trade needs an exit before it needs an entry.
>
> No exit plan? Then a small loss can grow into a big one. Fast.
>
> A stop loss is an order. You set it before you enter. It closes your trade at a price you pick.
>
> Price hits it? You're out. Small loss. You trade again tomorrow.
>
> It's not a guarantee. Fast markets can jump past it. But it beats hoping.
>
> Exit first. Entry second. Practice it on sim. Survive first. Follow.

**Pronunciation notes:**
- "No exit plan?" and "Price hits it?" rise as questions, followed by a clear pause.
- "Fast." at the end of the second paragraph is its own beat, after a pause.
- "You're out." is flat and final. No rise.
- "sim" is said like "simulator" cut short, not spelled out.

## Scene list
Timings are estimates from word counts. They get locked to the real voice clips.

| # | Scene | Seconds | Visual | On-screen text |
|---|-------|---------|--------|----------------|
| 1 | Hook | 0.0–4.0 | Two numbered boxes: 1 holds ENTRY, 2 holds EXIT. On the word "exit" they swap places and EXIT fills red. | `1.` `2.` · `ENTRY` · `EXIT` (red after the swap) · then `Exit first.` |
| 2 | Stakes | 4.0–9.6 | A price line keeps falling, left to right, with nothing to stop it. A red bar labelled LOSS grows along the bottom, slowly at first and then faster. | `No exit plan?` · `Small loss → big loss.` · `LOSS` |
| 3 | Beat 1: what it is | 9.6–18.0 | A price line moving sideways. **The dashed red STOP LOSS line appears first** (on "You set it before you enter"), below the price. Only then does the white ENTRY dot appear on the price line. That order is the lesson. | `Stop loss` · `= an order that closes your trade` → `…at a price you pick.` · `STOP LOSS` · `ENTRY` |
| 4 | Beat 2: it works | 18.0–22.4 | From the entry dot, the price drops to the dashed line and stops exactly on it. The end dot turns red. A small bracket shows the distance between entry and stop. | `Hit → OUT.` · `small loss` · `Trade again tomorrow.` |
| 5 | Beat 3: its limit | 22.4–28.0 | The price runs above the stop line, then **jumps straight past it** (a dotted gap) and lands below the line. A red dot marks where the exit actually happens: lower than the stop. | `Not a guarantee.` · `GAP` · `can fill lower` · `Still beats hoping.` |
| 6 | CTA | 28.0–32.4 (+1.0 hold) | The two boxes from the hook, now in the new order: 1 EXIT (red), 2 ENTRY. A SIM stamp lands on "sim". Then the end card. | `Exit first. Entry second.` · `SIM` · `Survive first.` · `Follow` · `Next: Part 3 · Leverage` · `Zaytovnn Trades` |

**On every scene, bottom of the safe area, small but readable:** `Educational only — not financial advice.`

## Captions (added in CapCut)
2 to 4 words at a time, about two-thirds down the screen, above the disclaimer line. Key words in red `#FF2D3D`: exit, stop, out, guarantee, sim, survive.

## Chart and data needs
- **Every price line is an illustration.** No axes, no prices, no ticker, no real market data. `illustration` label in scenes 2 to 5.
- **No numbers anywhere.** No stop distances, no dollar amounts, no percentages. The "small loss" bracket has no value on it.
- **The trade shown is a buy**, so the stop sits below the entry. Don't flip it: one direction is enough for a beginner.

## Look
- Colours: near-black background, white text, one accent red. The dashed red line is the hero: it's the only dashed line in the video.
- Font: the same heavy sans-serif as the other videos.
- Cut pace: a visible change every 2 to 3 seconds, hard cuts between scenes.

## Music and sound
- Mood: steady and firm. Slight tension in scene 2 (the falling line), released in scene 4 when the stop does its job. No vocals. Well under the voice.
- Sound effects: a snap when the boxes swap, a low slide under the falling line, a click when the stop line appears, a firm hit on `OUT.`, a short skip sound on the gap.
- Use a track you're allowed to use on a business or creator account.

## Compliance must-haves (from the script's §6 check)
- **Scene 5 must stay in every cut.** Scene 3 says the stop closes the trade "at a price you pick"; scene 5 corrects that. Without scene 5 the video overpromises (rule §6.2).
- `can fill lower` stays on screen for at least 2 seconds.
- No trade calls. The commands are about a habit only.
- If a real futures or forex chart is ever added, add `Leverage magnifies losses` on screen.
- Disclaimer on screen for the whole video.

## Post package (from the script)
- **Caption:** What a stop loss is, and the one thing it can't promise. Trading basics, part 2. Practice on sim. Educational only, not financial advice.
- **Hashtags:** #tradingforbeginners #stoploss #riskmanagement #tradingbasics #learntotrade
- **Pinned comment:** Part 2 of Trading Basics. Be honest: have you ever moved your stop because you "felt" it would come back? 👇
- **Cover:** "EXIT FIRST" in white above a dashed red line, a price line stopping on it. Dark background.
- **Before posting:** check TikTok's current rules on labelling AI-generated content and switch the label on if a synthetic voice counts.

## Deliverables
1. `006-clean.mp4` from this repo: 1080×1920, no voice, no captions.
2. `006-final.mp4` from CapCut: with voice, captions and music.
3. A cover image, 1080×1920.
