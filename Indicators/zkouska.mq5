//+------------------------------------------------------------------+
//|                                                          AMA.mq5 |
//|                   Copyright 2009-2020, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2020, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property version     "1.00"
#property description "Adaptive Moving Average"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot ExtAMABuffer
#property indicator_label1  "AMA"
#property indicator_type1   DRAW_LINE
#property indicator_color1  Red
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- default applied price
#property indicator_applied_price PRICE_OPEN
//--- input parameters
input int InpPeriodAMA=10;      // AMA period
input int InpFastPeriodEMA=2;   // Fast EMA period
input int InpSlowPeriodEMA=30;  // Slow EMA period
input int InpShiftAMA=0;        // AMA shift
//--- indicator buffer
double    ExtAMABuffer[];

double    ExtFastSC;
double    ExtSlowSC;
int       ExtPeriodAMA;
int       ExtSlowPeriodEMA;
int       ExtFastPeriodEMA;
//+------------------------------------------------------------------+
//| AMA initialization function                                      |
//+------------------------------------------------------------------+
void OnInit()
  {

//--- indicator buffers mapping
   SetIndexBuffer(0,ExtAMABuffer,INDICATOR_DATA);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+1);

  }









int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {

   return(rates_total);
  }
