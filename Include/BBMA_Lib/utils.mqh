//+------------------------------------------------------------------+
//|                                                         utils.mqh |
//+------------------------------------------------------------------+
#include "types.mqh"
#include "constants.mqh"

//+------------------------------------------------------------------+
//| Calculate lot size based on risk percentage                        |
//+------------------------------------------------------------------+
double CalcLotSize(double riskPercent, double stopLossPoints) {
    double accountBalance = AccountBalance();
    double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
    double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
    double minLot = MarketInfo(Symbol(), MODE_MINLOT);
    double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
    
    double riskAmount = accountBalance * riskPercent / 100.0;
    double lotSize = riskAmount / (stopLossPoints * tickValue);
    
    // Normalize lot size
    lotSize = MathFloor(lotSize / lotStep) * lotStep;
    
    return MathMax(minLot, MathMin(maxLot, lotSize));
}

//+------------------------------------------------------------------+
//| Check if current time is within trading hours                      |
//+------------------------------------------------------------------+
bool IsWithinTradingHours() {
    datetime now = TimeCurrent();
    int hour = TimeHour(now);
    int dayOfWeek = TimeDayOfWeek(now);
    
    // Check trading session hours
    if(hour < TRADING_START_HOUR || hour >= TRADING_END_HOUR) return false;
    
    // Check weekly restrictions
    if(dayOfWeek == 1 && hour < MONDAY_START_HOUR) return false;
    if(dayOfWeek == 5 && hour >= FRIDAY_END_HOUR) return false;
    if(dayOfWeek == 0 || dayOfWeek == 6) return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate risk metrics                                             |
//+------------------------------------------------------------------+
void CalcRiskMetrics(SRiskMetrics &metrics) {
    metrics.dailyDrawdown = 100 * (1 - AccountEquity() / AccountBalance());
    metrics.maxDrawdown = 100 * (1 - AccountEquity() / AccountBalance());
    metrics.consecutiveLosses = 0;
    metrics.profitFactor = 0;
    metrics.equity = AccountEquity();
    metrics.balance = AccountBalance();
    
    // Calculate consecutive losses and profit factor
    int total = OrdersHistoryTotal();
    double totalProfit = 0, totalLoss = 0;
    int currentLosses = 0;
    
    for(int i = total - 1; i >= 0; i--) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            if(OrderMagicNumber() == EA_MAGIC) {
                double profit = OrderProfit() + OrderSwap() + OrderCommission();
                if(profit < 0) {
                    totalLoss += -profit;
                    currentLosses++;
                    metrics.consecutiveLosses = MathMax(metrics.consecutiveLosses, currentLosses);
                } else {
                    totalProfit += profit;
                    currentLosses = 0;
                }
            }
        }
    }
    
    metrics.profitFactor = totalLoss > 0 ? totalProfit / totalLoss : 0;
}

//+------------------------------------------------------------------+
//| Check if market conditions allow trading                           |
//+------------------------------------------------------------------+
bool CanTrade(const SMarketState &state) {
    // Check spread
    double currentSpread = MarketInfo(Symbol(), MODE_SPREAD);
    if(currentSpread < MIN_SPREAD_POINTS || currentSpread > MAX_SPREAD_POINTS) 
        return false;
    
    // Check if within trading hours
    if(!IsWithinTradingHours()) 
        return false;
    
    // Check risk metrics
    SRiskMetrics metrics;
    CalcRiskMetrics(metrics);
    
    if(metrics.dailyDrawdown > MAX_DAILY_DRAWDOWN ||
       metrics.maxDrawdown > MAX_TOTAL_DRAWDOWN ||
       metrics.consecutiveLosses >= MAX_CONSECUTIVE_LOSSES ||
       (metrics.profitFactor > 0 && metrics.profitFactor < MIN_PROFIT_FACTOR))
        return false;
    
    // Check total positions
    int totalPositions = 0;
    for(int i = 0; i < OrdersTotal(); i++) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if(OrderMagicNumber() == EA_MAGIC) 
                totalPositions++;
        }
    }
    
    if(totalPositions >= MAX_POSITIONS) 
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Update trailing stops for open positions                           |
//+------------------------------------------------------------------+
void UpdateTrailingStops() {
    for(int i = 0; i < OrdersTotal(); i++) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if(OrderMagicNumber() == EA_MAGIC) {
                double stopLoss = OrderStopLoss();
                double openPrice = OrderOpenPrice();
                int type = OrderType();
                
                if(type == OP_BUY) {
                    double newStop = Bid - TRAIL_STEP_POINTS * Point;
                    if(Bid - openPrice > TRAIL_START_POINTS * Point && 
                       (stopLoss == 0 || newStop > stopLoss + Point)) {
                        OrderModify(OrderTicket(), openPrice, newStop, 
                                  OrderTakeProfit(), 0, clrNONE);
                    }
                }
                else if(type == OP_SELL) {
                    double newStop = Ask + TRAIL_STEP_POINTS * Point;
                    if(openPrice - Ask > TRAIL_START_POINTS * Point && 
                       (stopLoss == 0 || newStop < stopLoss - Point)) {
                        OrderModify(OrderTicket(), openPrice, newStop, 
                                  OrderTakeProfit(), 0, clrNONE);
                    }
                }
            }
        }
    }
} 