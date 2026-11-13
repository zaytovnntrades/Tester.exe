# Production brief 004: Max daily loss

- **Script:** `scripts/004-max-daily-loss.md` (status: approved)
- **Format:** 1080×1920 vertical (9:16), 30 fps
- **Duration:** about 34 seconds (85 words at 2.5 words per second). Final length follows the voiceover: time the scenes to the audio.
- **Style:** faceless. Motion graphics and text only. Same look as brief 001 so the channel reads as one series.
- **Voice and captions:** added by the director in CapCut (see `briefs/capcut-handoff.md`; text in `briefs/vo/004-vo.txt`). Steady, lower, unhurried voice. Blunt coach. The same voice as every other video.
- **Visuals:** built in this repo. Rebuild the clean video with `node tools/studio/render.js tools/studio/004-draft.html renders/clean/004-clean.mp4 clean`.
- **Platform:** TikTok first. Keep all text inside the safe area: clear of the top 220 px and bottom 420 px, and 120 px off the right edge. Check these against TikTok's current layout before the final export.

## Costs
The visuals are drawn in code and cost nothing. Voice and captions are made in CapCut, where some voices and tools need a paid plan: that is the director's call.

## Final voiceover text (read exactly as written)
> One bad day can end your account. One number can stop it.
>
> You lose. You get angry. You trade bigger to win it back. That's the spiral.
>
> The fix is a max daily loss. One number. The most you're allowed to lose today.
>
> Set it before the market opens. Calm. Not in the middle of a losing streak.
>
> Hit the number? You're done. Close the platform. No last trade. Practice that on sim first.
>
> One bad day. One number. Set yours tonight. Survive first. Follow.

**Pronunciation notes:** full stops are real pauses. The short sentences ("You lose." "Calm." "You're done.") each need their own beat: don't let the voice run them together. "Hit the number?" rises as a question. Flat, firm delivery on "No last trade."

## Scene list
Timings are estimates from word counts. Lock them to the real audio.

| # | Scene | Seconds | Visual | On-screen text |
|---|-------|---------|--------|----------------|
| 1 | Hook | 0.0–5.0 | Black background. A white account line runs flat, then drops off a cliff **within the first 2 seconds**. On "One number can stop it", a red horizontal line snaps in and the fall freezes against it. | `1 bad day.` then `1 number.` |
| 2 | Stakes | 5.0–10.5 | A four-step loop: Lose → Angry → Bigger → Lose more. Each word lights up on its sentence. The loop spins faster each lap and a "position size" bar grows every turn. | `Lose → Angry → Bigger → Lose more` · on the last sentence: `The spiral.` |
| 3 | Beat 1: the rule | 10.5–16.5 | Back to the red horizontal line from scene 1. A label types onto it. The account line approaches it and stops. | `MAX DAILY LOSS` · `The most you can lose today.` |
| 4 | Beat 2: when to set it | 16.5–22.0 | A clock showing "before the open", then a sticky note being written and stuck to a monitor edge. **The number on the note stays blank** (a line or box, no digits). | `Set it BEFORE the open.` · `Calm. Not mid-streak.` |
| 5 | Beat 3: obey it | 22.0–28.5 | The line touches the red line. Big `DONE.` stamp. A laptop lid closes. On the last sentence a `SIM` badge appears in the corner. | `Hit it → DONE.` · `No last trade.` · `Practice on sim first.` |
| 6 | CTA | 28.5–34.0 | Replay of scene 1 in two seconds, but this time the line stops at the red line and stays flat (the loop back to the hook). End on the channel name. | `1 bad day. 1 number.` · `Survive first.` · `Follow` · `Zaytovnn Trades` |

**On every scene, bottom of the safe area, small but readable:** `Educational only — not financial advice.`

## Captions (added in CapCut)
2 to 4 words at a time, about two-thirds down the screen, above the disclaimer line, key word in red `#FF2D3D` (bad day, number, spiral, before, done, survive).

## Chart and data needs
- **The account line is an illustration, not real data.** No axes, no dollar values, no percentages, no platform screenshots. Add a tiny `illustration` label in scene 1 so nobody reads it as a real account.
- **No figures anywhere.** The sticky note is blank on purpose: a dollar amount would read as advice, and rule §6.6 needs a source for any number.
- No real market data is needed in this video.

## Look
- Colours: black background, white text. Charts: **green = up or gain, red = down or loss** (changed 2026-11-13). Red is also the warning accent. The red line is the hero of the video: nothing else on screen is red until `DONE.`
- Font: the same heavy sans-serif as video 001.
- Cut pace: a visible change every 2 to 3 seconds, hard cuts between scenes.

## Music and sound
- Mood: tense build through scenes 1 and 2, then it drops to calm and steady from scene 3, when the rule arrives. No vocals. Well under the voice.
- Sound effects: a falling whoosh and a hard stop in scene 1, a rising tick for each lap of the spiral, a stamp on `DONE.`, a soft click for the laptop lid.
- Use music you have the rights to: the toolkit's own library or TikTok's commercial library.

## Compliance must-haves (from the script's §6 check)
- No dollar amounts, percentages or P&L anywhere on screen.
- The account line carries the `illustration` label.
- If any real futures chart is added later, add `Leverage magnifies losses` on screen.
- Disclaimer on screen for the whole video.
- No trade calls. The commands in this video are about a habit only.

## Post package (from the script)
- **Caption:** One number that stops one bad day from ending your account: a max daily loss. Practice it on sim first. Educational only, not advice.
- **Hashtags:** #riskmanagement #tradingforbeginners #daytrading #tradingpsychology #learntotrade
- **Pinned comment:** Do you have a max daily loss rule? Yes / No / "I break it" 👇 Be honest.
- **Cover:** "1 BAD DAY" in white over a falling line, a red bar cutting across with "1 NUMBER". Dark background.
- **Before posting:** check TikTok's current rules on labelling AI-generated content and switch the label on if a synthetic voice counts.

## Deliverables
1. `004-max-daily-loss.mp4`: 1080×1920, H.264, about 34 seconds.
2. A cover image, 1080×1920.
3. The voiceover audio file on its own, so hook variants can be re-cut later without paying for the whole read again.
