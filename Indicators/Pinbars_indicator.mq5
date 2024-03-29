#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

#resource "\\Files\\alert.wav"

string sound_file = "..\\Files\\alert.wav";


int OnInit()
  {
   PlaySound(sound_file);
  
   return(INIT_SUCCEEDED);
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

    double topCandleWick = 1;
    double lowerCandleWick = 1;
    double candleBody = 1;
    bool isDoji = false;
    string signal;

    if (open[1] < close[1])     // bullish candle
    {
      candleBody = close[1] - open[1];
      topCandleWick = high[1] - close[1];
      lowerCandleWick = open[1] - low[1];
    }
    else if (open[1] > close[1])  // bearish candle
    {
      candleBody = open[1] - close[1];
      topCandleWick = high[1] - open[1];
      lowerCandleWick = close[1] - low[1];
    }
    else   // doji candle
    {
      isDoji = true;
    }

    // draw arrows on chart
    if(topCandleWick > (candleBody * 5) && lowerCandleWick < candleBody)
    {
        signal = "sell";
        ObjectCreate(_Symbol, "MySeelArrow", OBJ_ARROW_SELL, 0, time[1], high[1]);
        
        PlaySound(sound_file);
        StopTestInMySeason();
        Sleep(2000);
    }

    if(lowerCandleWick > (candleBody * 5) && topCandleWick < candleBody)
    {
        signal = "buy";
        ObjectCreate(_Symbol, "MyBuyArrow", OBJ_ARROW_BUY, 0, time[1], low[1]);
        
        PlaySound(sound_file);
        StopTestInMySeason();
        Sleep(2000);
    }
   
   

   return(rates_total);
  }



void StopTestInMySeason()
{
   datetime currentTime = TimeCurrent();
   int currentHour = (int)MathFloor(currentTime / 3600) % 24;
   
   if(currentHour >= 9 && currentHour < 14)
   {
    Sleep(5000);
   }
}