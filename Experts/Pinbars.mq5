#resource "\\Files\\alert.wav"

string sound_file = "..\\Files\\alert.wav";



int OnInit()
  {
   PlaySound(sound_file);
   
   return(INIT_SUCCEEDED);
  }
  
  
 
void OnTick()
  {

   double high = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double low = iLow(_Symbol, PERIOD_CURRENT, 1);
   double open = iOpen(_Symbol, PERIOD_CURRENT, 1);
   double close = iClose(_Symbol, PERIOD_CURRENT, 1);
   
   double topCandleWick = 1;
   double lowerCandleWick = 1;
   double candleBody = 1;
   bool isDoji = false;
   string signal;
   

   if(open < close)                          // bíčí svíce
     {
       candleBody = close - open;
       topCandleWick = high - close;
       lowerCandleWick = open - low;
     }
   else if(open > close)                     // medvědí svíce
     {
       candleBody = open - close;
       topCandleWick = high - open;
       lowerCandleWick = close - low; 
     }
   else
     {
       isDoji = true;
     }
     

   
   if(topCandleWick > (candleBody * 5) && lowerCandleWick < candleBody)
     {
       signal = "sell";
       ObjectCreate(_Symbol, "MyObject", OBJ_ARROW_SELL, 0, TimeCurrent(), high);
       //ObjectSetInteger(0, "MyObject", OBJPROP_WIDTH, 20);
       //ObjectMove(_Symbol, "MyObject", 0, TimeCurrent(), high);
       PlaySound(sound_file);
     }
    
   if(lowerCandleWick > (candleBody * 5) && topCandleWick < candleBody)
     {
       signal = "buy";
       ObjectCreate(_Symbol, "MyObject", OBJ_ARROW_BUY, 0, TimeCurrent(), low);
       //ObjectSetInteger(0, "MyObject", OBJPROP_WIDTH, 20);
       //ObjectMove(_Symbol, "MyObject", 0, TimeCurrent(), high);
       PlaySound(sound_file);
     }   
  }

