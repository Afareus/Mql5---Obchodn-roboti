
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {   
  }

void OnTick()
  {
   // info o lokální ceně
   MqlRates LocalPriceInfo[];
   ArraySetAsSeries(LocalPriceInfo, true);
   int PriceData1 = CopyRates(_Symbol, _Period, 0, 200, LocalPriceInfo);            // pro 100 svící
   
   // info o dlouhodobější ceně
   MqlRates LongPriceInfo[];
   ArraySetAsSeries(LongPriceInfo, true);
   int PriceData2 = CopyRates(_Symbol, _Period, 0, 1000, LongPriceInfo);            // pro 100 svící
   
   // zjistit jestli maximum z lokální ceny je menší než z dlouhodobé ceny

   
  }

