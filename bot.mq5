//+------------------------------------------------------------------+
//|                                                          bot.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"  
#include "Idehweb/Idehweb.mqh"
Idehweb bot;
//double candles[10];
//int Idehweb=Idehweb::Idehweb(void);
//Idehweb::Idehweb(void);
//Idehweb ssss;
//+------------------------------------------------------------------+
//| Expert initialization function                                    |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
//EventSetTimer(60); 
//   EventSetTimer((15*60));
   bot.SetUpPage();
  // EventSetTimer((15*60));
//ghj  c
// string bot1=Idehweb::Name(void); 
// Idehweb::getCandle(void);
//---
   return(INIT_SUCCEEDED);
  }
//+---------------------------------------------- -------- ------------+
//| Expert deinitialization function                                   |
//+--------------------------------------------------- ---------------+
void OnDeinit(const int reason)
  {
//Idehweb::  
//--- destroy timer
   EventKillTimer(); 

  }

//+--------------------------------------------- ------------- --------+
//| Timer function                                                     |
//+------------------------------------------ ------------------------+
void OnTimer()
  { 
//---
 
  }  
//+------------------------------------------------------------------+

//| Expert tick function                                              |

//+--------------------------------------------------- ---------------+
    
void OnTick()   
    
  {     
//v  
 
   static datetime timeCur = iTime(Symbol(),PERIOD_CURRENT,0);
   datetime timePre = timeCur;  
   timeCur=iTime(Symbol(),PERIOD_CURRENT,0);  
   bool isNewBar = timeCur != timePre;  
   //dar candle jadid mohasebat kon
   if(isNewBar) 
     {   
      
     //age candle jadid bood, 4 ta candle akhar o begir
      bot.getCandle(4);    
      bot.getSameColors(3);   
        
     }   
  bot.checkOrderForLashkhori();   
 
  } 
  
 
//+---------------------------------------------- ------------ --------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade() 
  {
//--- 
//Idehweb::getCandle();
 
  }  
//+------------------------------------------------------------------+ 
//| TradeTransaction function                                         |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)  
  {
//---

  }
//+------------------------------------------------------------------+ 
