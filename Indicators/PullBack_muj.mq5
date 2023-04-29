#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

double ExtMapBuffer[];

void OnInit()
{
   SetIndexBuffer(0, ExtMapBuffer);
   PlotIndexSetInteger(0, PLOT_LINE_STYLE, STYLE_SOLID);
   PlotIndexSetInteger(0, PLOT_LINE_WIDTH, 2);
   PlotIndexSetString(0, PLOT_LABEL, "Pullback");
}

int OnCalculate(const int rates_total,
                 const int prev_calculated,
                 const datetime &time[],
                 const double &open[],
                 const double &high[],
                 const double &low[],
                 const double &close[],
                 const long &tick_volume[],
                 const long &volume[],
                 const int &spread[])
{
   int limit = rates_total - prev_calculated;
   if (limit > 5) limit = 5;

   for (int i = limit; i >= 0; i--)
   {
      double lastClose = close[i + 1];
      double currentClose = close[i];

      bool isUptrend = lastClose <= currentClose;

      bool isPullback = false;
      for (int j = 1; j <= 3; j++)
      {
         double prevClose = close[i + j];
         isPullback = isUptrend ? prevClose > currentClose : prevClose < currentClose;
         if (!isPullback)
            break;
      }

      ExtMapBuffer[i] = isPullback ? currentClose : 0.0;
   }

   return (rates_total);
}
