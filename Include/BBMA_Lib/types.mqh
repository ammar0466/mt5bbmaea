//+------------------------------------------------------------------+
//|                                                          types.mqh |
//+------------------------------------------------------------------+

// Signal types for trading decisions
enum ENUM_SIGNAL_TYPE
{
    SIGNAL_NONE,   // No trading signal
    SIGNAL_BUY,    // Buy signal
    SIGNAL_SELL    // Sell signal
};

//+------------------------------------------------------------------+
//| Market state structure                                             |
//+------------------------------------------------------------------+
struct SMarketState {
    // Bollinger Bands
    double bbUpper;
    double bbMiddle;
    double bbLower;
    
    // Moving Averages
    double maFast;
    double maMedium;
    double maSlow;
    
    // ATR
    double atr;
    
    // Price data
    double close;
    double high;
    double low;
    double bid;
    double ask;
    double spread;
    
    // Trend state
    bool isUptrend;
    bool isDowntrend;
    bool isSideways;
    
    // Volatility state
    bool isHighVolatility;
    bool isLowVolatility;
};

//+------------------------------------------------------------------+
//| Risk metrics structure                                             |
//+------------------------------------------------------------------+
struct SRiskMetrics {
    double dailyDrawdown;
    double maxDrawdown;
    int consecutiveLosses;
    double profitFactor;
    double equity;
    double balance;
};

//+------------------------------------------------------------------+
//| Trade signal structure                                             |
//+------------------------------------------------------------------+
struct STradeSignal {
    bool isValid;
    int direction;  // 1 for buy, -1 for sell, 0 for no trade
    double entryPrice;
    double stopLoss;
    double takeProfit;
    double riskPercent;
    string comment;
};

// Trade parameters structure
struct STradeParams
{
    double lot_size;      // Calculated lot size
    double stop_loss;     // Stop loss in points
    double take_profit;   // Take profit in points
    double risk_percent;  // Risk percentage per trade
    int slippage;        // Maximum allowed slippage
}; 