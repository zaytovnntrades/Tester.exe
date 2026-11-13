# Reel and TikTok production system: Zaytovnn Trades

One page for how a video goes from idea to posted. It overrides the defaults in CLAUDE.md where they differ.
Last updated 2026-11-13.

## The daily loop
| Step | What happens | Who | Where it lands |
|------|--------------|-----|----------------|
| 1. Topic | Take the next day from the 30-day plan. Post ★ critical days first if you have to skip any. | Plan | `ideas/calendar-30-day.md` |
| 2. Script | Hook (under 3 seconds), stakes, 3 lesson beats, CTA. 30–45 seconds. Compliance check at the bottom. | Claude writes, you approve | `scripts/###-*.md` |
| 3. Visuals | Silent, caption-free video drawn in code. | Claude | `renders/clean/###-clean.mp4` |
| 4. Voice | Paste the six paragraphs into CapCut text-to-speech. Voice: **the male "sly villain" voice in CapCut** (your choice, 2026-11-13). Same voice every video. | You | CapCut |
| 5. Re-time | Send the six clip lengths. The video is re-rendered so every cut lands on your voice. | You → Claude | `renders/` |
| 6. Captions, music, export | CapCut auto-captions, proofread. Highlight the red headline word. Music under the voice. | You | `###-final.mp4` |
| 7. Pre-post check | Compliance (CLAUDE.md §6) and a quick editorial score. | Claude | `published/` |
| 8. Post | TikTok and Instagram Reels, same file. Use the caption, hashtags and pinned comment from the script. | You | — |
| 9. Stats | After 48 hours, paste the numbers. Every 10 posts, the plan is re-ranked. | You → Claude | `published/log.csv`, `ideas/insights.md` |

## Script rules (checked automatically for days 7–30)
- **Hook: 7 spoken words or fewer**, which is under 3 seconds at the channel's pace. Days 1–6 keep their approved 4–5 second hooks.
- **Length: 30–45 seconds** of voice (about 75–110 words).
- **One idea per beat.** Three beats, never more.
- **CTA:** every video ends on "Survive first. Follow." plus an on-screen "Next:" line naming tomorrow's topic.
- **No figures** unless they're in `research/` with a URL and date. **No real market data:** every chart is labelled "illustration".
- **Leverage warning** on screen in every scene of any futures, forex or prop-firm video.

## Chart colours
- Background black. **Green = up or gain, red = down or loss** on every candle, bar and line (changed 2026-11-13).
- White = neutral. Red is also the warning accent in headlines; green headline words mark an up or gain idea.

## Captions (on screen)
- 2 to 4 words at a time, on one line, about two-thirds of the way down the screen.
- White, heavy font, dark box behind. The key word in red `#FF2D3D`.
- Always above the "Educational only — not financial advice." line, never on top of it.

## TikTok and Instagram Reels: what differs
| | TikTok | Instagram Reels |
|-|--------|-----------------|
| Format | 9:16, 1080×1920 | 9:16, 1080×1920 (same file) |
| Safe area used here | text inside 60–960 px across, 220–1500 px down | the same box, chosen to clear the top bar, bottom caption block and side buttons. Check it against each app's current layout before export: both change. |
| Cover | frame 0 is the cover, so every video opens with its first headline or hook graphic already on screen | pick the first frame as the cover, or upload the cover image |
| CTA wording | "Follow" | "Follow" works the same. "Link in bio" points to the YouTube hub. |
| AI voice label | check TikTok's current AI-generated content setting and switch it on if a synthetic voice counts | check Instagram's current "AI info" label rules and switch it on if they apply |
| Hashtags | 3–5 from the script | the same 3–5 |

Check each app's own help pages for the current label rules: they change, and this file can't keep up with them.

## Tools: which one, and when
| Tool | Used for | Not used for |
|------|----------|--------------|
| **Scrapling** (`tools/scout/`) | Public RSS feeds and official pages: central banks, regulators. Example: the Fed's meeting calendar, which fixes day 6's deadline. | TikTok, YouTube, Instagram or X. Logins, paywalls, bot checks. |
| **Video Watch** (claude-video plugin) | Breaking down a reference Short **you give me**: hook, cuts, pacing. Structure only. | Copying any creator's words, footage or look. Not installed in this cloud session; use it on your computer. |
| **Remotion** (the toolkit's renderer) | The polished Reels: `tools/reel/`. Reel 005 is built. | — |
| **Canvas drafts** (`tools/studio/`) | Fast clean visuals for all 30 days. | Final polish: that's Remotion's job. |
| **Hyperframes** | Not used. Remotion already covers everything; a second renderer would mean two looks and two sets of bugs. | — |
| **claude-code-video-toolkit** | Workflow reference: its renderer (Remotion) and its 9:16 rules (frame 0 is the cover, no text under 28 px, check the render frame by frame). Cloned beside this repo. Reel 005 follows these rules; it was not built through the toolkit's `/video` command or its Python 9:16 template. | Its paid voice and image steps: you voice in CapCut. Its QC script was not run in the cloud session. |
| **Zernio** (MCP) | Saved in `.mcp.json`; its host is allowed in the Tester.exe environment. **Needs your sign-in** before any tool works (the server answers "sign in required"). Could post or schedule to your accounts. | **Nothing is posted or scheduled without your explicit OK for that post.** Not used to pull analytics, because CLAUDE.md says only stats you paste. |

## Originality
- Never copy a creator's script, hook wording, footage, music or visual style. Breakdowns note **structure** only (hook type, cut pace, where the payoff lands).
- All visuals here are drawn from scratch. All scripts are written from the channel's own rules and sources.

## Not set up yet
- **Your portraits and visual references.** The Reel is faceless until you upload them.
- **Video Watch** in this cloud session.
