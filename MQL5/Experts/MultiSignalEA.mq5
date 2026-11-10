//+------------------------------------------------------------------+
//|                                                MultiSignalEA.mq5 |
//|  MT5 Expert Advisor                                              |
//|  SIGNALS                                                         |
//|  - Strategy: MA cross / RSI / MACD / Bollinger / Stochastic      |
//|  - Optional confirmations: RSI 50-line, MACD direction           |
//|  - Direction: both / buy only / sell only                        |
//|  - Higher-timeframe trend filter                                 |
//|  RISK                                                            |
//|  - Risk-Reward presets: 1:2, 1:5 or custom (TP = SL x RR)        |
//|  - Stop Loss: fixed points OR ATR-based                          |
//|  - Fixed lot OR risk-% position sizing                           |
//|  - Daily AND weekly loss limits                                  |
//|  TRADE MANAGEMENT                                                |
//|  - Partial take-profit at +1R, breakeven at +1R                  |
//|  - Trailing stop (points or ATR), optionally only after partial  |
//|  FILTERS                                                         |
//|  - News filter (MT5 economic calendar), session, spread          |
//|  VISUALS                                                         |
//|  - Buy/Sell arrows on chart, indicators on chart, dashboard      |
//|  - Only ONE open position at a time (per symbol + magic number)  |
//+------------------------------------------------------------------+
#property copyright "Tester.exe"
#property version   "5.00"

#include <Trade\Trade.mqh>

//=== Enums ==========================================================
enum ENUM_SIGNAL_MODE
{
   SIG_MA_CROSS = 0, // MA crossover (trend)
   SIG_RSI      = 1, // RSI exits oversold/overbought (reversal)
   SIG_MACD     = 2, // MACD crosses its signal line (momentum)
   SIG_BB       = 3, // Bollinger Band re-entry (mean reversion)
   SIG_STOCH    = 4  // Stochastic %K/%D cross in OB/OS zone (reversal)
};

enum ENUM_DIRECTION
{
   DIR_BOTH      = 0, // Buy and Sell
   DIR_BUY_ONLY  = 1, // Buy only
   DIR_SELL_ONLY = 2  // Sell only
};

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

enum ENUM_BE_MODE
{
   BE_R      = 0,   // R multiple (1R = initial SL distance)
   BE_POINTS = 1    // Fixed points
};

enum ENUM_TRAIL_MODE
{
   TRAIL_POINTS = 0, // Fixed points distance
   TRAIL_ATR    = 1  // ATR x multiplier distance
};

enum ENUM_NEWS_IMPORTANCE
{
   NEWS_HIGH        = 0, // High impact only
   NEWS_HIGH_MEDIUM = 1  // High + Medium impact
};

//=== Inputs =========================================================
input group "Signal Strategy"
input ENUM_SIGNAL_MODE   InpSignalMode   = SIG_MA_CROSS; // Entry signal
input ENUM_DIRECTION     InpDirection    = DIR_BOTH;     // Trade direction

input group "MA Crossover"
input int                InpFastMAPeriod = 9;          // Fast MA period
input int                InpSlowMAPeriod = 21;         // Slow MA period
input ENUM_MA_METHOD     InpMAMethod     = MODE_EMA;   // MA method
input ENUM_APPLIED_PRICE InpMAPrice      = PRICE_CLOSE;// MA applied price

input group "RSI"
input int                InpRSIPeriod    = 14;         // RSI period
input double             InpRSIOversold  = 30.0;       // Oversold level (buy zone)
input double             InpRSIOverbought= 70.0;       // Overbought level (sell zone)

input group "MACD"
input int                InpMACDFast     = 12;         // MACD fast EMA
input int                InpMACDSlow     = 26;         // MACD slow EMA
input int                InpMACDSignal   = 9;          // MACD signal period

input group "Bollinger Bands"
input int                InpBBPeriod     = 20;         // BB period
input double             InpBBDeviation  = 2.0;        // BB deviation

input group "Stochastic"
input int                InpStochK       = 14;         // %K period
input int                InpStochD       = 3;          // %D period
input int                InpStochSlowing = 3;          // Slowing
input double             InpStochOversold  = 20.0;     // Oversold level
input double             InpStochOverbought= 80.0;     // Overbought level

input group "Signal Confirmations"
input bool               InpConfirmRSI50 = false;      // Buy only if RSI > 50, sell only if < 50
input bool               InpConfirmMACD  = false;      // Buy only if MACD > signal, sell only if <

input group "Higher-Timeframe Trend Filter"
input bool               InpUseTrend     = true;       // Trade only with the HTF trend
input ENUM_TIMEFRAMES    InpTrendTF      = PERIOD_H4;  // Trend timeframe
input int                InpTrendMAPeriod= 200;        // Trend MA period
input ENUM_MA_METHOD     InpTrendMAMethod= MODE_EMA;   // Trend MA method

input group "Stop Loss"
input ENUM_SL_MODE       InpSLMode       = SL_ATR;     // Stop Loss mode
input int                InpStopLoss     = 300;        // Fixed Stop Loss (points)
input int                InpATRPeriod    = 14;         // ATR period (SL + ATR trailing)
input double             InpATRMult      = 1.5;        // ATR multiplier for SL
input int                InpMinSL        = 100;        // Min SL (points, ATR mode)
input int                InpMaxSL        = 1500;       // Max SL (points, ATR mode, 0 = no cap)

input group "Risk : Reward"
input ENUM_RR_MODE       InpRRMode       = RR_1_2;     // Risk:Reward preset
input double             InpCustomRR     = 1.2;        // Custom RR (used when preset = Custom)

input group "Position Size"
input ENUM_LOT_MODE      InpLotMode      = LOT_FIXED;  // Lot mode
input double             InpLotSize      = 0.10;       // Fixed lot size
input double             InpRiskPercent  = 1.0;        // Risk % of balance (Risk mode)

input group "Partial Take-Profit"
input bool               InpUsePartial   = true;       // Use partial take-profit
input double             InpPartialR     = 1.0;        // Take partial at profit of (R)
input double             InpPartialPct   = 50.0;       // % of position to close

input group "Breakeven"
input bool               InpUseBreakeven = true;       // Use breakeven
input ENUM_BE_MODE       InpBEMode       = BE_R;       // Breakeven trigger mode
input double             InpBETriggerR   = 1.0;        // Move SL to BE after profit (R)
input int                InpBETrigger    = 300;        // Move SL to BE after profit (points mode)
input int                InpBELock       = 20;         // Points locked in beyond entry

input group "Trailing Stop"
input bool               InpUseTrailing  = true;       // Use trailing stop
input ENUM_TRAIL_MODE    InpTrailMode    = TRAIL_ATR;  // Trailing distance mode
input bool               InpTrailAfterPartial = true;  // Start trailing only after partial TP
input int                InpTrailStart   = 400;        // Start after profit (points; if not after-partial)
input int                InpTrailDist    = 250;        // Trail distance (points mode)
input double             InpTrailATRMult = 2.0;        // Trail distance = ATR x this (ATR mode)
input int                InpTrailStep    = 20;         // Min SL improvement per move (points)

input group "Loss Limits"
input bool               InpUseDailyLimit = true;      // Use daily loss limit
input double             InpMaxDailyLoss  = 3.0;       // Max loss per day (% of day-start balance)
input bool               InpUseWeeklyLimit= true;      // Use weekly loss limit
input double             InpMaxWeeklyLoss = 6.0;       // Max loss per week (% of week-start balance)
input bool               InpCloseOnLimit  = true;      // Close open position when a limit is hit

input group "News Filter (live only - calendar is not available in the Strategy Tester)"
input bool               InpUseNews      = true;       // Block new trades around news
input ENUM_NEWS_IMPORTANCE InpNewsImpact = NEWS_HIGH;  // Which news to avoid
input int                InpNewsBefore   = 30;         // Minutes before news
input int                InpNewsAfter    = 30;         // Minutes after news
input string             InpNewsCurrencies = "";       // Currencies (e.g. "USD,EUR"; empty = from symbol)
input bool               InpNewsClosePos = false;      // Close open position inside news window

input group "Session & Spread Filters"
input bool               InpUseSession   = false;      // Use trading-session filter
input int                InpStartHour    = 8;          // Session start hour (server time)
input int                InpEndHour      = 20;         // Session end hour (server time)
input int                InpMaxSpread    = 30;         // Max spread (points, 0 = off)

input group "Visuals"
input bool               InpShowArrows   = true;       // Draw Buy/Sell signal arrows
input bool               InpShowIndicators = true;     // Add the strategy's indicators to the chart
input bool               InpShowDashboard  = true;     // Show info panel (top-left)

input group "Trade"
input int                InpSlippage     = 10;         // Max slippage (points)
input ulong              InpMagicNumber  = 20261110;   // Magic number
input string             InpTradeComment = "MultiSignalEA";

//=== Globals ========================================================
#define OBJ_PREFIX "MSEA_"

CTrade   trade;

// indicator handles
int      g_fastHandle  = INVALID_HANDLE;
int      g_slowHandle  = INVALID_HANDLE;
int      g_rsiHandle   = INVALID_HANDLE;
int      g_macdHandle  = INVALID_HANDLE;
int      g_bbHandle    = INVALID_HANDLE;
int      g_stochHandle = INVALID_HANDLE;
int      g_atrHandle   = INVALID_HANDLE;
int      g_trendHandle = INVALID_HANDLE;

datetime g_lastBarTime = 0;

// loss limits
datetime g_dayHit      = 0;     // day start on which the daily limit was hit
datetime g_weekHit     = 0;     // week start on which the weekly limit was hit
double   g_dayPLPct    = 0.0;   // for dashboard
double   g_weekPLPct   = 0.0;

// initial-trade info for the open position (cached; rebuilt from history after restart)
ulong    g_infoPosId   = 0;
double   g_infoRPts    = 0.0;   // 1R in points = initial SL distance
double   g_infoVolume  = 0.0;   // initial position volume

// news cache
datetime g_newsTimes[];
string   g_newsNames[];
datetime g_newsLastLoad = 0;
bool     g_newsAvailable = true;

// chart indicators we added (to remove them on exit)
string   g_chartIndNames[];
int      g_chartIndWins[];

// last signal info for dashboard
string   g_lastSignalText = "none yet";

//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- validate inputs
   if(InpSignalMode == SIG_MA_CROSS &&
      (InpFastMAPeriod <= 0 || InpSlowMAPeriod <= 0 || InpFastMAPeriod >= InpSlowMAPeriod))
      return Fail("Invalid MA periods: fast must be > 0 and less than slow.");
   if((InpSignalMode == SIG_RSI || InpConfirmRSI50) &&
      (InpRSIPeriod <= 0 || InpRSIOversold >= InpRSIOverbought))
      return Fail("Invalid RSI inputs (period > 0, oversold < overbought).");
   if((InpSignalMode == SIG_MACD || InpConfirmMACD) &&
      (InpMACDFast <= 0 || InpMACDSlow <= InpMACDFast || InpMACDSignal <= 0))
      return Fail("Invalid MACD inputs (fast < slow, all > 0).");
   if(InpSignalMode == SIG_BB && (InpBBPeriod <= 1 || InpBBDeviation <= 0.0))
      return Fail("Invalid Bollinger inputs.");
   if(InpSignalMode == SIG_STOCH &&
      (InpStochK <= 0 || InpStochD <= 0 || InpStochSlowing <= 0 || InpStochOversold >= InpStochOverbought))
      return Fail("Invalid Stochastic inputs.");
   if(InpSLMode == SL_FIXED && InpStopLoss <= 0)
      return Fail("Stop Loss must be > 0 (TP and risk sizing are derived from it).");
   if(InpATRPeriod <= 0)
      return Fail("ATR period must be > 0.");
   if(InpSLMode == SL_ATR && (InpATRMult <= 0.0 || InpMinSL < 0 || (InpMaxSL > 0 && InpMaxSL < InpMinSL)))
      return Fail("Invalid ATR stop inputs (multiplier > 0, max SL >= min SL).");
   if(InpUseTrend && InpTrendMAPeriod <= 0)
      return Fail("Trend MA period must be > 0.");
   if(InpRRMode == RR_CUSTOM && InpCustomRR <= 0.0)
      return Fail("Custom RR must be > 0.");
   if((InpLotMode == LOT_FIXED && InpLotSize <= 0.0) ||
      (InpLotMode == LOT_RISK_PC && (InpRiskPercent <= 0.0 || InpRiskPercent > 100.0)))
      return Fail("Invalid lot size / risk percent.");
   if(InpUsePartial && (InpPartialR <= 0.0 || InpPartialPct <= 0.0 || InpPartialPct >= 100.0))
      return Fail("Partial TP: R must be > 0 and % between 0 and 100 (exclusive).");
   if(InpUseBreakeven && InpBEMode == BE_R && InpBETriggerR <= 0.0)
      return Fail("Breakeven R trigger must be > 0.");
   if(InpUseTrailing && (InpTrailStep < 0 || InpTrailStart < 0 ||
      (InpTrailMode == TRAIL_POINTS && InpTrailDist <= 0) ||
      (InpTrailMode == TRAIL_ATR && InpTrailATRMult <= 0.0)))
      return Fail("Invalid trailing stop inputs.");
   if(InpUseDailyLimit && (InpMaxDailyLoss <= 0.0 || InpMaxDailyLoss > 100.0))
      return Fail("Daily loss limit must be between 0 and 100 %.");
   if(InpUseWeeklyLimit && (InpMaxWeeklyLoss <= 0.0 || InpMaxWeeklyLoss > 100.0))
      return Fail("Weekly loss limit must be between 0 and 100 %.");
   if(InpUseNews && (InpNewsBefore < 0 || InpNewsAfter < 0))
      return Fail("News minutes must be >= 0.");
   if(InpUseSession && (InpStartHour < 0 || InpStartHour > 23 || InpEndHour < 0 || InpEndHour > 23))
      return Fail("Session hours must be 0..23.");

   //--- warn about combinations that block (almost) every signal
   if(InpSignalMode == SIG_RSI && InpConfirmRSI50)
      Print("Warning: RSI signal + RSI-50 confirmation conflict (buys fire near 30). Turn the confirmation off.");
   if(InpSignalMode == SIG_MACD && InpConfirmMACD)
      Print("Note: MACD confirmation is redundant with the MACD signal.");
   if(InpUsePartial && InpLotMode == LOT_FIXED &&
      InpLotSize < 2.0 * SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN) - 1e-9)
      Print("Warning: lot size too small to split - partial take-profit will be skipped.");

   //--- create indicator handles (only the ones we need)
   if(InpSignalMode == SIG_MA_CROSS)
   {
      g_fastHandle = iMA(_Symbol, _Period, InpFastMAPeriod, 0, InpMAMethod, InpMAPrice);
      g_slowHandle = iMA(_Symbol, _Period, InpSlowMAPeriod, 0, InpMAMethod, InpMAPrice);
      if(g_fastHandle == INVALID_HANDLE || g_slowHandle == INVALID_HANDLE) return Fail("MA handle failed.", INIT_FAILED);
   }
   if(InpSignalMode == SIG_RSI || InpConfirmRSI50)
   {
      g_rsiHandle = iRSI(_Symbol, _Period, InpRSIPeriod, PRICE_CLOSE);
      if(g_rsiHandle == INVALID_HANDLE) return Fail("RSI handle failed.", INIT_FAILED);
   }
   if(InpSignalMode == SIG_MACD || InpConfirmMACD)
   {
      g_macdHandle = iMACD(_Symbol, _Period, InpMACDFast, InpMACDSlow, InpMACDSignal, PRICE_CLOSE);
      if(g_macdHandle == INVALID_HANDLE) return Fail("MACD handle failed.", INIT_FAILED);
   }
   if(InpSignalMode == SIG_BB)
   {
      g_bbHandle = iBands(_Symbol, _Period, InpBBPeriod, 0, InpBBDeviation, PRICE_CLOSE);
      if(g_bbHandle == INVALID_HANDLE) return Fail("Bollinger handle failed.", INIT_FAILED);
   }
   if(InpSignalMode == SIG_STOCH)
   {
      g_stochHandle = iStochastic(_Symbol, _Period, InpStochK, InpStochD, InpStochSlowing, MODE_SMA, STO_LOWHIGH);
      if(g_stochHandle == INVALID_HANDLE) return Fail("Stochastic handle failed.", INIT_FAILED);
   }
   g_atrHandle = iATR(_Symbol, _Period, InpATRPeriod);           // SL, ATR trailing, dashboard
   if(g_atrHandle == INVALID_HANDLE) return Fail("ATR handle failed.", INIT_FAILED);
   if(InpUseTrend)
   {
      g_trendHandle = iMA(_Symbol, InpTrendTF, InpTrendMAPeriod, 0, InpTrendMAMethod, PRICE_CLOSE);
      if(g_trendHandle == INVALID_HANDLE) return Fail("Trend MA handle failed.", INIT_FAILED);
   }

   //--- show indicators on the chart (the Strategy Tester shows them automatically)
   if(InpShowIndicators && !MQLInfoInteger(MQL_TESTER))
   {
      AddToChart(g_fastHandle, false);
      AddToChart(g_slowHandle, false);
      AddToChart(g_bbHandle,   false);
      AddToChart(g_rsiHandle,  true);
      AddToChart(g_macdHandle, true);
      AddToChart(g_stochHandle,true);
   }

   trade.SetExpertMagicNumber(InpMagicNumber);
   trade.SetDeviationInPoints(InpSlippage);
   trade.SetTypeFillingBySymbol(_Symbol);

   if(InpUseNews && MQLInfoInteger(MQL_TESTER))
   {
      g_newsAvailable = false;
      Print("News filter: economic calendar is not available in the Strategy Tester - filter inactive in this test.");
   }

   PrintFormat("EA started | Signal %s | Dir %s | SL %s | RR 1:%.2f | Trend %s | Limits D %s / W %s | News %s",
               EnumToString(InpSignalMode), EnumToString(InpDirection),
               (InpSLMode == SL_ATR ? "ATR" : "Fixed"), GetRR(),
               (InpUseTrend ? EnumToString(InpTrendTF) : "off"),
               (InpUseDailyLimit  ? DoubleToString(InpMaxDailyLoss, 1)  + "%" : "off"),
               (InpUseWeeklyLimit ? DoubleToString(InpMaxWeeklyLoss, 1) + "%" : "off"),
               (InpUseNews ? "on" : "off"));
   return INIT_SUCCEEDED;
}

int Fail(string msg, int code = INIT_PARAMETERS_INCORRECT)
{
   Print(msg, (code == INIT_FAILED ? " Error: " + IntegerToString(GetLastError()) : ""));
   return code;
}

//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // remove the indicators we added (reverse order keeps subwindow indexes valid)
   for(int i = ArraySize(g_chartIndNames) - 1; i >= 0; i--)
      ChartIndicatorDelete(0, g_chartIndWins[i], g_chartIndNames[i]);

   ReleaseHandle(g_fastHandle);  ReleaseHandle(g_slowHandle);
   ReleaseHandle(g_rsiHandle);   ReleaseHandle(g_macdHandle);
   ReleaseHandle(g_bbHandle);    ReleaseHandle(g_stochHandle);
   ReleaseHandle(g_atrHandle);   ReleaseHandle(g_trendHandle);

   // keep arrows when only the timeframe/parameters change, remove them when the EA is removed
   if(reason == REASON_REMOVE)
      ObjectsDeleteAll(0, OBJ_PREFIX);
   Comment("");
}

void ReleaseHandle(int &h)
{
   if(h != INVALID_HANDLE) IndicatorRelease(h);
   h = INVALID_HANDLE;
}

//+------------------------------------------------------------------+
//| Main tick handler                                                |
//+------------------------------------------------------------------+
void OnTick()
{
   // 0) Protection checks (every tick)
   string limitWhy = "";
   bool   limitHit = LossLimitHit(limitWhy);

   string newsWhy  = "";
   bool   newsTime = IsNewsTime(newsWhy);
   if(newsTime && InpNewsClosePos && HasOpenPosition())
   {
      Print("News window (", newsWhy, ") - closing open position.");
      CloseMyPosition();
   }

   // 1) Manage an open position (partial TP / breakeven / trailing)
   ManagePosition();

   // 2) Dashboard
   UpdateDashboard(limitHit ? limitWhy : "", newsTime ? newsWhy : "");

   // 3) Entries once per new bar (closed candles -> no repainting)
   if(!IsNewBar())
      return;

   int signal = GetRawSignal();          // +1 = buy, -1 = sell, 0 = nothing
   if(signal == 0)
      return;

   // Every filter writes a reason when it blocks the signal
   string why = "";
   if(limitHit)                 why = limitWhy;
   else if(newsTime)            why = "news: " + newsWhy;
   else if(HasOpenPosition())   why = "a position is already open";
   else if(!IsInSession())      why = "outside trading session";
   else if(!IsSpreadOK())       why = StringFormat("spread %d > max %d",
                                        (int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD), InpMaxSpread);
   else                         FilterSignal(signal, why);

   bool taken = false;
   if(why == "")
   {
      taken = OpenTrade(signal == 1 ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
      if(!taken) why = "order rejected (see log)";
   }

   string side = (signal == 1 ? "BUY" : "SELL");
   string result = taken ? "TAKEN" : "skipped: " + why;
   g_lastSignalText = StringFormat("%s %s - %s", side,
                                   TimeToString(iTime(_Symbol, _Period, 1), TIME_DATE|TIME_MINUTES), result);
   if(!taken)
      PrintFormat("%s signal skipped: %s", side, why);

   DrawSignalArrow(signal, taken, why);
}

//####################################################################
//#  SIGNALS                                                         #
//####################################################################

//+------------------------------------------------------------------+
//| Copy 3 values (bars 0..2) of an indicator buffer, as series      |
//+------------------------------------------------------------------+
bool Get3(int handle, int buffer, double &arr[])
{
   ArraySetAsSeries(arr, true);
   return (handle != INVALID_HANDLE && CopyBuffer(handle, buffer, 0, 3, arr) == 3);
}

//+------------------------------------------------------------------+
//| Raw entry signal of the selected strategy (closed bars 1 and 2)  |
//+------------------------------------------------------------------+
int GetRawSignal()
{
   double a[], b[];
   switch(InpSignalMode)
   {
      case SIG_MA_CROSS:   // fast MA crosses slow MA
         if(!Get3(g_fastHandle, 0, a) || !Get3(g_slowHandle, 0, b)) return 0;
         if(a[2] <= b[2] && a[1] > b[1]) return  1;
         if(a[2] >= b[2] && a[1] < b[1]) return -1;
         return 0;

      case SIG_RSI:        // RSI climbs back above oversold / drops back below overbought
         if(!Get3(g_rsiHandle, 0, a)) return 0;
         if(a[2] < InpRSIOversold   && a[1] >= InpRSIOversold)   return  1;
         if(a[2] > InpRSIOverbought && a[1] <= InpRSIOverbought) return -1;
         return 0;

      case SIG_MACD:       // MACD main line crosses signal line
         if(!Get3(g_macdHandle, 0, a) || !Get3(g_macdHandle, 1, b)) return 0;
         if(a[2] <= b[2] && a[1] > b[1]) return  1;
         if(a[2] >= b[2] && a[1] < b[1]) return -1;
         return 0;

      case SIG_BB:         // close re-enters the bands after closing outside them
      {
         double up[], lo[];
         if(!Get3(g_bbHandle, 1, up) || !Get3(g_bbHandle, 2, lo)) return 0;
         double c2 = iClose(_Symbol, _Period, 2), c1 = iClose(_Symbol, _Period, 1);
         if(c2 < lo[2] && c1 > lo[1]) return  1;
         if(c2 > up[2] && c1 < up[1]) return -1;
         return 0;
      }

      case SIG_STOCH:      // %K crosses %D inside the oversold / overbought zone
         if(!Get3(g_stochHandle, 0, a) || !Get3(g_stochHandle, 1, b)) return 0;
         if(a[2] <= b[2] && a[1] > b[1] && b[1] < InpStochOversold)   return  1;
         if(a[2] >= b[2] && a[1] < b[1] && b[1] > InpStochOverbought) return -1;
         return 0;
   }
   return 0;
}

//+------------------------------------------------------------------+
//| Direction, trend and confirmation filters. Sets 'why' if blocked |
//+------------------------------------------------------------------+
bool FilterSignal(int signal, string &why)
{
   if(InpDirection == DIR_BUY_ONLY  && signal == -1) { why = "buy-only mode";  return false; }
   if(InpDirection == DIR_SELL_ONLY && signal ==  1) { why = "sell-only mode"; return false; }

   if(InpUseTrend && GetTrend() != signal)
   {
      why = "against " + EnumToString(InpTrendTF) + " trend";
      return false;
   }

   double v[];
   if(InpConfirmRSI50)
   {
      if(!Get3(g_rsiHandle, 0, v)) { why = "RSI not ready"; return false; }
      if(signal ==  1 && v[1] <= 50.0) { why = StringFormat("RSI %.1f not above 50", v[1]); return false; }
      if(signal == -1 && v[1] >= 50.0) { why = StringFormat("RSI %.1f not below 50", v[1]); return false; }
   }

   if(InpConfirmMACD)
   {
      double m[], s[];
      if(!Get3(g_macdHandle, 0, m) || !Get3(g_macdHandle, 1, s)) { why = "MACD not ready"; return false; }
      if(signal ==  1 && m[1] <= s[1]) { why = "MACD below its signal line"; return false; }
      if(signal == -1 && m[1] >= s[1]) { why = "MACD above its signal line"; return false; }
   }
   return true;
}

//+------------------------------------------------------------------+
//| HTF trend: +1 up, -1 down, 0 unknown (last CLOSED HTF bar)       |
//+------------------------------------------------------------------+
int GetTrend()
{
   if(!InpUseTrend)
      return 0;
   double ma[];
   if(CopyBuffer(g_trendHandle, 0, 1, 1, ma) < 1)
      return 0;
   double close = iClose(_Symbol, InpTrendTF, 1);
   if(close == 0.0)
      return 0;
   if(close > ma[0]) return  1;
   if(close < ma[0]) return -1;
   return 0;
}

//####################################################################
//#  ENTRY / RISK                                                    #
//####################################################################

double GetRR()
{
   switch(InpRRMode)
   {
      case RR_1_2: return 2.0;
      case RR_1_5: return 5.0;
      default:     return InpCustomRR;
   }
}

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

void CloseMyPosition()
{
   ulong ticket = SelectMyPosition();
   if(ticket != 0 && !trade.PositionClose(ticket))
      PrintFormat("Close failed: %u %s", trade.ResultRetcode(), trade.ResultRetcodeDescription());
}

bool IsInSession()
{
   if(!InpUseSession)
      return true;
   MqlDateTime t;
   TimeToStruct(TimeCurrent(), t);
   int h = t.hour;
   if(InpStartHour == InpEndHour) return true;
   if(InpStartHour <  InpEndHour) return (h >= InpStartHour && h < InpEndHour);
   return (h >= InpStartHour || h < InpEndHour);               // wraps midnight
}

bool IsSpreadOK()
{
   return (InpMaxSpread <= 0 || SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) <= InpMaxSpread);
}

double GetATR()
{
   double atr[];
   if(CopyBuffer(g_atrHandle, 0, 1, 1, atr) < 1)   // ATR of the last closed bar
      return 0.0;
   return atr[0];
}

int GetSLPoints()
{
   if(InpSLMode == SL_FIXED)
      return InpStopLoss;

   double atr = GetATR();
   if(atr <= 0.0)
   {
      Print("ATR not ready - trade skipped.");
      return 0;
   }
   int pts = (int)MathRound(atr * InpATRMult / SymbolInfoDouble(_Symbol, SYMBOL_POINT));
   pts = (int)MathMax(pts, InpMinSL);
   if(InpMaxSL > 0)
      pts = (int)MathMin(pts, InpMaxSL);
   return pts;
}

int LotDigits()
{
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   return (step > 0.0) ? (int)MathMax(0, MathCeil(-MathLog10(step) - 1e-9)) : 2;
}

double NormalizeLot(double lot)
{
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(stepLot > 0.0)
      lot = MathFloor(lot / stepLot + 1e-9) * stepLot;
   lot = MathMax(minLot, MathMin(maxLot, lot));
   return NormalizeDouble(lot, LotDigits());
}

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
bool OpenTrade(ENUM_ORDER_TYPE type)
{
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol, tick))
      return false;

   double point  = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   int    stopsLevel = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);

   int baseSL = GetSLPoints();
   if(baseSL <= 0)
      return false;
   int slPts = (int)MathMax(baseSL, stopsLevel + 1);
   int tpPts = (int)MathMax(MathRound(slPts * GetRR()), stopsLevel + 1);

   bool   isBuy = (type == ORDER_TYPE_BUY);
   double price = isBuy ? tick.ask : tick.bid;
   double sl = NormalizeDouble(isBuy ? price - slPts * point : price + slPts * point, digits);
   double tp = NormalizeDouble(isBuy ? price + tpPts * point : price - tpPts * point, digits);

   double lot = CalcLot(type, price, sl);
   bool ok = isBuy ? trade.Buy (lot, _Symbol, price, sl, tp, InpTradeComment)
                   : trade.Sell(lot, _Symbol, price, sl, tp, InpTradeComment);
   if(ok)
      PrintFormat("%s %.2f lots @ %s | SL %s (%d pts) | TP %s (%d pts) | RR 1:%.2f",
                  (isBuy ? "BUY" : "SELL"), lot, DoubleToString(price, digits),
                  DoubleToString(sl, digits), slPts, DoubleToString(tp, digits), tpPts, GetRR());
   else
      PrintFormat("%s failed: %u %s", (isBuy ? "BUY" : "SELL"),
                  trade.ResultRetcode(), trade.ResultRetcodeDescription());
   return ok;
}

//####################################################################
//#  LOSS LIMITS                                                     #
//####################################################################

//+------------------------------------------------------------------+
//| Daily + weekly loss limits. P/L = this EA's closed deals in the  |
//| period + floating P/L. Limit is % of the period-start balance.   |
//+------------------------------------------------------------------+
bool LossLimitHit(string &why)
{
   MqlDateTime t;
   TimeToStruct(TimeCurrent(), t);
   int dow = t.day_of_week;                       // 0 = Sunday
   t.hour = 0; t.min = 0; t.sec = 0;
   datetime dayStart  = StructToTime(t);
   datetime weekStart = dayStart - ((dow + 6) % 7) * 86400;   // Monday 00:00 server time

   // closed P/L this week and today (one history scan)
   double closedDay = 0.0, closedWeek = 0.0;
   if(HistorySelect(weekStart, TimeCurrent() + 60))
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
         double pl = HistoryDealGetDouble(d, DEAL_PROFIT) + HistoryDealGetDouble(d, DEAL_SWAP)
                   + HistoryDealGetDouble(d, DEAL_COMMISSION);
         closedWeek += pl;
         if((datetime)HistoryDealGetInteger(d, DEAL_TIME) >= dayStart)
            closedDay += pl;
      }
   }

   double floatPL = 0.0;
   if(SelectMyPosition() != 0)
      floatPL = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);

   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double dayBase   = balance - closedDay;
   double weekBase  = balance - closedWeek;
   g_dayPLPct  = (dayBase  > 0.0) ? (closedDay  + floatPL) / dayBase  * 100.0 : 0.0;
   g_weekPLPct = (weekBase > 0.0) ? (closedWeek + floatPL) / weekBase * 100.0 : 0.0;

   bool hit = false;

   // weekly
   if(InpUseWeeklyLimit)
   {
      if(g_weekHit != weekStart && g_weekPLPct <= -InpMaxWeeklyLoss)
      {
         g_weekHit = weekStart;
         PrintFormat("WEEKLY LOSS LIMIT HIT: %.2f%%. No more trades until next Monday.", g_weekPLPct);
      }
      if(g_weekHit == weekStart) { hit = true; why = "weekly loss limit hit"; }
   }
   // daily
   if(!hit && InpUseDailyLimit)
   {
      if(g_dayHit != dayStart && g_dayPLPct <= -InpMaxDailyLoss)
      {
         g_dayHit = dayStart;
         PrintFormat("DAILY LOSS LIMIT HIT: %.2f%%. No more trades today.", g_dayPLPct);
      }
      if(g_dayHit == dayStart) { hit = true; why = "daily loss limit hit"; }
   }

   if(hit && InpCloseOnLimit)
      CloseMyPosition();
   return hit;
}

//####################################################################
//#  NEWS FILTER (MT5 economic calendar)                             #
//####################################################################

//+------------------------------------------------------------------+
//| Reload upcoming news for the symbol's currencies (every 15 min)  |
//+------------------------------------------------------------------+
void LoadNews()
{
   ArrayResize(g_newsTimes, 0);
   ArrayResize(g_newsNames, 0);

   string list = InpNewsCurrencies;
   if(StringLen(list) == 0)
   {
      list = SymbolInfoString(_Symbol, SYMBOL_CURRENCY_BASE);
      string profit = SymbolInfoString(_Symbol, SYMBOL_CURRENCY_PROFIT);
      if(profit != list) list += "," + profit;
   }
   string cur[];
   int n = StringSplit(list, ',', cur);

   datetime now  = TimeCurrent();
   datetime from = now - InpNewsAfter * 60;
   datetime to   = now + 24 * 3600;

   for(int c = 0; c < n; c++)
   {
      string ccy = cur[c];
      StringTrimLeft(ccy); StringTrimRight(ccy); StringToUpper(ccy);
      if(StringLen(ccy) == 0) continue;

      MqlCalendarValue values[];
      if(!CalendarValueHistory(values, from, to, NULL, ccy))
         continue;
      for(int i = 0; i < ArraySize(values); i++)
      {
         MqlCalendarEvent ev;
         if(!CalendarEventById(values[i].event_id, ev)) continue;
         bool wanted = (ev.importance == CALENDAR_IMPORTANCE_HIGH) ||
                       (InpNewsImpact == NEWS_HIGH_MEDIUM && ev.importance == CALENDAR_IMPORTANCE_MODERATE);
         if(!wanted) continue;
         int k = ArraySize(g_newsTimes);
         ArrayResize(g_newsTimes, k + 1);
         ArrayResize(g_newsNames, k + 1);
         g_newsTimes[k] = values[i].time;
         g_newsNames[k] = ccy + " " + ev.name;
      }
   }
   g_newsLastLoad = now;
}

//+------------------------------------------------------------------+
//| True if now is inside [news - before, news + after]              |
//+------------------------------------------------------------------+
bool IsNewsTime(string &what)
{
   if(!InpUseNews || !g_newsAvailable)
      return false;

   datetime now = TimeCurrent();
   if(now - g_newsLastLoad >= 15 * 60)
      LoadNews();

   for(int i = 0; i < ArraySize(g_newsTimes); i++)
   {
      if(now >= g_newsTimes[i] - InpNewsBefore * 60 && now <= g_newsTimes[i] + InpNewsAfter * 60)
      {
         what = g_newsNames[i] + " @ " + TimeToString(g_newsTimes[i], TIME_MINUTES);
         return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| Next upcoming news (for the dashboard)                           |
//+------------------------------------------------------------------+
string NextNewsText()
{
   if(!InpUseNews)        return "off";
   if(!g_newsAvailable)   return "inactive in tester";
   datetime now = TimeCurrent(), best = 0;
   string   name = "";
   for(int i = 0; i < ArraySize(g_newsTimes); i++)
      if(g_newsTimes[i] > now && (best == 0 || g_newsTimes[i] < best))
      { best = g_newsTimes[i]; name = g_newsNames[i]; }
   return (best == 0) ? "none in next 24h" : name + " @ " + TimeToString(best, TIME_MINUTES);
}

//####################################################################
//#  TRADE MANAGEMENT                                                #
//####################################################################

//+------------------------------------------------------------------+
//| Initial R (SL distance, points) and initial volume of a position |
//| From the opening order in history -> survives restarts and stays |
//| correct after SL is moved to breakeven.                          |
//+------------------------------------------------------------------+
bool GetInitialInfo(ulong posId, double open, double curSL, double curVol,
                    double &rPts, double &initVol)
{
   if(posId == g_infoPosId && g_infoRPts > 0.0)
   {
      rPts = g_infoRPts; initVol = g_infoVolume;
      return true;
   }

   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   rPts = 0.0; initVol = 0.0;

   // The position identifier = ticket of the order that opened it
   if(HistorySelectByPosition(posId) && HistoryOrderSelect(posId))
   {
      double sl = HistoryOrderGetDouble(posId, ORDER_SL);
      initVol   = HistoryOrderGetDouble(posId, ORDER_VOLUME_INITIAL);
      if(sl > 0.0)
         rPts = MathAbs(open - sl) / point;
   }

   bool isBuy = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
   if(rPts <= 0.0 && curSL > 0.0 && (isBuy ? curSL < open : curSL > open))
      rPts = MathAbs(open - curSL) / point;     // SL not yet moved past entry -> still 1R
   if(initVol <= 0.0)
      initVol = curVol;
   if(rPts <= 0.0)
      return false;

   g_infoPosId = posId; g_infoRPts = rPts; g_infoVolume = initVol;
   return true;
}

bool PartialDone(double curVol, double initVol)
{
   return curVol < initVol - SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP) * 0.5;
}

//+------------------------------------------------------------------+
//| Close InpPartialPct % of the position once, at +InpPartialR      |
//+------------------------------------------------------------------+
bool TryPartialClose(ulong ticket, double curVol, double initVol, double profitR)
{
   if(!InpUsePartial || profitR < InpPartialR || PartialDone(curVol, initVol))
      return false;

   double step   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);

   double closeVol = initVol * InpPartialPct / 100.0;
   if(step > 0.0)
      closeVol = MathFloor(closeVol / step + 1e-9) * step;
   double remain = curVol - closeVol;

   if(closeVol < minLot || remain < minLot - 1e-9)
   {
      static ulong warned = 0;
      if(warned != ticket)
      {
         PrintFormat("Partial TP skipped: %.2f lots can't be split (min lot %.2f). Use a bigger lot.",
                     curVol, minLot);
         warned = ticket;
      }
      return false;
   }
   closeVol = NormalizeDouble(closeVol, LotDigits());

   if(trade.PositionClosePartial(ticket, closeVol))
   {
      PrintFormat("PARTIAL TP: closed %.2f of %.2f lots at +%.2fR", closeVol, curVol, profitR);
      return true;
   }
   PrintFormat("Partial close failed: %u %s", trade.ResultRetcode(), trade.ResultRetcodeDescription());
   return false;
}

//+------------------------------------------------------------------+
//| Partial TP + breakeven + trailing stop for the open position     |
//+------------------------------------------------------------------+
void ManagePosition()
{
   if(!InpUseBreakeven && !InpUseTrailing && !InpUsePartial)
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
   ulong  posId  = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
   double open   = PositionGetDouble(POSITION_PRICE_OPEN);
   double curSL  = PositionGetDouble(POSITION_SL);
   double curTP  = PositionGetDouble(POSITION_TP);
   double curVol = PositionGetDouble(POSITION_VOLUME);
   double price  = isBuy ? tick.bid : tick.ask;          // price the position closes at
   double profitPts = (isBuy ? price - open : open - price) / point;

   double rPts = 0.0, initVol = curVol;
   bool   haveR   = GetInitialInfo(posId, open, curSL, curVol, rPts, initVol);
   double profitR = haveR ? profitPts / rPts : 0.0;

   // --- 1) Partial take-profit (once). SL is managed on the next tick.
   if(haveR && TryPartialClose(ticket, curVol, initVol, profitR))
      return;

   double newSL = curSL;

   // --- 2) Breakeven
   bool beReached = false;
   if(InpUseBreakeven)
      beReached = (InpBEMode == BE_R) ? (haveR && profitR >= InpBETriggerR)
                                      : (profitPts >= InpBETrigger);
   double beSL = NormalizeDouble(isBuy ? open + InpBELock * point : open - InpBELock * point, digits);
   if(beReached && (curSL == 0.0 || (isBuy ? curSL < beSL : curSL > beSL)))
      newSL = beSL;

   // --- 3) Trailing stop (points or ATR), optionally only after the partial
   if(InpUseTrailing)
   {
      bool start = InpTrailAfterPartial ? (InpUsePartial && PartialDone(curVol, initVol))
                                        : (profitPts >= InpTrailStart);
      double dist = (InpTrailMode == TRAIL_ATR) ? GetATR() * InpTrailATRMult : InpTrailDist * point;
      if(start && dist > 0.0)
      {
         double trSL = isBuy ? price - dist : price + dist;
         double ref  = (newSL == 0.0) ? (isBuy ? 0.0 : DBL_MAX) : newSL;
         if(isBuy ? (trSL >= ref + InpTrailStep * point) : (trSL <= ref - InpTrailStep * point))
            newSL = trSL;
      }
   }

   newSL = NormalizeDouble(newSL, digits);
   if(newSL == NormalizeDouble(curSL, digits))
      return;

   // SL must stay at least the broker's minimum distance from the current price
   if(isBuy ? (price - newSL < (minDist + 1) * point) : (newSL - price < (minDist + 1) * point))
      return;

   if(trade.PositionModify(ticket, newSL, curTP))
   {
      if(newSL == beSL)
         PrintFormat("BREAKEVEN: SL -> %s at +%.2fR", DoubleToString(newSL, digits), profitR);
   }
   else
      PrintFormat("SL modify failed: %u %s", trade.ResultRetcode(), trade.ResultRetcodeDescription());
}

//####################################################################
//#  VISUALS                                                         #
//####################################################################

//+------------------------------------------------------------------+
//| Add an indicator to the chart (main window or a new subwindow)   |
//+------------------------------------------------------------------+
void AddToChart(int handle, bool subwindow)
{
   if(handle == INVALID_HANDLE)
      return;
   int win = subwindow ? (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL) : 0;
   if(!ChartIndicatorAdd(0, win, handle))
      return;
   int total = ChartIndicatorsTotal(0, win);
   if(total <= 0)
      return;
   int k = ArraySize(g_chartIndNames);
   ArrayResize(g_chartIndNames, k + 1);
   ArrayResize(g_chartIndWins,  k + 1);
   g_chartIndNames[k] = ChartIndicatorName(0, win, total - 1);
   g_chartIndWins[k]  = win;
}

//+------------------------------------------------------------------+
//| Arrow on the signal candle. Green/Red = taken, Gray = skipped.   |
//| Hover the arrow to see why it was skipped.                       |
//+------------------------------------------------------------------+
void DrawSignalArrow(int signal, bool taken, string why)
{
   if(!InpShowArrows)
      return;

   datetime t = iTime(_Symbol, _Period, 1);
   bool   isBuy = (signal == 1);
   double atr   = GetATR();
   double y     = isBuy ? iLow(_Symbol, _Period, 1)  - atr * 0.3
                        : iHigh(_Symbol, _Period, 1) + atr * 0.3;
   string name  = OBJ_PREFIX + (isBuy ? "BUY_" : "SELL_") + IntegerToString((long)t);

   ObjectDelete(0, name);
   if(!ObjectCreate(0, name, OBJ_ARROW, 0, t, y))
      return;
   ObjectSetInteger(0, name, OBJPROP_ARROWCODE, isBuy ? 233 : 234);   // Wingdings up / down arrow
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, isBuy ? ANCHOR_TOP : ANCHOR_BOTTOM);
   ObjectSetInteger(0, name, OBJPROP_COLOR, taken ? (isBuy ? clrLime : clrRed) : clrGray);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, taken ? 3 : 1);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   string tip = isBuy ? "BUY" : "SELL";
   tip += taken ? " - TAKEN" : " - skipped: " + why;
   ObjectSetString (0, name, OBJPROP_TOOLTIP, tip);
}

//+------------------------------------------------------------------+
//| Info panel (top-left). Updated at most once per second.          |
//+------------------------------------------------------------------+
void UpdateDashboard(string limitWhy, string newsWhy)
{
   if(!InpShowDashboard)
      return;
   static datetime last = 0;
   datetime now = TimeCurrent();
   if(now == last)
      return;
   last = now;

   int    trend = GetTrend();
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double atr   = GetATR();
   string slTxt = (InpSLMode == SL_FIXED) ? StringFormat("%d pts", InpStopLoss)
                : (atr > 0.0)             ? StringFormat("%d pts (ATR)", GetSLPoints())
                :                           "ATR not ready";
   string trendTxt = !InpUseTrend ? "off" : (trend == 1 ? "UP (buys only)" : trend == -1 ? "DOWN (sells only)" : "flat/unknown");
   string status = (limitWhy != "") ? "BLOCKED - " + limitWhy
                 : (newsWhy  != "") ? "PAUSED - news: " + newsWhy
                 : "active";

   string pos = "none";
   ulong ticket = SelectMyPosition();
   if(ticket != 0)
   {
      bool   isBuy = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
      double open  = PositionGetDouble(POSITION_PRICE_OPEN);
      double vol   = PositionGetDouble(POSITION_VOLUME);
      double cur   = PositionGetDouble(POSITION_PRICE_CURRENT);
      double pts   = (isBuy ? cur - open : open - cur) / point;
      string rTxt  = "";
      if(g_infoPosId == (ulong)PositionGetInteger(POSITION_IDENTIFIER) && g_infoRPts > 0.0)
         rTxt = StringFormat(" | %+.2fR%s", pts / g_infoRPts, PartialDone(vol, g_infoVolume) ? " | partial done" : "");
      pos = StringFormat("%s %.2f lots | %+.0f pts%s", (isBuy ? "BUY" : "SELL"), vol, pts, rTxt);
   }

   string fmt = "=== MultiSignalEA v5 ===\n";
   fmt += "Status: %s\n";
   fmt += "Signal: %s | Direction: %s\n";
   fmt += "Trend (%s): %s\n";
   fmt += "ATR: %.0f pts | SL: %s | RR 1:%.2f\n";
   fmt += "Day P/L: %+.2f%%  (limit %s)\n";
   fmt += "Week P/L: %+.2f%%  (limit %s)\n";
   fmt += "Next news: %s\n";
   fmt += "Position: %s\n";
   fmt += "Last signal: %s";

   Comment(StringFormat(fmt,
      status,
      EnumToString(InpSignalMode), EnumToString(InpDirection),
      EnumToString(InpTrendTF), trendTxt,
      atr / point, slTxt, GetRR(),
      g_dayPLPct,  (InpUseDailyLimit  ? StringFormat("-%.1f%%", InpMaxDailyLoss)  : "off"),
      g_weekPLPct, (InpUseWeeklyLimit ? StringFormat("-%.1f%%", InpMaxWeeklyLoss) : "off"),
      NextNewsText(),
      pos,
      g_lastSignalText));
}
//+------------------------------------------------------------------+
