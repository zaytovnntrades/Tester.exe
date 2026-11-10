//+------------------------------------------------------------------+
//|                                              SimpleMACrossEA.mq5 |
//|  Basic MT5 Expert Advisor                                        |
//|  - Buy/Sell signals from a fast/slow Moving Average crossover    |
//|  - Fixed lot size                                                |
//|  - Stop Loss & Take Profit in points                             |
//|  - Only ONE open position at a time (per symbol + magic number)  |
//+------------------------------------------------------------------+
#property copyright "Tester.exe"
#property version   "1.00"

#include <Trade\Trade.mqh>

//--- Inputs -----------------------------------------------------------
input group "Signal"
input int                InpFastMAPeriod = 9;          // Fast MA period
input int                InpSlowMAPeriod = 21;         // Slow MA period
input ENUM_MA_METHOD     InpMAMethod     = MODE_EMA;   // MA method
input ENUM_APPLIED_PRICE InpMAPrice      = PRICE_CLOSE;// MA applied price

input group "Trade"
input double             InpLotSize      = 0.10;       // Fixed lot size
input int                InpStopLoss     = 300;        // Stop Loss (points, 0 = none)
input int                InpTakeProfit   = 600;        // Take Profit (points, 0 = none)
input int                InpSlippage     = 10;         // Max slippage (points)
input ulong              InpMagicNumber  = 20261110;   // Magic number
input string             InpTradeComment = "SimpleMACrossEA";

//--- Globals ----------------------------------------------------------
CTrade   trade;
int      g_fastHandle = INVALID_HANDLE;
int      g_slowHandle = INVALID_HANDLE;
datetime g_lastBarTime = 0;

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
   if(InpLotSize <= 0.0 || InpStopLoss < 0 || InpTakeProfit < 0)
   {
      Print("Invalid lot size / SL / TP inputs.");
      return INIT_PARAMETERS_INCORRECT;
   }

   g_fastHandle = iMA(_Symbol, _Period, InpFastMAPeriod, 0, InpMAMethod, InpMAPrice);
   g_slowHandle = iMA(_Symbol, _Period, InpSlowMAPeriod, 0, InpMAMethod, InpMAPrice);
   if(g_fastHandle == INVALID_HANDLE || g_slowHandle == INVALID_HANDLE)
   {
      Print("Failed to create MA handles. Error: ", GetLastError());
      return INIT_FAILED;
   }

   trade.SetExpertMagicNumber(InpMagicNumber);
   trade.SetDeviationInPoints(InpSlippage);
   trade.SetTypeFillingBySymbol(_Symbol);

   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(g_fastHandle != INVALID_HANDLE) IndicatorRelease(g_fastHandle);
   if(g_slowHandle != INVALID_HANDLE) IndicatorRelease(g_slowHandle);
}

//+------------------------------------------------------------------+
//| Main tick handler                                                |
//+------------------------------------------------------------------+
void OnTick()
{
   // Work once per new bar -> signals use closed candles only (no repainting)
   if(!IsNewBar())
      return;

   // One position at a time
   if(HasOpenPosition())
      return;

   int signal = GetSignal();   // +1 = buy, -1 = sell, 0 = nothing
   if(signal == 1)
      OpenTrade(ORDER_TYPE_BUY);
   else if(signal == -1)
      OpenTrade(ORDER_TYPE_SELL);
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
//| Does this EA already have a position on this symbol?             |
//+------------------------------------------------------------------+
bool HasOpenPosition()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
         (ulong)PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
         return true;
   }
   return false;
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

   // fast crossed ABOVE slow -> BUY
   if(fast[2] <= slow[2] && fast[1] > slow[1])
      return 1;
   // fast crossed BELOW slow -> SELL
   if(fast[2] >= slow[2] && fast[1] < slow[1])
      return -1;

   return 0;
}

//+------------------------------------------------------------------+
//| Normalize lot to broker's min/max/step                           |
//+------------------------------------------------------------------+
double NormalizeLot(double lot)
{
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   if(stepLot > 0.0)
      lot = MathFloor(lot / stepLot + 1e-9) * stepLot;
   lot = MathMax(minLot, MathMin(maxLot, lot));
   return NormalizeDouble(lot, 2);
}

//+------------------------------------------------------------------+
//| Open a market order with SL/TP                                   |
//+------------------------------------------------------------------+
void OpenTrade(ENUM_ORDER_TYPE type)
{
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol, tick))
      return;

   double point  = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);

   // Respect the broker's minimum stop distance
   int stopsLevel = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   int slPts = (InpStopLoss   > 0) ? (int)MathMax(InpStopLoss,   stopsLevel + 1) : 0;
   int tpPts = (InpTakeProfit > 0) ? (int)MathMax(InpTakeProfit, stopsLevel + 1) : 0;

   double lot = NormalizeLot(InpLotSize);
   double price, sl = 0.0, tp = 0.0;

   if(type == ORDER_TYPE_BUY)
   {
      price = tick.ask;
      if(slPts > 0) sl = NormalizeDouble(price - slPts * point, digits);
      if(tpPts > 0) tp = NormalizeDouble(price + tpPts * point, digits);
      if(!trade.Buy(lot, _Symbol, price, sl, tp, InpTradeComment))
         PrintFormat("BUY failed: %u %s", trade.ResultRetcode(), trade.ResultRetcodeDescription());
   }
   else
   {
      price = tick.bid;
      if(slPts > 0) sl = NormalizeDouble(price + slPts * point, digits);
      if(tpPts > 0) tp = NormalizeDouble(price - tpPts * point, digits);
      if(!trade.Sell(lot, _Symbol, price, sl, tp, InpTradeComment))
         PrintFormat("SELL failed: %u %s", trade.ResultRetcode(), trade.ResultRetcodeDescription());
   }
}
//+------------------------------------------------------------------+
