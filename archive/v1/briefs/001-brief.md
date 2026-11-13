# Production brief 001: 3 red flags from a $130M fraud case

- **Script:** `scripts/001-risk-free-red-flags.md` (status: approved)
- **Format:** 1080×1920 vertical (9:16), 30 fps
- **Duration:** about 38.5 seconds (96 words at 2.5 words per second). Final length follows the voiceover: time the scenes to the audio, not the other way round.
- **Style:** faceless. Motion graphics and text only. No stock footage of people, no real company logos, no real firm names.
- **Voice and captions:** added by the director in CapCut (see `briefs/capcut-handoff.md`; text in `briefs/vo/001-vo.txt`). Steady, lower, unhurried voice. Blunt coach. The same voice as every other video.
- **Visuals:** built in this repo. Rebuild the clean video with `node tools/studio/render.js tools/studio/001-draft.html renders/clean/001-clean.mp4 clean`.
- **Platform:** TikTok first. Keep all text inside the safe area: clear of the top 220 px and bottom 420 px, and 120 px off the right edge where the buttons sit. Check these against TikTok's current layout before the final export.

## Costs
The visuals are drawn in code and cost nothing. Voice and captions are made in CapCut, where some voices and tools need a paid plan: that is the director's call.

## Final voiceover text (read exactly as written)
> Two words helped take a hundred and thirty million dollars from everyday investors.
>
> The SEC says a so-called wealth-sharing program promised risk-free returns. From crypto trading signals.
>
> Red flag one. Risk-free. Every real trade has risk. Anyone who says otherwise is selling. Not trading.
>
> Red flag two. Just follow our signals. You hand over your decisions. Then your money.
>
> Red flag three. We're SEC registered. The SEC says that was false. Check any firm yourself. Investor dot gov.
>
> Survive the people first. Then the market. Follow. Next up: the day the market itself turns on you.

**Pronunciation notes:** "SEC" as three letters, S-E-C. "Investor dot gov" exactly as written. Full stops are real pauses: don't let the voice run sentences together. Put a slightly longer pause after each "Red flag one / two / three."

## Scene list
Timings are estimates from word counts. Lock them to the real audio.

| # | Scene | Seconds | Visual | On-screen text |
|---|-------|---------|--------|----------------|
| 1 | Hook | 0.0–5.0 | Black background. The figure $130,000,000+ slams in at full size **in the first half second**, with a small screen shake. No count-up: a running counter would show in-between figures that are in no source. Below it, two blurred words. | `$130,000,000+` · `2 words.` · small tag under the counter from the first frame: `SEC complaint` |
| 2 | Stakes | 5.0–11.0 | The blur lifts: "RISK-FREE" stamps in red, in quotation marks. Small source line fades in at the bottom of the safe area. | `"RISK-FREE RETURNS"` · tag: `ALLEGED` · source line: `Source: SEC press release 2026-110, Oct 29, 2026` |
| 3 | Red flag 1 | 11.0–18.0 | Red flag icon drops in top-left with a "1". A simple line chart draws itself and goes down as well as up. | `🚩 1` · `"Risk-free" = not real` |
| 4 | Red flag 2 | 18.0–24.0 | Flag "2". A phone notification mock-up reading "BUY NOW ↑↑" slides in and gets swiped away. Generic phone frame, no real app design. | `🚩 2` · `"Just follow our signals"` |
| 5 | Red flag 3 | 24.0–31.5 | Flag "3". A plain search bar types "firm name…" and a result card flips to a red ✗. Then the text "Investor.gov" lands large. | `🚩 3` · `"We're registered"` → `Check it: Investor.gov` |
| 6 | CTA | 31.5–38.5 | Cut back to the $130,000,000+ figure from scene 1 (the loop). It shrinks to the top; "Survive first." takes the centre. End on the channel name. | `Survive first.` · `Follow for Part 2` · `Zaytovnn Trades` |

**On every scene, bottom of the safe area, small but readable:** `Educational only — not financial advice.`

## Captions (added in CapCut)
2 to 4 words at a time, about two-thirds down the screen, above the disclaimer line, key word in red `#FF2D3D` (risk-free, signals, registered, survive).

## Chart and data needs
- **Scene 1:** the figure lands at once, with no count-up. It is "more than $130 million", so always show the `+`.
- **Scene 3:** one generic line chart with no axes, no ticker and no real price data. It only needs to show that lines go down too.
- No real market data is needed anywhere in this video.

## Look
- Colours: black background, white text. Charts: **green = up or gain, red = down or loss** (changed 2026-11-13). Red is also the warning accent. Nothing else.
- Font: one heavy sans-serif for headlines, the same family in regular for small text.
- Cut pace: a visible change every 2 to 3 seconds (new text, icon, or movement), hard cuts between scenes.

## Music and sound
- Mood: tense, minimal, low pulse. Think investigation, not hype. No vocals. Keep it well under the voice.
- Sound effects: a hit when the figure lands, a stamp for "RISK-FREE", a soft thud for each flag, a swipe in scene 4.
- Use music you have the rights to: the toolkit's own library or TikTok's commercial library.

## Compliance must-haves (from the script's §6 check)
- "RISK-FREE" always appears in quotation marks and is always being warned against.
- These are SEC allegations. Keep the `SEC complaint` tag in scene 1 from the first frame and the `ALLEGED` tag in scene 2, and never show the company names.
- The source line in scene 2 stays on screen for at least 2 seconds.
- Disclaimer on screen for the whole video.
- No P&L, no account screenshots, no trade calls.

## Post package (from the script)
- **Caption:** 3 red flags from a $130M fraud case charged by the SEC. If you hear "risk-free," leave. Educational only, not financial advice.
- **Hashtags:** #tradingforbeginners #scamalert #riskmanagement #daytrading #learntotrade
- **Pinned comment:** Which red flag have you seen in your DMs? 🚩1 "risk-free" · 🚩2 "follow our signals" · 🚩3 "we're registered". Source: SEC press release 2026-110 (Oct 29, 2026).
- **Cover:** red "RISK-FREE" stamp crossed out, big "$130M" above it, small "3 red flags" below. Dark background.
- **Before posting:** check TikTok's current rules on labelling AI-generated content and switch the label on if a synthetic voice counts.

## Deliverables
1. `001-risk-free-red-flags.mp4`: 1080×1920, H.264, about 38 seconds.
2. A cover image, 1080×1920.
3. The voiceover audio file on its own, so hook variants can be re-cut later without paying for the whole read again.
