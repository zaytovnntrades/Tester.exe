# Tester.exe — Simple MT5 Expert Advisor

`MQL5/Experts/SimpleMACrossEA.mq5` is a basic MetaTrader 5 Expert Advisor with:

| Feature | How it works |
|---|---|
| **Buy/Sell signals** | Fast MA crossing above Slow MA → **BUY**; crossing below → **SELL** |
| **Risk:Reward presets** | `InpRRMode` = **1:2**, **1:5** or **Custom** (`InpCustomRR`, e.g. 1.2). TP = SL × RR |
| **Position size** | `InpLotMode` = Fixed lot (`InpLotSize`) or **Risk %** of balance (`InpRiskPercent`) |
| **Stop Loss** | `InpSLMode` = **Fixed** (`InpStopLoss` points) or **ATR** (ATR × `InpATRMult`, clamped by `InpMinSL`/`InpMaxSL`). Pushed out to the broker's minimum stop distance if needed |
| **Trend filter** | Buys only when the last closed `InpTrendTF` candle is above its `InpTrendMAPeriod` MA; sells only when it's below |
| **Daily loss limit** | When today's P/L (closed + floating) reaches −`InpMaxDailyLoss`% of the day-start balance, the EA stops for the day and can close the open trade |
| **Partial take-profit** | At +`InpPartialR` R (default **1R**), closes `InpPartialPct`% (default **50%**) once. The rest runs to the full TP |
| **Breakeven** | `InpBEMode` = **R** (default: at **+1R**) or Points (`InpBETrigger`). SL moves to entry + `InpBELock` points |
| **Trailing stop** | After `InpTrailStart` points, SL follows price at `InpTrailDist` points |
| **Filters** | Trading session (server hours, overnight sessions work) and max spread |
| **One position at a time** | No new trade while a position with this EA's magic number is open on the symbol |
| **No repainting** | Signals are checked once per new bar, using only closed candles |

## Default settings
| Setting | Default |
|---|---|
| Signal | 9 / 21 EMA crossover on the chart timeframe |
| Trend filter | ON: 200 EMA on H4 |
| Stop Loss | ATR(14) × 1.5, min 100 / max 1500 points |
| Risk:Reward | 1:2 |
| Lot | Fixed 0.10 (switch to Risk % for proper sizing) |
| Partial TP | ON: close 50% at +1R |
| Breakeven | ON at +1R, lock +20 points |
| Daily loss limit | ON, 3%, closes the open trade |

> The daily limit only counts **this EA's** trades (same symbol and magic number). The day starts at **00:00 broker server time**.

## What "R" means
**1R = the initial Stop Loss distance**, i.e. what you risk. If the SL is 200 points away, +1R = 200 points of profit.
The EA reads the original SL from the opening order in history, so R stays correct after the SL moves to breakeven or MT5 restarts.

**Default 1:2 trade lifecycle**
1. Entry, risking 1R.
2. At **+1R**: close 50% (bank +0.5R) and move the SL to breakeven (+20 points).
3. The remaining 50% either hits TP at **+2R** (another +1R, total **+1.5R**) or gets stopped near breakeven (total about **+0.5R**).

So once price reaches +1R, the trade can't turn into a loss. The cost: a full winner pays +1.5R instead of +2R.

| Preset | Full winner (no partial) | Full winner (50% at 1R) | Hit 1R, then BE |
|---|---|---|---|
| 1:2 | +2R | +1.5R | +0.5R |
| 1:5 | +5R | +3R | +0.5R |

> Partial TP needs a lot that can be split. With min lot 0.01, the smallest workable trade is 0.02. If it can't be split, the EA logs this and skips the partial.

## Install (about 2 minutes)
1. In MT5: **File → Open Data Folder** → `MQL5/Experts/`
2. Copy `SimpleMACrossEA.mq5` into that folder.
3. Open it in **MetaEditor** (F4) and press **Compile** (F7). You should get 0 errors.
4. In MT5's Navigator, drag the EA onto a chart and turn on **Algo Trading**.

## Test before going live
**View → Strategy Tester (Ctrl+R)** → choose the EA, symbol, and timeframe → Modeling: *Every tick based on real ticks* → Start.
Run it on a **demo account** before using real money.

## Points vs. pips
On 5-digit FX pairs, **10 points = 1 pip**. Default SL 300 pts = 30 pips.

| Preset | SL | TP | Break-even win rate |
|---|---|---|---|
| 1:1.2 (Custom) | 30 pips | 36 pips | ~45% |
| **1:2** | 30 pips | 60 pips | ~33% |
| **1:5** | 30 pips | 150 pips | ~17% |

Break-even win rate = 1 / (1 + RR). A higher RR means fewer wins are needed, but each TP is harder to reach.
On gold and indices a point is worth a different amount, so set SL per symbol.

**Tip:** for 1:5, turn breakeven ON (or use trailing). Big targets often reverse before they're hit, and breakeven turns many would-be losers into scratch trades.

## Learning path: beginner → mastery
1. **Read the flow:** `OnInit` (setup) → `OnTick` → `IsNewBar` → `HasOpenPosition` → `GetSignal` → `OpenTrade`.
2. **Tweak inputs:** try 20/50 SMA on H1, and change the SL/TP ratio. Use the tester's *Optimization* mode.
3. **Swap the signal:** replace `GetSignal()` with RSI, Bollinger Bands, or breakout logic. Nothing else needs to change.
4. **Size by risk:** set Lot mode = Risk %, starting at 0.5–1% per trade.
5. **Manage trades:** compare BE on/off and trailing on/off in the tester for the same RR preset.
6. **Adapt to volatility:** compare SL mode = ATR (1.5×) with Fixed. With ATR, wild days get a wider SL and a smaller lot (in Risk % mode), so the money at risk stays the same.
7. **Trend alignment:** run the tester with the trend filter on and off. Fewer trades but a higher win rate is the usual result.
8. **Protect the account:** keep the daily loss limit at 2–3%. A losing streak won't turn into a blown account.
9. **Next:** a weekly loss limit, partial take-profit at 1R, news filter, or multiple-symbol support.

> Educational code. It does not guarantee profit, and trading involves risk.
