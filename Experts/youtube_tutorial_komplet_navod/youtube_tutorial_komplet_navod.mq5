// zdroj: https://www.youtube.com/@mql5tutorial/videos

#include<Trade\Trade.mqh>
CTrade trade;

void OnTick()
  {
   
   
   
  }


// Pratabolic SAR - video 23
// Average True Range Oscilator - video 24
// Shifted SMA - video 25
// Trailing SL - videa 26 a 27


///////////////////////////////////////////////////////////////////////////////////////////
/////                                    MACD A RSI                                   /////  video 22
///////////////////////////////////////////////////////////////////////////////////////////
void MacdAndRsi()
  {
  
  // info o MACD
   double myMacdArray[];
   int MacdDefinition = iMACD(_Symbol, _Period, 12, 26, 9, PRICE_CLOSE);
   CopyBuffer(MacdDefinition, 0, 0, 3, myMacdArray);
   
   double macdValue = myMacdArray[0];
   
   // pokud je macd nad 0
   if(macdValue > 0)
     {
      // signal sell
     }
     
   // pokud je macd pod 0
   if(macdValue < 0)
     {
      // signal buy
     }
    
    
     // info o RSI
     double myRsiArray[];
     int RsiDefinition = iRSI(_Symbol,_Period, 20, PRICE_CLOSE);
     CopyBuffer(RsiDefinition, 0, 0, 3, myRsiArray);
     
     double rsiValue = myRsiArray[0];
     
     if(rsiValue > 70)
       {
        // signal sell
       }
       
     if(rsiValue < 30)
       {
        // signal buy
       }
  }



///////////////////////////////////////////////////////////////////////////////////////////
/////                     OBCHODNÍ SYSTÉM NA KŘIŽENÍ CENY SE SMA                      /////  video 19
///////////////////////////////////////////////////////////////////////////////////////////
void PriceAndSmaCross()
  {
   // info o ceně
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   int PriceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   
   // info o SMA
   double MyMovingAverageArray[];
   int MovingAverageDefinition = iMA(_Symbol,_Period, 20, 0, MODE_SMA, PRICE_CLOSE);
   CopyBuffer(MovingAverageDefinition, 0, 0, 3, MyMovingAverageArray);
   
   // křížení ceny se SMA směrem long - otevření long pozice
   if(PriceInfo[1].close > MyMovingAverageArray[1] && PriceInfo[2].close < MyMovingAverageArray[2] && PositionsTotal() == 0)
     {
      double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
      trade.Buy(0.1, NULL, Ask, Ask - 200 * _Point, Ask + 100 * _Point, NULL);
      Comment("Signal Buy");
     } 
   
   // křížení ceny se SMA směrem short - otevření short pozice
   if(PriceInfo[1].close < MyMovingAverageArray[1] && PriceInfo[2].close > MyMovingAverageArray[2] && PositionsTotal() == 0)
     {
      double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
      trade.Sell(0.1, NULL, Bid, Bid + 200 * _Point, Bid - 100 * _Point, NULL);
      Comment("Signal Sell");
     } 
  }



///////////////////////////////////////////////////////////////////////////////////////////
/////                ZADÁNÍ LONG STOP PŘÍKAZU (když cena stoupne nad)                 /////  video 15
///////////////////////////////////////////////////////////////////////////////////////////
void BuyStopEntry()
  {
   // zjistí aktuální cenu Ask pro aktuální symbol (instrument), _Digits zajistí správný počet desetiných míst
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   
   // jeslti není zadán už nějaký limit příkaz && jestli není otevřený nějaké obchod
   if(OrdersTotal() == 0 && PositionsTotal() == 0)
     {
     // Zadání limitního buy příkazu
      trade.BuyStop(0.1,                 // velikost pozice
                    Ask+(200*_Point),    // kde bude nákupní stop cena
                    _Symbol,             // aktuální symbol
                    Ask - 200 * _Point,  // SL - musí se počítat i se stop cenou, takže SL bude 400 pipů při otevření limitního příkazu
                    Ask + 400 * _Point,  // PT - musí se počítat i se stop conou, takže PT bude 200 pipů
                    ORDER_TIME_GTC ,     // Natavení časového formátu pro expiraci
                    0,                   // bez expirace
                    NULL);               // nez komentáře
     }
  }



///////////////////////////////////////////////////////////////////////////////////////////
/////              ZADÁNÍ LONG LIMITNÍHO PŘÍKAZU (když cena klesne pod)               /////
///////////////////////////////////////////////////////////////////////////////////////////
void BuyLimitEntry()
  {
   // zjistí aktuální cenu Ask pro aktuální symbol (instrument), _Digits zajistí správný počet desetiných míst
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   
   // jeslti není zadán už nějaký limit příkaz && jestli není otevřený nějaké obchod
   if(OrdersTotal() == 0 && PositionsTotal() == 0)
     {
     // Zadání limitního buy příkazu
      trade.BuyLimit(0.1,                 // velikost pozice
                     Ask-(200*_Point),    // kde bude nákupní limit cena
                     _Symbol,             // aktuální symbol
                     Ask - 400 * _Point,  // SL - musí se počítat i s limitní cenou, takže SL bude 200 pipů při otevření limitního příkazu
                     Ask + 200 * _Point,  // PT - musí se počítat i s limitní cenou, takže PT bude 400 pipů
                     ORDER_TIME_GTC ,     // Natavení časového formátu pro expiraci
                     0,                   // bez expirace
                     NULL);               // nez komentáře
     }
  }



///////////////////////////////////////////////////////////////////////////////////////////
/////                            OTEVŘENÍ KRÁTKÉ POZICE                               /////
///////////////////////////////////////////////////////////////////////////////////////////
void OpenShortPosition()
  {
   // zjistí aktuální cenu Bid pro aktuální symbol (instrument), _Digits zajistí správný počet desetiných míst
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

   // inicializace pole pro ceny
   MqlRates PriceInfo[];
   
   // Seřazení pole PriceInfo od aktuální svíce dolů
   ArraySetAsSeries(PriceInfo, true);
   
   // naplnění pole daty pro aktuální symbol, aktuální periodu, od 0 a počet 3
   int PriceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   
   // pokud je poslední uzavřená svíce medvědí
   if(PriceInfo[1].open > PriceInfo[1].close) 
     {
     // pokud není otevřený žádný jiný obchod
     if(PositionsTotal() == 0)
       {
       // otevře short pozici o velikosti 0.1, na aktuálním symbolu, za Bid cenu, SL + 300 pipů, PT - 150 pipů, bez komentáře 
       trade.Sell(0.1, NULL, Bid, Bid + 300 * _Point, Bid - 150 * _Point, NULL);
       }
     }
  }


  
///////////////////////////////////////////////////////////////////////////////////////////
/////                            OTEVŘENÍ DLOUHÉ POZICE                               /////
///////////////////////////////////////////////////////////////////////////////////////////
void OpenLongPosition()
  {
  // MIMO FUNKCE JE TŘEBA MÍT INCLUDOVANOU KNIHOVNU PRO OBCHODY A INICIALIZOVANOU INSTANCI TRADE
  // #include<Trade\Trade.mqh>
  // CTrade trade;
  
   // zjistí aktuální cenu Ask pro aktuální symbol (instrument), _Digits zajistí správný počet desetiných míst
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   // inicializace pole pro ceny
   MqlRates PriceInfo[];
   
   // Seřazení pole PriceInfo od aktuální svíce dolů
   ArraySetAsSeries(PriceInfo, true);
   
   // naplnění pole daty pro aktuální symbol, aktuální periodu, od 0 a počet 3
   int PriceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   
   // pokud je poslední uzavřená svíce bíčí
   if(PriceInfo[1].open < PriceInfo[1].close) 
     {
     // pokud není otevřený žádný jiný obchod
     if(PositionsTotal() == 0)
       {
       // otevře long pozici o velikosti 0.1, na aktuálním symbolu, za Ask cenu, SL - 300 pipů, PT + 150 pipů, bez komentáře 
       trade.Buy(0.1, NULL, Ask, Ask - 300 * _Point, Ask + 150 * _Point, NULL);
       }
     }
  }  

  
  
///////////////////////////////////////////////////////////////////////////////////////////
/////                                   VÝPOČET SMA                                   /////
///////////////////////////////////////////////////////////////////////////////////////////
void SimpleMovingAverage()
  {
   // inicializace pole, kde budou hodnoty SMA
   double MyMovingAverageArray[];
   
   // Definice mého klouzavého průměru
   int MovingAverageDefinition = iMA(_Symbol,_Period, 20, 0, MODE_SMA, PRICE_CLOSE);
   
   // Naplěnní mého pole hodnotami. první 0 - která čára indikátoru se má použít (SMA má jen jednu), záčátek, počet
   CopyBuffer(MovingAverageDefinition, 0, 0, 3, MyMovingAverageArray);
   
   // hodnota SMA pro poslední kompletní vykreslenou svíci
   double LastSMA_20 = MyMovingAverageArray[1];
   
   // vypsání hodnoty do grafu vlevo nahoře
   Comment("SMA 20: ", LastSMA_20);
  }