//+------------------------------------------------------------------+
//|                                                      Idehweb.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Object.mqh>
#include <Trade\Trade.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\DealInfo.mqh>

//https://www.mql5.com/en/articles/2555
//+------------------------------------------------------------------+
//| Class Idehweb.                                              |
//| Pupose: Base class of chart objects.                             |
//|              Derives from class Bot.                         |
//+------------------------------------------------------------------+
class Idehweb
  {
protected:
   string            bot_name;               // unique name object name
   int               IntPeriod;
   int               MomentumPeriod;
   double            MomentumBuffer[];
   double            lastPriceForOrder;
   MqlRates          candles[];
   int               xxx;
   CTrade            m_trade;
   CPositionInfo     m_position;
   CDealInfo         deal;
   int               OrderCount;
   double               thePriceOfOrder;
   string            allObjects[5];
public:
                     Idehweb(void);
                    ~Idehweb(void);
   //--- method of identifying the object
   // virtual int       Type(void) const { return(0x8888); }
   //--- methods of access to protected data
   //  long              hammali(void) const { return(bot_name);}
   string            Name() const { return(bot_name); }
   bool              Name(const string name);
   void              getCandle(const int count_of_candles);
   void              getSameColors(const int count_of_candles);
   bool              SetUpPage();
   string            theColor(const double open, const double close);
   bool              isDuje(const double open, const double close, const double low, const double high);
   void              CreateTheSign(const int i, const double high, const ENUM_OBJECT sign, const string id);
   bool              setOrder(const double x, const string type, const double sl, const double tp, const int index, const double high);
   bool              CheckVolumeValue(double volume, string &description);
   bool              checkOrderForLashkhori();
   int               TotalOrderCount();
   double            ProfitAllPositions();
   double            GetPercentChanges(const double orderPrice);
   void              Idehweb::RemoveSigns();
   // string            getTrend(double candles);
  };
//Idehweb::xxx=0;
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
Idehweb::Idehweb(void)
  {
//--- initialize protected data
///Detach();
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
Idehweb::~Idehweb(void)
  {
  }
//+------------------------------------------------------------------+
//| Changing name of the object                                      |
//+------------------------------------------------------------------+
bool Idehweb::Name(const string name = "leader")
  {
   bot_name = name;
   return(true);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Idehweb::getSameColors(int i)
  {
   RemoveSigns(); //object haye safaro pak kon
   string color_of_first = theColor(candles[1].open, candles[1].close);
   string color_of_second = theColor(candles[2].open, candles[2].close);
   string color_of_third = theColor(candles[3].open, candles[3].close);
//Print("color_of_first: ",color_of_first);
// Print("color_of_second: ",color_of_second);
// Print("color_of_third: ",color_of_third);
   CreateTheSign(1, NormalizeDouble(candles[1].high, Digits()), OBJ_ARROW_THUMB_UP, color_of_first);
   CreateTheSign(2, NormalizeDouble(candles[2].high, Digits()), OBJ_ARROW_THUMB_UP, color_of_second);
   CreateTheSign(3, NormalizeDouble(candles[3].high, Digits()), OBJ_ARROW_THUMB_UP, color_of_third);
  // CreateTheSign(1, NormalizeDouble(candles[3].high, Digits()), OBJ_ARROW_THUMB_UP, "");
   if(color_of_first == "red" && color_of_second == "red" && color_of_third == "red")
     {
      double sl = 0;
      double tp = 0;
      Print("Red");
      //setOrder(((candles[1].low + candles[1].high) / 2), "sell", sl, tp, i, candles[0].high);
     }
// string order_symbol=Symbol();                                      // symbol
// int    digits=(int)SymbolInfoInteger(order_symbol,SYMBOL_DIGITS);
// lastPriceForOrder=NormalizeDouble((candles[1].low+candles[1].high)/2,digits);
// m_trade.Sell(1,Symbol(),NormalizeDouble((candles[1].low+candles[1].high)/2,digits),NormalizeDouble(sl,digits),NormalizeDouble(tp,digits));
   if(color_of_first == "green" && color_of_second == "green" && color_of_third == "green")
     {
      // CreateTheSign(4,NormalizeDouble(candles[0].high,Digits()),OBJ_ARROW_THUMB_UP);
      // CreateTheSign(3,NormalizeDouble(candles[1].high,Digits()),OBJ_ARROW_THUMB_UP);
      // CreateTheSign(2,NormalizeDouble(candles[2].high,Digits()),OBJ_ARROW_THUMB_UP);
      // CreateTheSign(1,NormalizeDouble(candles[3].high,Digits()),OBJ_ARROW_THUMB_UP);
      double sl = 0;
      double tp = 0;
      Print("green");
      // setOrder(((candles[1].low+candles[1].high)/2),"buy",sl,tp,i,candles[0].high);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Idehweb::RemoveSigns()
  {
   Print("Remove signs...");
// ArraySize()
   for(int i = 0; i < ArraySize(allObjects); i++)
     { 
    
      if(allObjects[i]!=NULL)
        {
         Print("Remove ", allObjects[i]);
         ObjectDelete(ChartID(), allObjects[i]);
        }
     }
   ArrayRemove(allObjects, WHOLE_ARRAY);
  }
//+------------------------------------------------------------------+
//| Check the correctness of the order volume                        |
//+------------------------------------------------------------------+
bool Idehweb::CheckVolumeValue(double volume, string &description)
  {
//--- minimal allowed volume for trade operations
   double min_volume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   if(volume < min_volume)
     {
      description = StringFormat("Volume is less than the minimal allowed SYMBOL_VOLUME_MIN=%.2f", min_volume);
      return(false);
     }
//--- maximal allowed volume of trade operations
   double max_volume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   if(volume > max_volume)
     {
      description = StringFormat("Volume is greater than the maximal allowed SYMBOL_VOLUME_MAX=%.2f", max_volume);
      return(false);
     }
//--- get minimal step of volume changing
   double volume_step = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   int ratio = (int)MathRound(volume / volume_step);
   if(MathAbs(ratio * volume_step - volume) > 0.0000001)
     {
      description = StringFormat("Volume is not a multiple of the minimal step SYMBOL_VOLUME_STEP=%.2f, the closest correct volume is %.2f",
                                 volume_step, ratio * volume_step);
      return(false);
     }
   description = "Correct volume value";
   return(true);
  }

//+------------------------------------------------------------------+
//| n candle akhir o begir (dar period feli)                                                  |
//+------------------------------------------------------------------+
void Idehweb::getCandle(int count_of_candles)
  {
   ENUM_TIMEFRAMES t = PERIOD_CURRENT;
   ResetLastError();
   int copied = CopyRates(Symbol(), t, 0, count_of_candles, candles);
   ArrayReverse(candles,0,WHOLE_ARRAY);
   if(copied <= 0)
     {
      Print("Error copying price data ", GetLastError());
     }
  }

//+------------------------------------------------------------------+
//| rangbandie nemoodar          |
//+------------------------------------------------------------------+
bool Idehweb::SetUpPage()
  {
   Print("==> SetUpPage();");
// OrderCount=0;
   ChartSetInteger(ChartID(), CHART_COLOR_CANDLE_BEAR, clrRed);
   ChartRedraw();
   Sleep(1000);
   ChartSetInteger(ChartID(), CHART_COLOR_CHART_DOWN, clrRed);
   ChartRedraw();
   Sleep(1000);
   ChartSetInteger(ChartID(), CHART_COLOR_CANDLE_BULL, clrGreen);
   ChartRedraw();
   Sleep(1000);
   ChartSetInteger(ChartID(), CHART_COLOR_CHART_UP, clrGreen);
   ChartRedraw();
   Sleep(1000);
   ChartSetInteger(ChartID(), CHART_FIRST_VISIBLE_BAR, clrAqua);
   ChartRedraw();
   Sleep(1000);
   ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrWhite);
   ChartRedraw();
   Sleep(1000);
   if(MomentumPeriod < 0)
     {
      IntPeriod = 14;
      Print("Period parameter has an incorrect value. The following value is to be used for calculations ", IntPeriod);
     }
   else
      IntPeriod = MomentumPeriod;
//---- buffers
   SetIndexBuffer(0, MomentumBuffer, INDICATOR_DATA);
//---- indicator name to be displayed in DataWindow and subwindow
   IndicatorSetString(INDICATOR_SHORTNAME, "Momentum" + "(" + string(IntPeriod) + ")");
//--- set index of the bar the drawing starts from
   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, IntPeriod - 1);
//--- set 0.0 as an empty value that is not drawn
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
//--- indicator accuracy to be displayed
   IndicatorSetInteger(INDICATOR_DIGITS, 2);
   EventSetTimer((15 * 60));
   return(true);
  }

//+------------------------------------------------------------------+
string Idehweb::theColor(double open, double close)
  {
   if(open < close)
      return "green";
   else
      if(open > close)
         return "red";
      else
         return "birang";
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Idehweb::isDuje(double open, double close, double low, double high)
  {
   string the_color = theColor(open, close);
   if(fabs(open - close) <= ((high - low) * 0.1))
     {
      return true;
     }
   else
     {
      return false;
     }
  }
//+------------------------------------------------------------------+
void Idehweb::CreateTheSign(int i, double high, const ENUM_OBJECT sign, string id)
  {
   if(!xxx)
     {
      xxx = 0;
     }
   string ss = IntegerToString(
                  xxx,              // number
                  1,           // length of result string
                  ""      // filler
               );
   ss = ss + id; //id monhaser b fard
//ArrayFill(allObjects, 0, 1, ss); //beriz tu array k badan pak konim o shulugh nashe
   allObjects[i] = ss;
   ArrayPrint(allObjects);
//ArrayResize(allObject,)
   xxx++;
   datetime da = TimeCurrent() - (i * PeriodEnumToMinutes() * 60);
   double t = (high + (Point() * 20));
   Print("object created: ", " ", da, " ", i, " #", high, " ", id, " ", ss);
   bool d = ObjectCreate(ChartID(), ss, sign, 0, da, t);
   xxx++;
  }
//+-
//+------------------------------------------------------------------+
int PeriodEnumToMinutes(ENUM_TIMEFRAMES period = PERIOD_CURRENT)
  {
   period = period == PERIOD_CURRENT ? (ENUM_TIMEFRAMES)Period() : period;
   return PeriodSeconds(period) / 60;
  }
bool Idehweb::setOrder(double x, string type, double sl, double tp, int index, double high)                             // Special function start()

  {
   Print("OrderCount: ", TotalOrderCount());
//if(!TotalOrderCount())
//{
//CreateTheSign(4, NormalizeDouble(high, Digits()), OBJ_ARROW_THUMB_UP, "set order");
   string order_symbol = Symbol();                                    // symbol
   int    digits = (int)SymbolInfoInteger(order_symbol, SYMBOL_DIGITS);
   double point = SymbolInfoDouble(order_symbol, SYMBOL_POINT);
   int offset = 50;
   MqlTick last_tick = {};
   ResetLastError();
   SymbolInfoTick(_Symbol, last_tick);
   double price;
   if(type == "buy")
     {
      int distance = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
      price = SymbolInfoDouble(Symbol(), SYMBOL_ASK) - distance * point;
      if(x > price)
        {
         x = price;
        }
      price = NormalizeDouble(price, digits);               // normalized opening price
      lastPriceForOrder = NormalizeDouble(x, digits);
      if(m_trade.BuyLimit(0.1, NormalizeDouble(x, digits), Symbol(), NormalizeDouble(sl, digits), NormalizeDouble(tp, digits)))
        {
         return true;
        }
      else
        {
         return false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(type == "sell")
     {
      int distance = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
      price = SymbolInfoDouble(Symbol(), SYMBOL_BID) + distance * point;
      if(x < price)
        {
         x = price;
        }
      price = NormalizeDouble(price, digits);               // normalized opening price
      lastPriceForOrder = NormalizeDouble(x, digits);
      if(m_trade.SellLimit(1, NormalizeDouble(x, digits), Symbol(), NormalizeDouble(sl, digits), NormalizeDouble(tp, digits)))
        {
         return true;
        }
      else
        {
         return false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   Print(" ");
   OrderCount++;
//   }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Idehweb::TotalOrderCount()
  {
   int count = OrdersTotal();
   return(count);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Idehweb::GetPercentChanges(double orderPrice)
  {
   double price = SymbolInfoDouble(Symbol(), SYMBOL_LAST);
// ulong distance=(ulong)SymbolInfoInteger(Symbol(),SYMBOL_TRADE_STOPS_LEVEL);
   double diff = orderPrice - price;
   return ((diff * 100) / orderPrice) * 100;
//return(count);
  }
//+------------------------------------------------------------------+
bool Idehweb::checkOrderForLashkhori()                                  // Special function start()

  {
   string order_symbol = Symbol();                                    // symbol
   int    digits = (int)SymbolInfoInteger(order_symbol, SYMBOL_DIGITS);
   if(PositionsTotal() > 0)
     {
      Print(" ");
      //Print("====> checkOrderForLashkhori ",NormalizeDouble(price,digits)," ",distance," ",NormalizeDouble(lastPriceForOrder,digits)," ",NormalizeDouble((price-lastPriceForOrder),digits));
      // if(lastPriceForOrder>(price-(lastPriceForOrder/100)))
      //  m_trade.PositionClose(Symbol(),-1);
      Print("ProfitAllPositions====>   ", ProfitAllPositions(), " ", GetPercentChanges(lastPriceForOrder), "%");
      if(GetPercentChanges(lastPriceForOrder) > 1)
        {
         m_trade.PositionClose(Symbol(), -1);
        }
      //   if(GetPercentChanges(lastPriceForOrder)<-5)
      //   {
      //  m_trade.PositionClose(Symbol(),-1);
      // }
      Print(" ");
      //SymbolInfoTick(Symbol(),last_tick)
      return(true);
     }
   else
     {
      return false;
     }
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Idehweb::ProfitAllPositions(void)
  {
   double profit = 0.0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
      if(m_position.SelectByIndex(i)) // selects the position by index for further access to its properties
         profit += m_position.Commission() + m_position.Swap() + m_position.Profit();
//---
   return(profit);
  }
//+------------------------------------------------------------------+
//string Idehweb::getTrend(double candles)
//{
//return candles;
// }


//+------------------------------------------------------------------+
