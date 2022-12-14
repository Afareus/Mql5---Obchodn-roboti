//+------------------------------------------------------------------+
//|                                                    1_program.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>

input int a = 10;          // perioda MA
input int b = 20;          // perioda MA
int magicNumber = 1001;    // číslo pro rozeznávání pozic otevřených tímto EA
bool LongIsOpen;
bool ShortIsOpen;

CPositionInfo  m_position; // trade position object
CTrade         m_trade;    // trading object
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
      //int c = a + b;
      
      LongIsOpen = false;
      ShortIsOpen = false;

      return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      TerminatePosition();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      
      int handle_1 = iMA(Symbol(),0,a,0,MODE_SMA,PRICE_CLOSE);
      int handle_2 = iMA(Symbol(),0,b,0,MODE_SMA,PRICE_CLOSE);
      //int Ma3 = iMA(Symbol(),0,c,0,MODE_SMA,PRICE_CLOSE);
      
      double maArray_1[];
      double maArray_2[];
      
      CopyBuffer(handle_1,0,0,1,maArray_1);
      CopyBuffer(handle_2,0,0,1,maArray_2);
      
      double Ma1 = maArray_1[0];
      double Ma2 = maArray_2[0];
      
      //Comment("           MA1 " + maArray_1[0] + "         MA2 " + maArray_2[0]);
      
      if(!LongIsOpen && Ma1 > Ma2)
        {   
            TerminatePosition();
            Buy();
            
            LongIsOpen = true;
            ShortIsOpen = false;
        }
        
      if(!ShortIsOpen && Ma1 < Ma2)
        {   
            TerminatePosition();
            Sell();
            
            ShortIsOpen = true;
            LongIsOpen = false;
        }
   
  }
//+------------------------------------------------------------------+
//| Trade functions                                                  |
//+------------------------------------------------------------------+
void Buy()
  {
      MqlTradeRequest request = {};
      MqlTradeResult  result = {};
      
      request.action   = TRADE_ACTION_DEAL;                     // type of trade operation
      request.symbol   = Symbol();                              // symbol
      request.volume   = 0.01;                                  // volume of 0.01 lot
      request.type     = ORDER_TYPE_BUY;                        // order type
      request.price    = SymbolInfoDouble(Symbol(),SYMBOL_ASK); // price for opening
      request.deviation= 10;                                    // allowed deviation from the price
      request.magic    = magicNumber;                           // MagicNumber of the order
      
      if(!OrderSend(request,result)) {
         PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
      }
         
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
  }
  
void Sell()
  {
      MqlTradeRequest request = {};
      MqlTradeResult  result = {};
      
      request.action   = TRADE_ACTION_DEAL;                     // type of trade operation
      request.symbol   = Symbol();                              // symbol
      request.volume   = 0.01;                                  // volume of 0.01 lot
      request.type     = ORDER_TYPE_SELL;                       // order type
      request.price    = SymbolInfoDouble(Symbol(),SYMBOL_BID); // price for opening
      request.deviation= 10;                                    // allowed deviation from the price
      request.magic    = magicNumber;                           // MagicNumber of the order
      
      if(!OrderSend(request,result)) {
         PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
      }
         
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
  }
  
void TerminatePosition()
  {
      for(int i=PositionsTotal()-1; i>=0; i--) { // returns the number of current positions
         if(m_position.SelectByIndex(i)) { // selects the position by index for further access to its properties
            if(m_position.Symbol()==Symbol()) {
               m_trade.SetExpertMagicNumber(m_position.Magic());
               if(!m_trade.PositionClose(m_position.Ticket())) { // close a position by the specified m_symbol
                  Print(__FILE__," ",__FUNCTION__,", ERROR: ","CTrade.PositionClose ",m_position.Ticket());
               }
            }
         }
      }
  }

//+------------------------------------------------------------------+
