# Tester.exe: MT5 Expert Advisor

`MQL5/Experts/SimpleMACrossEA.mq5` (v5) is a MetaTrader 5 Expert Advisor with 5 selectable signal strategies, R-based trade management, loss limits, a news filter, and on-chart visuals.
Only **one position at a time** (per symbol + magic number). Signals use **closed candles only** (no repainting).

---

## 1. Buy/Sell signals (`InpSignalMode`)

| Strategy | Style | BUY when | SELL when | Best market |
|---|---|---|---|---|
| **MA crossover** | Trend | Fast MA (9 EMA) crosses **above** slow MA (21 EMA) | Crosses **below** | Trending |
| **RSI** | Reversal | RSI(14) climbs back **above 30** (leaves oversold) | Drops back **below 70** | Ranging |
| **MACD** | Momentum | MACD line crosses **above** signal line | Crosses **below** | Trending |
| **Bollinger** | Mean reversion | Candle closed **below** lower band, next closes back **inside** | Mirror at upper band | Ranging |
| **Stochastic** | Reversal | %K crosses **above** %D while **below 20** | %K crosses below %D while **above 80** | Ranging |

**Filters applied on top** (each is optional):
- **Direction** (`InpDirection`): Both / **Buy only** / Sell only.
- **HTF trend** (default ON): buy only if the last closed H4 candle is above its 200 EMA; sell only below.
- **RSI 50 confirmation**: buy only if RSI > 50, sell only if RSI < 50 (momentum agrees).
- **MACD confirmation**: buy only if MACD > signal line, sell only if below.

> **Pro tip:** pair a *reversal* signal (RSI / Stochastic / Bollinger) with the **trend filter**.
> "Buy the dip in an uptrend" is one of the most robust retail setups, and far better than catching every reversal.

## 2. On-chart visuals
- **Arrows** on every signal candle. Hover an arrow to see why it was skipped:
  - 🟢 **Green ▲** = BUY taken · 🔴 **Red ▼** = SELL taken · ⚪ **Gray** = signal skipped (e.g. "against H4 trend", "news: USD CPI", "a position is already open")
- **Indicators** for the selected strategy are added to the chart automatically (MAs/Bands on price; RSI/MACD/Stochastic in subwindows) and removed when the EA is removed.
- **Dashboard** (top-left): status, trend, ATR & SL size, day/week P/L vs limits, next news event, open position in **R**, last signal.

## 3. Risk
| Feature | Default |
|---|---|
| Stop Loss | **ATR(14) × 1.5**, min 100 / max 1500 pts (or Fixed points) |
| Risk:Reward | **1:2** (presets 1:2, 1:5, or Custom e.g. 1.2) → TP = SL × RR |
| Lot | Fixed 0.10, or **Risk %** of balance per trade |
| Daily loss limit | **3%**: stops for the day (and closes the open trade) |
| Weekly loss limit | **6%**: stops until next Monday 00:00 server time |

## 4. Trade management (R-based)
**1R = initial SL distance** (what you risk). Read from the opening order in history, so it survives restarts.

**Default lifecycle (1:2):**
1. Entry, risking 1R.
2. **+1R** → close **50%** (bank +0.5R) and move the SL to **breakeven + 20 pts** → can no longer lose.
3. The other 50% is **trailed at 2 × ATR** behind price (trailing starts only after the partial).
4. It exits at TP (+2R) or wherever the ATR trail catches it.

| Preset | Full winner, no partial | Full winner, 50% at 1R | Hit 1R, then BE |
|---|---|---|---|
| 1:2 | +2R | +1.5R | +0.5R |
| 1:5 | +5R | +3R | +0.5R |

> Partial TP needs a splittable lot. With min lot 0.01, the smallest is 0.02.

## 5. News filter
- Uses MT5's built-in **economic calendar**. It blocks new trades **30 min before → 30 min after** high-impact news for the symbol's currencies (EURUSD → EUR + USD; override with `InpNewsCurrencies`, e.g. `"USD"` for gold).
- Option: also **close** the open trade inside the news window.
- ⚠️ The calendar is **not available in the Strategy Tester**, so the filter is automatically inactive in backtests (a log line says so). It works on demo/live charts.

---

## Install
1. MT5: **File → Open Data Folder** → `MQL5/Experts/`
2. Copy `SimpleMACrossEA.mq5` there.
3. Open it in **MetaEditor** (F4) → **Compile** (F7) → 0 errors.
4. Drag the EA onto a chart and turn on **Algo Trading**.

## Points vs. pips
On 5-digit FX pairs **10 points = 1 pip**. Gold and indices differ, so check the dashboard's ATR value to see the symbol's normal range in points.

| RR | Break-even win rate = 1 / (1 + RR) |
|---|---|
| 1:1.2 | ~45% |
| 1:2 | ~33% |
| 1:5 | ~17% |

---

## Learning path: beginner → mastery
**Stage 1: Observe (no money)**
1. Run in the Strategy Tester in **visual mode**. Watch the arrows, then hover the gray ones to learn what each filter blocks.
2. Read the code in order: `OnTick` → `GetRawSignal` → `FilterSignal` → `OpenTrade` → `ManagePosition`.

**Stage 2: Compare signals**
3. Same symbol/dates, change only `InpSignalMode`. Record profit factor, max drawdown, win rate and trade count in a spreadsheet.
4. Keep the best 1–2 strategies for that symbol/timeframe.

**Stage 3: Ablation test (find what really helps)**
5. Turn **one** feature off per run: trend filter, confirmations, partial TP, BE, trailing, ATR SL. If removing it doesn't hurt, you don't need it.

**Stage 4: Avoid over-fitting**
6. Optimize on one period (e.g. 2022–2024), then test **unchanged** on a period you didn't optimize on (2025). If results collapse, the settings are curve-fit.

**Stage 5: Go live safely**
7. Demo for 4+ weeks → small live with **Risk % = 0.5%** → scale slowly.
8. Keep the daily (3%) and weekly (6%) limits on. They're your circuit breakers.

> Educational code. It does not guarantee profit, and trading involves risk.
