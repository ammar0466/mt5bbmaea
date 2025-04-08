//+------------------------------------------------------------------+
//|                                                           BBMA.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// Input Parameters
input group "Moving Averages"
input int    MA5_Period = 5;           // MA 5 Period
input int    MA10_Period = 10;         // MA 10 Period
input int    EMA50_Period = 50;        // EMA 50 Period
input ENUM_MA_METHOD MA_Method = MODE_SMA;  // Moving Average Method
input ENUM_APPLIED_PRICE MA_Price = PRICE_CLOSE;  // Applied Price

input group "Bollinger Bands"
input int    BB_Period = 20;           // Bollinger Bands Period
input double BB_Deviation = 2.0;       // Bollinger Bands Deviation

input group "Money Management"
input double RiskPercent = 1.0;        // Risk per trade (%)
input double MaxDailyDrawdown = 3.0;   // Maximum Daily Drawdown (%)
input double MaxTotalDrawdown = 10.0;  // Maximum Total Drawdown (%)
input int    MaxLossStreak = 3;        // Maximum Consecutive Losses
input int    PauseHours = 24;          // Pause Hours After Max Losses
input bool   UseCompounding = false;   // Use Compounding
input double CompoundMultiplier = 1.5;  // Compound Multiplier After Profit

input group "News Filter"
input bool   UseNewsFilter = true;     // Filter High Impact News
input int    NewsMinutesBefore = 30;   // Minutes Before News
input int    NewsMinutesAfter = 30;    // Minutes After News

// Additional input parameters
input group "Trading Parameters"
input double MinProfitPips = 20;       // Minimum Profit in Pips
input double MaxSpreadPips = 30;       // Maximum Spread in Pips
input bool   UseTrailingStop = true;   // Use Trailing Stop
input int    TrailingStop = 50;        // Trailing Stop in Pips
input int    TrailingStep = 10;        // Trailing Step in Pips
input bool   UseBreakEven = true;      // Use Break Even
input int    BreakEvenPips = 20;       // Break Even Pips

// Additional input parameters for advanced features
input group "Advanced Features"
input bool   UseVolatilityFilter = true;    // Filter by Volatility
input int    VolatilityPeriod = 14;         // Volatility Period
input double MaxVolatility = 2.0;           // Maximum Volatility (ATR multiplier)
input bool   UseTrendFilter = true;         // Use Trend Filter
input int    TrendPeriod = 200;             // Trend Period
input bool   UseTimeFilter = true;          // Use Time Filter
input int    StartHour = 2;                 // Trading Start Hour
input int    EndHour = 21;                  // Trading End Hour
input bool   UseFridayFilter = true;        // Avoid Friday Trading
input int    FridayEndHour = 20;            // Friday End Hour

// Global Variables
int ma5_high_handle;
int ma10_high_handle;
int ma5_low_handle;
int ma10_low_handle;
int ema50_handle;
int bb_handle;

double ma5_high[], ma10_high[], ma5_low[], ma10_low[], ema50[];
double bb_upper[], bb_lower[], bb_middle[];

int consecutive_losses = 0;
datetime last_trade_time = 0;
double initial_balance = 0;
double max_balance = 0;
double daily_start_balance = 0;

// Trading state variables
int last_trade_type = 0;  // 1 for buy, -1 for sell, 0 for no trade
double last_trade_price = 0;
datetime last_news_check = 0;

// News filter structure
struct NewsEvent
{
    datetime time;
    string currency;
    int impact;
    string event;
};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialize indicators
    ma5_high_handle = iMA(_Symbol, PERIOD_CURRENT, MA5_Period, 0, MA_Method, PRICE_HIGH);
    ma10_high_handle = iMA(_Symbol, PERIOD_CURRENT, MA10_Period, 0, MA_Method, PRICE_HIGH);
    ma5_low_handle = iMA(_Symbol, PERIOD_CURRENT, MA5_Period, 0, MA_Method, PRICE_LOW);
    ma10_low_handle = iMA(_Symbol, PERIOD_CURRENT, MA10_Period, 0, MA_Method, PRICE_LOW);
    ema50_handle = iMA(_Symbol, PERIOD_CURRENT, EMA50_Period, 0, MODE_EMA, MA_Price);
    bb_handle = iBands(_Symbol, PERIOD_CURRENT, BB_Period, 0, BB_Deviation, PRICE_CLOSE);

    if(ma5_high_handle == INVALID_HANDLE || ma10_high_handle == INVALID_HANDLE || 
       ma5_low_handle == INVALID_HANDLE || ma10_low_handle == INVALID_HANDLE || 
       ema50_handle == INVALID_HANDLE || bb_handle == INVALID_HANDLE)
    {
        Print("Error creating indicators");
        return(INIT_FAILED);
    }

    // Initialize arrays
    ArraySetAsSeries(ma5_high, true);
    ArraySetAsSeries(ma10_high, true);
    ArraySetAsSeries(ma5_low, true);
    ArraySetAsSeries(ma10_low, true);
    ArraySetAsSeries(ema50, true);
    ArraySetAsSeries(bb_upper, true);
    ArraySetAsSeries(bb_lower, true);
    ArraySetAsSeries(bb_middle, true);

    // Initialize balance tracking
    initial_balance = AccountInfoDouble(ACCOUNT_BALANCE);
    max_balance = initial_balance;
    daily_start_balance = initial_balance;

    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Release indicator handles
    IndicatorRelease(ma5_high_handle);
    IndicatorRelease(ma10_high_handle);
    IndicatorRelease(ma5_low_handle);
    IndicatorRelease(ma10_low_handle);
    IndicatorRelease(ema50_handle);
    IndicatorRelease(bb_handle);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Update indicator values
    if(!UpdateIndicators()) return;

    // Check trading conditions
    if(!CheckTradingConditions()) return;

    // Check for entry signals
    CheckEntrySignals();
}

//+------------------------------------------------------------------+
//| Update indicator values                                          |
//+------------------------------------------------------------------+
bool UpdateIndicators()
{
    if(CopyBuffer(ma5_high_handle, 0, 0, 3, ma5_high) <= 0) return false;
    if(CopyBuffer(ma10_high_handle, 0, 0, 3, ma10_high) <= 0) return false;
    if(CopyBuffer(ma5_low_handle, 0, 0, 3, ma5_low) <= 0) return false;
    if(CopyBuffer(ma10_low_handle, 0, 0, 3, ma10_low) <= 0) return false;
    if(CopyBuffer(ema50_handle, 0, 0, 3, ema50) <= 0) return false;
    if(CopyBuffer(bb_handle, 1, 0, 3, bb_upper) <= 0) return false;
    if(CopyBuffer(bb_handle, 2, 0, 3, bb_lower) <= 0) return false;
    if(CopyBuffer(bb_handle, 0, 0, 3, bb_middle) <= 0) return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Check trading conditions                                         |
//+------------------------------------------------------------------+
bool CheckTradingConditions()
{
    // Check if we're in pause period after losses
    if(consecutive_losses >= MaxLossStreak)
    {
        if(TimeCurrent() - last_trade_time < PauseHours * 3600)
            return false;
        consecutive_losses = 0;
    }

    // Check daily drawdown
    double current_balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double daily_drawdown = (daily_start_balance - current_balance) / daily_start_balance * 100;
    if(daily_drawdown >= MaxDailyDrawdown)
        return false;

    // Check total drawdown
    double total_drawdown = (max_balance - current_balance) / max_balance * 100;
    if(total_drawdown >= MaxTotalDrawdown)
        return false;

    // Check for high impact news if enabled
    if(UseNewsFilter && IsHighImpactNews())
        return false;

    return true;
}

//+------------------------------------------------------------------+
//| Check for entry signals                                          |
//+------------------------------------------------------------------+
void CheckEntrySignals()
{
    if(!CanOpenNewPosition()) return;
    
    // Get current price data
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    if(CopyRates(_Symbol, PERIOD_CURRENT, 0, 3, rates) <= 0) return;
    
    double current_price = rates[0].close;
    double current_spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) * _Point;
    
    // Check spread
    if(current_spread > MaxSpreadPips * _Point) return;
    
    // Trading logic using BB and MA
    bool buy_signal = false;
    bool sell_signal = false;
    
    // Buy Signal Conditions:
    // 1. Price below lower BB
    // 2. MA5 low crosses above MA10 low
    // 3. Price above EMA50 (trend confirmation)
    if(current_price < bb_lower[0] &&
       ma5_low[1] < ma10_low[1] && ma5_low[0] > ma10_low[0] &&
       current_price > ema50[0])
    {
        buy_signal = true;
    }
    
    // Sell Signal Conditions:
    // 1. Price above upper BB
    // 2. MA5 high crosses below MA10 high
    // 3. Price below EMA50 (trend confirmation)
    if(current_price > bb_upper[0] &&
       ma5_high[1] > ma10_high[1] && ma5_high[0] < ma10_high[0] &&
       current_price < ema50[0])
    {
        sell_signal = true;
    }
    
    // Execute trades
    if(buy_signal && last_trade_type <= 0)
    {
        OpenPosition(ORDER_TYPE_BUY);
    }
    else if(sell_signal && last_trade_type >= 0)
    {
        OpenPosition(ORDER_TYPE_SELL);
    }
    
    // Manage existing positions
    ManagePositions();
}

//+------------------------------------------------------------------+
//| Check if we can open a new position                             |
//+------------------------------------------------------------------+
bool CanOpenNewPosition()
{
    // Check if we already have a position
    if(PositionsTotal() > 0) return false;
    
    // Check all filters
    if(!CheckTime()) return false;
    if(!CheckVolatility()) return false;
    if(!CheckTrend()) return false;
    if(UseNewsFilter && IsHighImpactNews()) return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Open a new position                                             |
//+------------------------------------------------------------------+
void OpenPosition(ENUM_ORDER_TYPE order_type)
{
    double lot_size = CalculateLotSize();
    if(lot_size <= 0) return;
    
    double price = (order_type == ORDER_TYPE_BUY) ? 
                   SymbolInfoDouble(_Symbol, SYMBOL_ASK) : 
                   SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    double sl = CalculateStopLoss(order_type, price);
    double tp = CalculateTakeProfit(order_type, price);
    
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = lot_size;
    request.type = order_type;
    request.price = price;
    request.sl = sl;
    request.tp = tp;
    request.deviation = 10;
    request.magic = 123456;
    request.comment = "BBMA EA";
    request.type_filling = ORDER_FILLING_FOK;
    
    if(!OrderSend(request, result))
    {
        Print("OrderSend error: ", GetLastError());
        return;
    }
    
    if(result.retcode == TRADE_RETCODE_DONE)
    {
        last_trade_type = (order_type == ORDER_TYPE_BUY) ? 1 : -1;
        last_trade_price = price;
        last_trade_time = TimeCurrent();
    }
}

//+------------------------------------------------------------------+
//| Calculate position size based on risk management                 |
//+------------------------------------------------------------------+
double CalculateLotSize()
{
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double risk_amount = balance * RiskPercent / 100;
    
    // Apply compounding if enabled
    if(UseCompounding && last_trade_type != 0)
    {
        double last_profit = AccountInfoDouble(ACCOUNT_BALANCE) - initial_balance;
        if(last_profit > 0)
        {
            risk_amount *= CompoundMultiplier;
        }
    }
    
    double tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    double tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double point_value = tick_value / tick_size;
    
    double stop_loss_pips = 50; // Default stop loss in pips
    double risk_per_pip = point_value * stop_loss_pips;
    
    double lot_size = NormalizeDouble(risk_amount / risk_per_pip, 2);
    double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    
    lot_size = MathMax(min_lot, MathMin(max_lot, lot_size));
    
    return lot_size;
}

//+------------------------------------------------------------------+
//| Calculate Stop Loss level                                        |
//+------------------------------------------------------------------+
double CalculateStopLoss(ENUM_ORDER_TYPE order_type, double price)
{
    int atr_handle = iATR(_Symbol, PERIOD_CURRENT, 14);
    double atr[];
    ArraySetAsSeries(atr, true);
    
    if(CopyBuffer(atr_handle, 0, 0, 1, atr) <= 0) 
        return 0;
        
    double stop_distance = atr[0] * 1.5; // 1.5 ATR for stop loss
    
    if(order_type == ORDER_TYPE_BUY)
        return price - stop_distance;
    else
        return price + stop_distance;
}

//+------------------------------------------------------------------+
//| Calculate Take Profit level                                      |
//+------------------------------------------------------------------+
double CalculateTakeProfit(ENUM_ORDER_TYPE order_type, double price)
{
    int atr_handle = iATR(_Symbol, PERIOD_CURRENT, 14);
    double atr[];
    ArraySetAsSeries(atr, true);
    
    if(CopyBuffer(atr_handle, 0, 0, 1, atr) <= 0) 
        return 0;
        
    double tp_distance = atr[0] * 3.0; // 3 ATR for take profit
    
    if(order_type == ORDER_TYPE_BUY)
        return price + tp_distance;
    else
        return price - tp_distance;
}

//+------------------------------------------------------------------+
//| Manage existing positions                                        |
//+------------------------------------------------------------------+
void ManagePositions()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket <= 0) continue;
        
        if(!PositionSelectByTicket(ticket)) continue;
        
        if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
        
        double position_sl = PositionGetDouble(POSITION_SL);
        double position_tp = PositionGetDouble(POSITION_TP);
        double position_price = PositionGetDouble(POSITION_PRICE_OPEN);
        double current_price = PositionGetDouble(POSITION_PRICE_CURRENT);
        ENUM_POSITION_TYPE position_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        
        // Update trailing stop
        if(UseTrailingStop)
        {
            UpdateTrailingStop(ticket, position_type, current_price, position_sl);
        }
        
        // Move to break even
        if(UseBreakEven && position_sl != position_price)
        {
            UpdateBreakEven(ticket, position_type, current_price, position_price);
        }
    }
}

//+------------------------------------------------------------------+
//| Update trailing stop for a position                              |
//+------------------------------------------------------------------+
void UpdateTrailingStop(ulong ticket, ENUM_POSITION_TYPE pos_type, double current_price, double current_sl)
{
    double new_sl = 0;
    double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    
    if(pos_type == POSITION_TYPE_BUY)
    {
        new_sl = current_price - TrailingStop * point;
        if(new_sl > current_sl + TrailingStep * point)
        {
            ModifyPosition(ticket, new_sl, 0);
        }
    }
    else if(pos_type == POSITION_TYPE_SELL)
    {
        new_sl = current_price + TrailingStop * point;
        if(new_sl < current_sl - TrailingStep * point || current_sl == 0)
        {
            ModifyPosition(ticket, new_sl, 0);
        }
    }
}

//+------------------------------------------------------------------+
//| Update break even for a position                                 |
//+------------------------------------------------------------------+
void UpdateBreakEven(ulong ticket, ENUM_POSITION_TYPE pos_type, double current_price, double open_price)
{
    double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    double profit_pips = 0;
    
    if(pos_type == POSITION_TYPE_BUY)
    {
        profit_pips = (current_price - open_price) / point;
        if(profit_pips >= BreakEvenPips)
        {
            ModifyPosition(ticket, open_price + 5 * point, 0);
        }
    }
    else if(pos_type == POSITION_TYPE_SELL)
    {
        profit_pips = (open_price - current_price) / point;
        if(profit_pips >= BreakEvenPips)
        {
            ModifyPosition(ticket, open_price - 5 * point, 0);
        }
    }
}

//+------------------------------------------------------------------+
//| Modify position's SL and TP                                      |
//+------------------------------------------------------------------+
bool ModifyPosition(ulong ticket, double sl, double tp)
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_SLTP;
    request.position = ticket;
    request.symbol = _Symbol;
    request.sl = sl;
    request.tp = tp;
    
    return OrderSend(request, result);
}

//+------------------------------------------------------------------+
//| Check for high impact news                                        |
//+------------------------------------------------------------------+
bool IsHighImpactNews()
{
    if(!UseNewsFilter) return false;
    
    // Update news check every 5 minutes
    if(TimeCurrent() - last_news_check < 300) return false;
    last_news_check = TimeCurrent();
    
    // Get current time
    datetime current_time = TimeCurrent();
    MqlDateTime time_struct;
    TimeToStruct(current_time, time_struct);
    
    // Get currency from symbol
    string base_currency = StringSubstr(_Symbol, 0, 3);
    string quote_currency = StringSubstr(_Symbol, 3, 3);
    
    // Check for high impact news
    // Note: In a real implementation, you would need to connect to a news API
    // For now, we'll use a simplified check based on time
    if(time_struct.hour == 8 || time_struct.hour == 12 || time_struct.hour == 14)
    {
        return true; // Assume high impact news during these hours
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check volatility conditions                                       |
//+------------------------------------------------------------------+
bool CheckVolatility()
{
    if(!UseVolatilityFilter) return true;
    
    double atr[];
    ArraySetAsSeries(atr, true);
    int atr_handle = iATR(_Symbol, PERIOD_CURRENT, VolatilityPeriod);
    
    if(CopyBuffer(atr_handle, 0, 0, 1, atr) <= 0) 
    {
        Print("Error getting ATR data");
        return false;
    }
    
    double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double volatility = atr[0] / current_price * 100;
    
    return volatility <= MaxVolatility;
}

//+------------------------------------------------------------------+
//| Check trend conditions                                            |
//+------------------------------------------------------------------+
bool CheckTrend()
{
    if(!UseTrendFilter) return true;
    
    double ma[];
    ArraySetAsSeries(ma, true);
    int ma_handle = iMA(_Symbol, PERIOD_CURRENT, TrendPeriod, 0, MODE_SMA, PRICE_CLOSE);
    
    if(CopyBuffer(ma_handle, 0, 0, 2, ma) <= 0) return false;
    
    double current_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    // Trend is up if price is above MA and MA is rising
    bool uptrend = current_price > ma[0] && ma[0] > ma[1];
    // Trend is down if price is below MA and MA is falling
    bool downtrend = current_price < ma[0] && ma[0] < ma[1];
    
    return uptrend || downtrend;
}

//+------------------------------------------------------------------+
//| Check time conditions                                             |
//+------------------------------------------------------------------+
bool CheckTime()
{
    if(!UseTimeFilter) return true;
    
    MqlDateTime time_struct;
    TimeToStruct(TimeCurrent(), time_struct);
    
    // Check trading hours
    if(time_struct.hour < StartHour || time_struct.hour >= EndHour)
        return false;
        
    // Check Friday filter
    if(UseFridayFilter && time_struct.day_of_week == FRIDAY && time_struct.hour >= FridayEndHour)
        return false;
        
    return true;
}
