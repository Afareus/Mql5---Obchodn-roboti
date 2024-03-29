#resource "\\Files\\alert.wav"

string sound_file = "..\\Files\\alert.wav";
bool isLastSignal = false;


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
   
   // medvědí pinbar
   if(topCandleWick > (candleBody * 5) && lowerCandleWick < candleBody)
     {
       signal = "sell";
       ObjectCreate(_Symbol, "MySeelArrow", OBJ_ARROW_SELL, 0, iTime(_Symbol, _Period, 1), high);
       PlaySound(sound_file);
       
       StopTestInMySeason();
     }
     else
     {
        isLastSignal = false;
     }
    
   // bíčí pinbar
   if(lowerCandleWick > (candleBody * 5) && topCandleWick < candleBody)
     {
       signal = "buy";
       ObjectCreate(_Symbol, "MyBuyArrow", OBJ_ARROW_BUY, 0, iTime(_Symbol, _Period, 1), low);
       PlaySound(sound_file);
       
       StopTestInMySeason();
     }
     else
     {
        isLastSignal = false;
     }  
  }


void StopTestInMySeason()
{
   if(!isLastSignal) // nefunguje... proč ?
   {
      isLastSignal = true;
      DebugBreak();
   }

   
   
   
   //TesterStop(); // funguje ale test se úplně ukončí

   // kontrola jestli je obchodní doba mezi 9 a 14h (zatím neotestováno)
   datetime currentTime = TimeCurrent();
   int currentHour = (int)MathFloor(currentTime / 3600) % 24;
   
   if(currentHour >= 9 && currentHour < 14)
   {
      //TesterStop();
   }
}
