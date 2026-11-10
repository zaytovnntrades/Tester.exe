# Tester.exe — Simple MT5 Expert Advisor

`MQL5/Experts/SimpleMACrossEA.mq5` is a basic MetaTrader 5 Expert Advisor with:

| Feature | How it works |
|---|---|
| **Buy/Sell signals** | Fast MA crossing above Slow MA → **BUY**; crossing below → **SELL** |
| **Fixed lot size** | `InpLotSize`, adjusted to the broker's min/max/step |
| **Stop Loss / Take Profit** | `InpStopLoss` / `InpTakeProfit` in **points** (0 = off), pushed out to the broker's minimum stop distance if needed |
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
On 5-digit FX pairs, **10 points = 1 pip**. The defaults (300 SL / 600 TP) are 30 / 60 pips, a 1:2 risk-reward.
On gold and indices a point is worth a different amount, so set SL/TP per symbol.

## Learning path: beginner → mastery
1. **Read the flow:** `OnInit` (setup) → `OnTick` → `IsNewBar` → `HasOpenPosition` → `GetSignal` → `OpenTrade`.
2. **Tweak inputs:** try 20/50 SMA on H1, and change the SL/TP ratio. Use the tester's *Optimization* mode.
3. **Swap the signal:** replace `GetSignal()` with RSI, Bollinger Bands, or breakout logic. Nothing else needs to change.
4. **Add risk-based lots:** calculate the lot from a % of balance and the SL distance.
5. **Add management:** breakeven, trailing stop, a session/time filter, a spread filter.

> Educational code. It does not guarantee profit, and trading involves risk.
