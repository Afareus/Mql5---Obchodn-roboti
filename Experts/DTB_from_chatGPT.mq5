#include <Trade/Trade.mqh>
#include <ChartObjects/ChartObjects.mqh>

input double StopLoss = 200;
input double TakeProfit = 500;

void OnTick()
{
    double MaxHigh = iHighest(NULL, 0, MODE_HIGH, 14, 1);
    double MinLow = iLowest(NULL, 0, MODE_LOW, 14, 1);

    if (Close[0] >= MaxHigh)
    {
        int Ticket = OrderSend(Symbol(), OP_SELL, 0.1, Ask, 3, Ask - StopLoss * Point, Ask + TakeProfit * Point);
        if (Ticket > 0)
        {
            Print("SELL order placed, ticket is ", Ticket);
        }
    }

    if (Close[0] <= MinLow)
    {
        int Ticket = OrderSend(Symbol(), OP_BUY, 0.1, Bid, 3, Bid + StopLoss * Point, Bid - TakeProfit * Point);
        if (Ticket > 0)
        {
            Print("BUY order placed, ticket is ", Ticket);
        }
    }
}