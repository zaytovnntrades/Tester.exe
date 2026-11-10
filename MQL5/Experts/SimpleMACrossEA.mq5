//+------------------------------------------------------------------+
//|                                              SimpleMACrossEA.mq5 |
//|  MT5 Expert Advisor                                              |
//|  - Buy/Sell signals from a fast/slow Moving Average crossover    |
//|  - Risk-Reward presets: 1:2, 1:5 or custom (TP = SL x RR)        |
//|  - Fixed lot OR risk-% position sizing                           |
//|  - Stop Loss: fixed points OR ATR-based (adapts to volatility)   |
//|  - Higher-timeframe trend filter                                 |
//|  - Daily loss limit (stops trading for the day)                  |
//|  - Breakeven, trailing stop, session filter, spread filter       |
//|  - Only ONE open position at a time (per symbol + magic number)  |
//+------------------------------------------------------------------+
#property copyright "Tester.exe"
#property version   "3.00"

#include <Trade\Trade.mqh>

//--- Enums ------------------------------------------------------------
enum ENUM_RR_MODE
{
   RR_1_2    = 0,   // 1:2  (TP = 2 x SL)
   RR_1_5    = 1,   // 1:5  (TP = 5 x SL)
   RR_CUSTOM = 2    // Custom (TP = InpCustomRR x SL)
};

enum ENUM_LOT_MODE
{
   LOT_FIXED   = 0, // Fixed lot
   LOT_RISK_PC = 1  // Risk % of balance per trade
};

enum ENUM_SL_MODE
{
   SL_FIXED = 0,    // Fixed points
   SL_ATR   = 1     // ATR x multiplier
};

//--- Inputs -----------------------------------------------------------
input group "Signal"
input int                InpFastMAPeriod = 9;          // Fast MA period
input int                InpSlowMAPeriod = 21;         // Slow MA period
input ENUM_MA_METHOD     InpMAMethod     = MODE_EMA;   // MA method
input ENUM_APPLIED_PRICE InpMAPrice      = PRICE_CLOSE;// MA applied price

input group "Higher-Timeframe Trend Filter"
input bool               InpUseTrend     = true;       // Trade only with the HTF trend
input ENUM_TIMEFRAMES    InpTrendTF      = PERIOD_H4;  // Trend timeframe
input int                InpTrendMAPeriod= 200;        // Trend MA period
input ENUM_MA_METHOD     InpTrendMAMethod= MODE_EMA;   // Trend MA method

input group "Stop Loss"
input ENUM_SL_MODE       InpSLMode       = SL_ATR;     // Stop Loss mode
input int                InpStopLoss     = 300;        // Fixed Stop Loss (points)
input int                InpATRPeriod    = 14;         // ATR period (ATR mode)
input double             InpATRMult      = 1.5;        // ATR multiplier (ATR mode)
input int                InpMinSL        = 100;        // Min SL (points, ATR mode)
input int                InpMaxSL        = 1500;       // Max SL (points, ATR mode, 0 = no cap)

input group "Risk : Reward"
input ENUM_RR_MODE       InpRRMode       = RR_1_2;     // Risk:Reward preset
input double             InpCustomRR     = 1.2;        // Custom RR (used when preset = Custom)

input group "Daily Loss Limit"
input bool               InpUseDailyLimit= true;       // Use daily loss limit
input double             InpMaxDailyLoss = 3.0;        // Max loss per day (% of day-start balance)
input bool               InpCloseOnLimit = true;       // Close open position when limit is hit

input group "Position Size"
input ENUM_LOT_MODE      InpLotMode      = LOT_FIXED;  // Lot mode
input double             InpLotSize      = 0.10;       // Fixed lot size
input double             InpRiskPercent  = 1.0;        // Risk % of balance (Risk mode)

input group "Breakeven"
input bool               InpUseBreakeven = true;       // Use breakeven
input int                InpBETrigger    = 300;        // Move SL to BE after profit (points)
input int                InpBELock       = 20;         // Points locked in beyond entry

input group "Trailing Stop"
input bool               InpUseTrailing  = false;      // Use trailing stop
input int                InpTrailStart   = 400;        // Start trailing after profit (points)
input int                InpTrailDist    = 250;        // Trail distance from price (points)
input int                InpTrailStep    = 20;         // Min SL improvement per move (points)

input group "Filters"
input bool               InpUseSession   = false;      // Use trading-session filter
input int                InpStartHour    = 8;          // Session start hour (server time)
input int                InpEndHour      = 20;         // Session end hour (server time)
input int                InpMaxSpread    = 30;         // Max spread (points, 0 = off)

input group "Trade"
input int                InpSlippage     = 10;         // Max slippage (points)
input ulong              InpMagicNumber  = 20261110;   // Magic number
input string             InpTradeComment = "SimpleMACrossEA";

//--- Globals ----------------------------------------------------------
CTrade   trade;
int      g_fastHandle  = INVALID_HANDLE;
int      g_slowHandle  = INVALID_HANDLE;
int      g_atrHandle   = INVALID_HANDLE;
int      g_trendHandle = INVALID_HANDLE;
datetime g_lastBarTime = 0;
datetime g_limitDay    = 0;     // day on which the daily limit was hit (0 = not hit)

//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   if(InpFastMAPeriod <= 0 || InpSlowMAPeriod <= 0 || InpFastMAPeriod >= InpSlowMAPeriod)
   {
      Print("Invalid MA periods: fast must be > 0 and less than slow.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpSLMode == SL_FIXED && InpStopLoss <= 0)
   {
      Print("Stop Loss must be > 0 (TP and risk sizing are derived from it).");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpSLMode == SL_ATR && (InpATRPeriod <= 0 || InpATRMult <= 0.0 || InpMinSL < 0 ||
                              (InpMaxSL > 0 && InpMaxSL < InpMinSL)))
   {
      Print("Invalid ATR stop inputs (period/multiplier > 0, max SL >= min SL).");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpUseTrend && InpTrendMAPeriod <= 0)
   {
      Print("Trend MA period must be > 0.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpUseDailyLimit && (InpMaxDailyLoss <= 0.0 || InpMaxDailyLoss > 100.0))
   {
      Print("Daily loss limit must be between 0 and 100 %.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpRRMode == RR_CUSTOM && InpCustomRR <= 0.0)
   {
      Print("Custom RR must be > 0.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if((InpLotMode == LOT_FIXED && InpLotSize <= 0.0) ||
      (InpLotMode == LOT_RISK_PC && (InpRiskPercent <= 0.0 || InpRiskPercent > 100.0)))
   {
      Print("Invalid lot size / risk percent.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpUseTrailing && (InpTrailDist <= 0 || InpTrailStart < 0 || InpTrailStep < 0))
   {
      Print("Invalid trailing stop inputs.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpUseSession && (InpStartHour < 0 || InpStartHour > 23 || InpEndHour < 0 || InpEndHour > 23))
   {
      Print("Session hours must be 0..23.");
      return INIT_PARAMETERS_INCORRECT;
   }

   g_fastHandle = iMA(_Symbol, _Period, InpFastMAPeriod, 0, InpMAMethod, InpMAPrice);
   g_slowHandle = iMA(_Symbol, _Period, InpSlowMAPeriod, 0, InpMAMethod, InpMAPrice);
   if(g_fastHandle == INVALID_HANDLE || g_slowHandle == INVALID_HANDLE)
   {
      Print("Failed to create MA handles. Error: ", GetLastError());
      return INIT_FAILED;
   }
   if(InpSLMode == SL_ATR)
   {
      g_atrHandle = iATR(_Symbol, _Period, InpATRPeriod);
      if(g_atrHandle == INVALID_HANDLE)
      {
         Print("Failed to create ATR handle. Error: ", GetLastError());
         return INIT_FAILED;
      }
   }
   if(InpUseTrend)
   {
      g_trendHandle = iMA(_Symbol, InpTrendTF, InpTrendMAPeriod, 0, InpTrendMAMethod, PRICE_CLOSE);
      if(g_trendHandle == INVALID_HANDLE)
      {
         Print("Failed to create trend MA handle. Error: ", GetLastError());
         return INIT_FAILED;
      }
   }

   trade.SetExpertMagicNumber(InpMagicNumber);
   trade.SetDeviationInPoints(InpSlippage);
   trade.SetTypeFillingBySymbol(_Symbol);

   PrintFormat("SimpleMACrossEA started | SL mode %s | RR 1:%.2f | Trend filter %s | Daily limit %s",
               (InpSLMode == SL_ATR ? "ATR" : "Fixed"), GetRR(),
               (InpUseTrend ? EnumToString(InpTrendTF) : "off"),
               (InpUseDailyLimit ? DoubleToString(InpMaxDailyLoss, 1) + "%" : "off"));
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(g_fastHandle  != INVALID_HANDLE) IndicatorRelease(g_fastHandle);
   if(g_slowHandle  != INVALID_HANDLE) IndicatorRelease(g_slowHandle);
   if(g_atrHandle   != INVALID_HANDLE) IndicatorRelease(g_atrHandle);
   if(g_trendHandle != INVALID_HANDLE) IndicatorRelease(g_trendHandle);
}

//+------------------------------------------------------------------+
//| Main tick handler                                                |
//+------------------------------------------------------------------+
void OnTick()
{
   // 0) Daily loss limit: checked every tick, may close the open position
   bool limitHit = DailyLimitHit();

   // 1) Manage an open position on EVERY tick (breakeven / trailing)
   ManagePosition();

   // 2) Look for entries once per new bar (closed candles -> no repainting)
   if(!IsNewBar())
      return;

   if(limitHit)               return;   // done for today
   if(HasOpenPosition())      return;   // one position at a time
   if(!IsInSession())         return;   // time filter
   if(!IsSpreadOK())          return;   // spread filter

   int signal = GetSignal();             // +1 = buy, -1 = sell, 0 = nothing
   if(signal == 1)
      OpenTrade(ORDER_TYPE_BUY);
   else if(signal == -1)
      OpenTrade(ORDER_TYPE_SELL);
}

//+------------------------------------------------------------------+
//| Risk:Reward multiplier                                           |
//+------------------------------------------------------------------+
double GetRR()
{
   switch(InpRRMode)
   {
      case RR_1_2: return 2.0;
      case RR_1_5: return 5.0;
      default:     return InpCustomRR;
   }
}

//+------------------------------------------------------------------+
//| True on the first tick of a new bar                              |
//+------------------------------------------------------------------+
bool IsNewBar()
{
   datetime barTime = iTime(_Symbol, _Period, 0);
   if(barTime == 0 || barTime == g_lastBarTime)
      return false;
   g_lastBarTime = barTime;
   return true;
}

//+------------------------------------------------------------------+
//| Selects and returns this EA's position ticket (0 if none)        |
//+------------------------------------------------------------------+
ulong SelectMyPosition()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);   // also selects the position
      if(ticket == 0)
         continue;
      if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
         (ulong)PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
         return ticket;
   }
   return 0;
}

bool HasOpenPosition() { return SelectMyPosition() != 0; }

//+------------------------------------------------------------------+
//| Session filter (server time). Handles overnight, e.g. 22 -> 6    |
//+------------------------------------------------------------------+
bool IsInSession()
{
   if(!InpUseSession)
      return true;

   MqlDateTime t;
   TimeToStruct(TimeCurrent(), t);
   int h = t.hour;

   if(InpStartHour == InpEndHour) return true;                       // 24h
   if(InpStartHour <  InpEndHour) return (h >= InpStartHour && h < InpEndHour);
   return (h >= InpStartHour || h < InpEndHour);                     // wraps midnight
}

//+------------------------------------------------------------------+
//| Spread filter                                                    |
//+------------------------------------------------------------------+
bool IsSpreadOK()
{
   if(InpMaxSpread <= 0)
      return true;
   long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   if(spread > InpMaxSpread)
   {
      PrintFormat("Signal skipped: spread %d > max %d", (int)spread, InpMaxSpread);
      return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| MA crossover on the last two CLOSED bars (index 1 and 2)         |
//+------------------------------------------------------------------+
int GetSignal()
{
   double fast[], slow[];
   ArraySetAsSeries(fast, true);
   ArraySetAsSeries(slow, true);

   if(CopyBuffer(g_fastHandle, 0, 0, 3, fast) < 3) return 0;
   if(CopyBuffer(g_slowHandle, 0, 0, 3, slow) < 3) return 0;

   int signal = 0;
   if(fast[2] <= slow[2] && fast[1] > slow[1]) signal =  1;  // cross up   -> BUY
   if(fast[2] >= slow[2] && fast[1] < slow[1]) signal = -1;  // cross down -> SELL
   if(signal == 0)
      return 0;

   // Only take signals in the direction of the higher-timeframe trend
   int trend = GetTrend();
   if(InpUseTrend && trend != signal)
   {
      PrintFormat("%s signal skipped: against %s trend",
                  (signal == 1 ? "BUY" : "SELL"), EnumToString(InpTrendTF));
      return 0;
   }
   return signal;
}

//+------------------------------------------------------------------+
//| HTF trend: +1 up, -1 down, 0 unknown (last CLOSED HTF bar)       |
//+------------------------------------------------------------------+
int GetTrend()
{
   if(!InpUseTrend)
      return 0;

   double ma[];
   if(CopyBuffer(g_trendHandle, 0, 1, 1, ma) < 1)   // bar 1 = last closed HTF bar
      return 0;
   double close = iClose(_Symbol, InpTrendTF, 1);
   if(close == 0.0)
      return 0;

   if(close > ma[0]) return  1;
   if(close < ma[0]) return -1;
   return 0;
}

//+------------------------------------------------------------------+
//| Stop Loss distance in points: fixed, or ATR x multiplier         |
//+------------------------------------------------------------------+
int GetSLPoints()
{
   if(InpSLMode == SL_FIXED)
      return InpStopLoss;

   double atr[];
   if(CopyBuffer(g_atrHandle, 0, 1, 1, atr) < 1 || atr[0] <= 0.0)  // ATR of last closed bar
   {
      Print("ATR not ready - trade skipped.");
      return 0;
   }
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int pts = (int)MathRound(atr[0] * InpATRMult / point);
   pts = (int)MathMax(pts, InpMinSL);
   if(InpMaxSL > 0)
      pts = (int)MathMin(pts, InpMaxSL);
   return pts;
}

//+------------------------------------------------------------------+
//| Daily loss limit. Today's P/L = closed deals today + floating.   |
//| Limit is % of the balance at the start of the day.               |
//+------------------------------------------------------------------+
bool DailyLimitHit()
{
   if(!InpUseDailyLimit)
      return false;

   MqlDateTime t;
   TimeToStruct(TimeCurrent(), t);
   t.hour = 0; t.min = 0; t.sec = 0;
   datetime dayStart = StructToTime(t);

   if(g_limitDay == dayStart)          // already hit today -> stay blocked
   {
      if(InpCloseOnLimit) CloseMyPosition();
      return true;
   }

   // Realized P/L from this EA's deals closed today
   double closedPL = 0.0;
   if(HistorySelect(dayStart, TimeCurrent() + 60))
   {
      int deals = HistoryDealsTotal();
      for(int i = 0; i < deals; i++)
      {
         ulong d = HistoryDealGetTicket(i);
         if(d == 0) continue;
         if(HistoryDealGetString(d, DEAL_SYMBOL) != _Symbol) continue;
         if((ulong)HistoryDealGetInteger(d, DEAL_MAGIC) != InpMagicNumber) continue;
         long entry = HistoryDealGetInteger(d, DEAL_ENTRY);
         if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_INOUT && entry != DEAL_ENTRY_OUT_BY)
            continue;
         closedPL += HistoryDealGetDouble(d, DEAL_PROFIT)
                   + HistoryDealGetDouble(d, DEAL_SWAP)
                   + HistoryDealGetDouble(d, DEAL_COMMISSION);
      }
   }

   // Floating P/L of the open position
   double floatPL = 0.0;
   if(SelectMyPosition() != 0)
      floatPL = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);

   double dayStartBalance = AccountInfoDouble(ACCOUNT_BALANCE) - closedPL;
   if(dayStartBalance <= 0.0)
      return false;

   double dayPL = closedPL + floatPL;
   if(dayPL <= -dayStartBalance * InpMaxDailyLoss / 100.0)
   {
      g_limitDay = dayStart;
      PrintFormat("DAILY LOSS LIMIT HIT: %.2f (%.2f%% of %.2f). No more trades today.",
                  dayPL, -dayPL / dayStartBalance * 100.0, dayStartBalance);
      if(InpCloseOnLimit) CloseMyPosition();
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Close this EA's open position (if any)                           |
//+------------------------------------------------------------------+
void CloseMyPosition()
{
   ulong ticket = SelectMyPosition();
   if(ticket != 0 && !trade.PositionClose(ticket))
      PrintFormat("Close failed: %u %s", trade.ResultRetcode(), trade.ResultRetcodeDescription());
}

//+------------------------------------------------------------------+
//| Round lot down to broker step and clamp to min/max               |
//+------------------------------------------------------------------+
double NormalizeLot(double lot)
{
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   if(stepLot > 0.0)
      lot = MathFloor(lot / stepLot + 1e-9) * stepLot;
   lot = MathMax(minLot, MathMin(maxLot, lot));

   int lotDigits = 0;
   if(stepLot > 0.0)
      lotDigits = (int)MathMax(0, MathCeil(-MathLog10(stepLot) - 1e-9));
   return NormalizeDouble(lot, lotDigits);
}

//+------------------------------------------------------------------+
//| Lot size: fixed, or sized so SL hit = InpRiskPercent of balance  |
//+------------------------------------------------------------------+
double CalcLot(ENUM_ORDER_TYPE type, double price, double sl)
{
   if(InpLotMode == LOT_FIXED)
      return NormalizeLot(InpLotSize);

   double lossPerLot = 0.0;   // money lost on 1.0 lot if SL is hit (negative)
   if(!OrderCalcProfit(type, _Symbol, 1.0, price, sl, lossPerLot) || lossPerLot >= 0.0)
   {
      Print("Risk sizing failed, falling back to fixed lot.");
      return NormalizeLot(InpLotSize);
   }

   double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * InpRiskPercent / 100.0;
   double lot = riskMoney / MathAbs(lossPerLot);

   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   if(lot < minLot)
      PrintFormat("Warning: risk %.2f%% needs %.4f lots, below broker minimum %.2f. Using minimum.",
                  InpRiskPercent, lot, minLot);
   return NormalizeLot(lot);
}

//+------------------------------------------------------------------+
//| Open a market order. TP = SL distance x RR                       |
//+------------------------------------------------------------------+
void OpenTrade(ENUM_ORDER_TYPE type)
{
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol, tick))
      return;

   double point  = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   int    stopsLevel = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);

   // Respect broker minimum distance, then derive TP from the REAL SL distance
   int baseSL = GetSLPoints();
   if(baseSL <= 0)
      return;
   int slPts = (int)MathMax(baseSL, stopsLevel + 1);
   int tpPts = (int)MathMax(MathRound(slPts * GetRR()), stopsLevel + 1);

   double price, sl, tp;
   if(type == ORDER_TYPE_BUY)
   {
      price = tick.ask;
      sl = NormalizeDouble(price - slPts * point, digits);
      tp = NormalizeDouble(price + tpPts * point, digits);
   }
   else
   {
      price = tick.bid;
      sl = NormalizeDouble(price + slPts * point, digits);
      tp = NormalizeDouble(price - tpPts * point, digits);
   }

   double lot = CalcLot(type, price, sl);
   bool ok = (type == ORDER_TYPE_BUY)
             ? trade.Buy (lot, _Symbol, price, sl, tp, InpTradeComment)
             : trade.Sell(lot, _Symbol, price, sl, tp, InpTradeComment);

   if(ok)
      PrintFormat("%s %.2f lots @ %s | SL %s (%d pts) | TP %s (%d pts) | RR 1:%.2f",
                  (type == ORDER_TYPE_BUY ? "BUY" : "SELL"), lot,
                  DoubleToString(price, digits), DoubleToString(sl, digits), slPts,
                  DoubleToString(tp, digits), tpPts, GetRR());
   else
      PrintFormat("%s failed: %u %s", (type == ORDER_TYPE_BUY ? "BUY" : "SELL"),
                  trade.ResultRetcode(), trade.ResultRetcodeDescription());
}

//+------------------------------------------------------------------+
//| Breakeven + trailing stop for this EA's open position            |
//+------------------------------------------------------------------+
void ManagePosition()
{
   if(!InpUseBreakeven && !InpUseTrailing)
      return;

   ulong ticket = SelectMyPosition();
   if(ticket == 0)
      return;

   MqlTick tick;
   if(!SymbolInfoTick(_Symbol, tick))
      return;

   double point  = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   int    minDist = (int)MathMax(SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL),
                                 SymbolInfoInteger(_Symbol, SYMBOL_TRADE_FREEZE_LEVEL));

   bool   isBuy  = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
   double open   = PositionGetDouble(POSITION_PRICE_OPEN);
   double curSL  = PositionGetDouble(POSITION_SL);
   double curTP  = PositionGetDouble(POSITION_TP);
   double price  = isBuy ? tick.bid : tick.ask;          // price the position closes at
   double profitPts = (isBuy ? price - open : open - price) / point;

   double newSL = curSL;

   // --- Breakeven
   if(InpUseBreakeven && profitPts >= InpBETrigger)
   {
      double beSL = isBuy ? open + InpBELock * point : open - InpBELock * point;
      if(isBuy ? (curSL < beSL || curSL == 0.0) : (curSL > beSL || curSL == 0.0))
         newSL = beSL;
   }

   // --- Trailing stop
   if(InpUseTrailing && profitPts >= InpTrailStart)
   {
      double trSL = isBuy ? price - InpTrailDist * point : price + InpTrailDist * point;
      double ref  = (newSL == 0.0) ? (isBuy ? 0.0 : DBL_MAX) : newSL;
      if(isBuy ? (trSL >= ref + InpTrailStep * point) : (trSL <= ref - InpTrailStep * point))
         newSL = trSL;
   }

   newSL = NormalizeDouble(newSL, digits);
   if(newSL == NormalizeDouble(curSL, digits))
      return;

   // SL must stay at least the broker's minimum distance from the current price
   if(isBuy ? (price - newSL < (minDist + 1) * point) : (newSL - price < (minDist + 1) * point))
      return;

   if(!trade.PositionModify(ticket, newSL, curTP))
      PrintFormat("SL modify failed: %u %s", trade.ResultRetcode(), trade.ResultRetcodeDescription());
}
//+------------------------------------------------------------------+
