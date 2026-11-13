# 30-day content calendar: Trading Basics for beginners

One video a day for 30 days. Every video teaches one beginner idea in 25 to 45 seconds.
Days are numbered, not dated: day 1 is whichever day you post the first video.
Days 7 to 30 are generated from `tools/studio/series.js`; re-run `node tools/studio/gen-scripts.js` after any change.

**★ Critical:** the survival-first ideas. If you can only post some days, post the ★ ones first. Posting order stays as listed, because each end card names the next day's video.
**Hooks:** days 7 to 30 open in 7 words or fewer (under 3 seconds). Days 1 to 6 keep their approved hooks, which run 4 to 5 seconds.
**Status key:** approved = you signed it off · draft = written, waiting for your approval. Every video has a clean (no-caption) render ready for CapCut.

## Week 1 · Foundations
| Day | Video | Critical | Topic | Pillar | Length | Status | Hook |
|-----|-------|----------|-------|--------|--------|--------|------|
| 1 | 005 |  | How to read a candle | 2 | 36s | approved | You'll see this shape on almost every trading chart. Can you read it? |
| 2 | 006 | ★ | What a stop loss is | 1 | 32s | approved | Every trade needs an exit before it needs an entry. |
| 3 | 007 | ★ | What leverage is | 2 | 31s | approved | A small account can control a big trade. That's the danger. |
| 4 | 004 | ★ | Max daily loss | 1 | 34s | approved | One bad day can end your account. One number can stop it. |
| 5 | 001 | ★ | 3 red flags from a $130M fraud case | 1 | 38s | approved | Two words helped take a hundred and thirty million dollars from everyday investors. |
| 6 | 002 |  | Why Fed day is for trading smaller | 2 | 38s | approved | October twenty-eighth. The Fed did nothing. That's the kind of day that hurts beginners. |
| 7 | 008 |  | Up, down, sideways | 2 | 31s | draft | Which way is the market going? |

## Week 2 · Chart reading, orders and direction
| Day | Video | Critical | Topic | Pillar | Length | Status | Hook |
|-----|-------|----------|-------|--------|--------|--------|------|
| 8 | 009 |  | Support and resistance | 2 | 31s | draft | Price has floors and ceilings. |
| 9 | 010 |  | What volume tells you | 2 | 31s | draft | Those bars under your chart? That's volume. |
| 10 | 011 |  | Bid, ask and spread | 2 | 32s | draft | Every trade has two prices. Not one. |
| 11 | 012 |  | Market vs limit orders | 2 | 36s | draft | The wrong click costs you money. |
| 12 | 013 |  | What slippage is | 2 | 31s | draft | You clicked one price. Got another. |
| 13 | 014 |  | Long vs short | 2 | 31s | draft | You can trade a falling market. |
| 14 | 015 | ★ | What sim trading is | 1 | 31s | draft | Don't learn to trade with real money. |

## Week 3 · Risk, and the futures basics
| Day | Video | Critical | Topic | Pillar | Length | Status | Hook |
|-----|-------|----------|-------|--------|--------|--------|------|
| 15 | 016 | ★ | Position size | 1 | 32s | draft | Not where to enter. How much. |
| 16 | 017 |  | Risk vs reward | 1 | 32s | draft | Two questions before every trade. |
| 17 | 018 |  | Why win rate lies | 1 | 31s | draft | Win most trades. Still lose money. |
| 18 | 019 | ★ | What drawdown means | 1 | 30s | draft | Every trader meets this word. Drawdown. |
| 19 | 020 |  | What a futures contract is | 2 | 32s | draft | Futures sound complicated. They're agreements. |
| 20 | 021 |  | What micro futures are | 2 | 31s | draft | Futures come in sizes. Know the smallest. |
| 21 | 022 |  | Ticks and pips | 2 | 30s | draft | Price doesn't glide. It steps. |

## Week 4 · Sessions, mindset and habits
| Day | Video | Critical | Topic | Pillar | Length | Status | Hook |
|-----|-------|----------|-------|--------|--------|--------|------|
| 22 | 023 |  | Trading sessions | 3 | 31s | draft | The market has rush hours. |
| 23 | 024 | ★ | Revenge trading | 5 | 33s | draft | The trade after a loss is dangerous. |
| 24 | 025 |  | FOMO | 5 | 32s | draft | Price is flying. You want in. |
| 25 | 026 |  | Overtrading | 5 | 32s | draft | More trades doesn't mean more money. |
| 26 | 027 |  | The trading journal | 5 | 32s | draft | One useful trading tool costs nothing. |
| 27 | 028 | ★ | 3 questions before every trade | 1 | 31s | draft | Pilots use checklists. Traders need one. |
| 28 | 029 |  | What a prop firm is | 4 | 36s | draft | Their money. Their rules. Read them first. |

## Days 29 and 30 · Wrap-up
| Day | Video | Critical | Topic | Pillar | Length | Status | Hook |
|-----|-------|----------|-------|--------|--------|--------|------|
| 29 | 030 |  | When to leave sim | 1 | 31s | draft | Ready for real money? Feelings don't decide. |
| 30 | 031 | ★ | 5 survival rules | 1 | 32s | draft | Thirty days. Five rules that matter. |

## Things to know
- **Day 6 (video 002) has a shelf life.** It refers to the October 28, 2026 Fed decision. The Fed's own calendar lists the next meeting as **December 8–9, 2026** (`research/raw/fed-fomc-calendar-2026-11-13.md`, read 2026-11-13). So day 6 must be posted by **December 7**, which means day 1 must go out by **December 2**. If that's missed, skip day 6, move every later day up by one, and re-post your best performer on day 30.
- **Days 1 to 6 are the hand-built videos.** Their end cards already point to each other (005 → 006 → 007 → 004, then 001 → 002), which is why they open the calendar in that order.
- **Days 7 to 30 each end on a "Next:" line** naming the following day's topic. If you change the order, change it in `series.js` and re-render, or the end cards will point to the wrong video.
- **Pillar mix:** pillar 1: 11 videos · pillar 2: 13 videos · pillar 3: 1 videos · pillar 4: 1 videos · pillar 5: 4 videos. Forex (pillar 3) and prop firms (pillar 4) are light on purpose: you don't trade them, so they're taught from general knowledge only, with no figures.
- **No video uses a figure** except day 5 (SEC case) and day 6 (Fed decision), whose numbers trace to `research/2026-11-11.md`.

## After each post
Wait 48 hours, then paste one line per video and I'll add it to `published/log.csv`:
`id, date posted, platform, views at 48h, average watch %, shares, saves, new follows, notes`
After 10 rows I'll work out which pillars and hook types win and re-rank what comes next.
