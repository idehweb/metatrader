//+------------------------------------------------------------------+
//|                                                    For_Clint.mq4 |
//|                                           Copyright 2017, Yohana |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Yohana"
#property link      "https://www.mql5.com/en/users/yohana/seller#products"
#property version   "1.00"
#property strict

//--- input parameters
input int MagicNo=0;//Magic Number
input double Lot=0.01;//Lot size
input int Slip=3;//Slippage
input int StopRange=10;//Pips to place stop order
input int TP=20;//Pips target
input int SL=20;//Pips stoploss
input string TradeLog="ClintTaylor91";//Trade Comment
input bool alert_hp=false;//Send trade notification to smartphone
input bool alert_email=false;//Send trade notification to email 

int ticket, Dgt;
double position, target, stop;
double newlot;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   CheckVolumeValue(Lot);
   //if (Digits==4) Dgt=1;
   //else
   //if (Digits==5||Digits==2||Digits==3) Dgt=10;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //--clear your screen when EA exit, etc.
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   //--- your criteria to place pending order
   if(............)       //<--write here for your criteria before placing buy_stop 
   {
     if(Buy_Stop(High[1],StopRange,newlot,SL,TP,MagicNo,TradeLog,Slip,"Your description"))
     {
       //--succeed
       //--send alert notification
     }
     else
     {
       //--failed
       //--send alert notification
     }
   }
   //---
   
  }//--end of OnTick



//+---------------------+
//|  Function BUY STOP  |
//+---------------------+
bool Buy_Stop(double xhigh,  //-- your previous high
              int xrange,    //-- pips above the high
              double xlot,   //--lot size should be checked for minimum and maximum lot that allowed in trade
              int xsl,       //-- stoploss in pips
              int xtp,       //-- target in pips
              int xmagic,    //-- magic number
              string xlog,   //-- log comment in trade
              int xslippage, //-- slippage
              string xdesc)  //-- description more detail in "Print()"
{
    ResetLastError();
    Print("* Opening Buy_Stop: ",xdesc," at ",xrange," pips above last high ",NormalizeDouble(xhigh, Digits));
    
    position=xhigh+(xrange*Dgt*Point);//--price at xrange pips above xhigh
    target=position+(xtp*Dgt*Point);//--target at xtp pips above position
    stop=position-(xsl*Dgt*Point);//--stoploss at xsl pips below position
    
    ticket=OrderSend(Symbol(),OP_BUYSTOP,
           xlot, 
           NormalizeDouble(position,Digits), 
           xslippage,
           NormalizeDouble(stop,Digits),
           NormalizeDouble(target,Digits),
           xlog,xmagic,0,clrBlue);
     
     if(ticket<=0)
     { 
      Print("! Buy_Stop failed with error #",GetLastError());
      return(false);
     }
     else 
     { Print("* Position Buy_Stop ",xdesc," .. ticket #",ticket," placed successfully.");
       return(true);
     }
}//--end of Buy_Stop



//+------------------------------------------------------------------+
//| Check the correctness of the order volume                        |
//+------------------------------------------------------------------+
void CheckVolumeValue(double volume)
{
//--- minimal allowed volume for trade operations
   double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(volume<min_volume)
     {
      if(alert_email==true) SendMail("Lot volume changed.","Lot volume has changed to "+DoubleToString(min_volume,2)+" as minimum volume that allowed by broker.");
      if(alert_hp==true) SendNotification("Lot volume has changed to "+DoubleToString(min_volume,2)+" as minimum volume that allowed by broker.");
      Print("Lot volume has changed to "+DoubleToString(min_volume,2)+" as minimum volume that allowed by broker.");
      newlot=min_volume;
     }
   else
     newlot=Lot;
}//--end of CheckVolumeValue