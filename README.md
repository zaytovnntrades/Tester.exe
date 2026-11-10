# Tester.exe — Simple MT5 Expert Advisor

`MQL5/Experts/SimpleMACrossEA.mq5` is a basic MetaTrader 5 Expert Advisor with:

| Feature | How it works |
|---|---|
| **Buy/Sell signals** | Fast MA crossing above Slow MA → **BUY**; crossing below → **SELL** |
| **Risk:Reward presets** | `InpRRMode` = **1:2**, **1:5** or **Custom** (`InpCustomRR`, e.g. 1.2). TP = SL × RR |
| **Position size** | `InpLotMode` = Fixed lot (`InpLotSize`) or **Risk %** of balance (`InpRiskPercent`) |
| **Stop Loss** | `InpStopLoss` in **points**, pushed out to the broker's minimum stop distance if needed |
| **Breakeven** | After `InpBETrigger` points of profit, SL moves to entry + `InpBELock` points |
| **Trailing stop** | After `InpTrailStart` points, SL follows price at `InpTrailDist` points |
| **Filters** | Trading session (server hours, overnight sessions work) and max spread |
| **One position at a time** | No new trade while a position with this EA's magic number is open on the symbol |
| **No repainting** | Signals are checked once per new bar, using only closed candles |

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
6. **Next:** an ATR-based SL (adapts to volatility), a higher-timeframe trend filter, and a daily loss limit.

> Educational code. It does not guarantee profit, and trading involves risk.
