//+------------------------------------------------------------------+
//|                                            CoToJeGenerovatEA.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
//--- available signals
#include <Expert\Signal\SignalStoch.mqh>
//--- available trailing
#include <Expert\Trailing\TrailingNone.mqh>
//--- available money management
#include <Expert\Money\MoneyFixedRisk.mqh>
//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//--- inputs for expert
input string         Expert_Title             ="CoToJeGenerovatEA"; // Document name
ulong                Expert_MagicNumber       =1242;                //
bool                 Expert_EveryTick         =false;               //
//--- inputs for main signal
input int            Signal_ThresholdOpen     =10;                  // Signal threshold value to open [0...100]
input int            Signal_ThresholdClose    =10;                  // Signal threshold value to close [0...100]
input double         Signal_PriceLevel        =0.0;                 // Price level to execute a deal
input double         Signal_StopLevel         =50.0;                // Stop Loss level (in points)
input double         Signal_TakeLevel         =50.0;                // Take Profit level (in points)
input int            Signal_Expiration        =4;                   // Expiration of pending orders (in bars)
input int            Signal_0_Stoch_PeriodK   =8;                   // Stochastic(8,3,3,...) D1 K-period
input int            Signal_0_Stoch_PeriodD   =3;                   // Stochastic(8,3,3,...) D1 D-period
input int            Signal_0_Stoch_PeriodSlow=3;                   // Stochastic(8,3,3,...) D1 Period of slowing
input ENUM_STO_PRICE Signal_0_Stoch_Applied   =STO_LOWHIGH;         // Stochastic(8,3,3,...) D1 Prices to apply to
input double         Signal_0_Stoch_Weight    =1.0;                 // Stochastic(8,3,3,...) D1 Weight [0...1.0]
input int            Signal_1_Stoch_PeriodK   =20;                  // Stochastic(20,6,3,...) K-period
input int            Signal_1_Stoch_PeriodD   =6;                   // Stochastic(20,6,3,...) D-period
input int            Signal_1_Stoch_PeriodSlow=3;                   // Stochastic(20,6,3,...) Period of slowing
input ENUM_STO_PRICE Signal_1_Stoch_Applied   =STO_LOWHIGH;         // Stochastic(20,6,3,...) Prices to apply to
input double         Signal_1_Stoch_Weight    =1.0;                 // Stochastic(20,6,3,...) Weight [0...1.0]
//--- inputs for money
input double         Money_FixRisk_Percent    =2.0;                 // Risk percentage
//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Initializing expert
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing expert");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Creating signal
   CExpertSignal *signal=new CExpertSignal;
   if(signal==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating signal");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//---
   ExtExpert.InitSignal(signal);
   signal.ThresholdOpen(Signal_ThresholdOpen);
   signal.ThresholdClose(Signal_ThresholdClose);
   signal.PriceLevel(Signal_PriceLevel);
   signal.StopLevel(Signal_StopLevel);
   signal.TakeLevel(Signal_TakeLevel);
   signal.Expiration(Signal_Expiration);
//--- Creating filter CSignalStoch
   CSignalStoch *filter0=new CSignalStoch;
   if(filter0==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter0");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter0);
//--- Set filter parameters
   filter0.Period(PERIOD_D1);
   filter0.PeriodK(Signal_0_Stoch_PeriodK);
   filter0.PeriodD(Signal_0_Stoch_PeriodD);
   filter0.PeriodSlow(Signal_0_Stoch_PeriodSlow);
   filter0.Applied(Signal_0_Stoch_Applied);
   filter0.Weight(Signal_0_Stoch_Weight);
//--- Creating filter CSignalStoch
   CSignalStoch *filter1=new CSignalStoch;
   if(filter1==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter1");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter1);
//--- Set filter parameters
   filter1.PeriodK(Signal_1_Stoch_PeriodK);
   filter1.PeriodD(Signal_1_Stoch_PeriodD);
   filter1.PeriodSlow(Signal_1_Stoch_PeriodSlow);
   filter1.Applied(Signal_1_Stoch_Applied);
   filter1.Weight(Signal_1_Stoch_Weight);
//--- Creation of trailing object
   CTrailingNone *trailing=new CTrailingNone;
   if(trailing==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add trailing to expert (will be deleted automatically))
   if(!ExtExpert.InitTrailing(trailing))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set trailing parameters
//--- Creation of money object
   CMoneyFixedRisk *money=new CMoneyFixedRisk;
   if(money==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add money to expert (will be deleted automatically))
   if(!ExtExpert.InitMoney(money))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set money parameters
   money.Percent(Money_FixRisk_Percent);
//--- Check all trading objects parameters
   if(!ExtExpert.ValidationSettings())
     {
      //--- failed
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Tuning of all necessary indicators
   if(!ExtExpert.InitIndicators())
     {
      //--- failed
      printf(__FUNCTION__+": error initializing indicators");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- ok
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ExtExpert.Deinit();
  }
//+------------------------------------------------------------------+
//| "Tick" event handler function                                    |
//+------------------------------------------------------------------+
void OnTick()
  {
   ExtExpert.OnTick();
  }
//+------------------------------------------------------------------+
//| "Trade" event handler function                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
   ExtExpert.OnTrade();
  }
//+------------------------------------------------------------------+
//| "Timer" event handler function                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   ExtExpert.OnTimer();
  }
//+------------------------------------------------------------------+
