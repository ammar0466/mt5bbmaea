//+------------------------------------------------------------------+
//|                                                      constants.mqh |
//+------------------------------------------------------------------+

// Bollinger Bands parameters
#define BB_PERIOD 20
#define BB_DEVIATION 2.0
#define BB_SHIFT 0
#define BB_PRICE PRICE_CLOSE

// Moving Average parameters
#define MA_FAST_PERIOD 10
#define MA_MEDIUM_PERIOD 20
#define MA_SLOW_PERIOD 50
#define MA_METHOD MODE_SMA
#define MA_PRICE PRICE_CLOSE
#define MA_SHIFT 0

// ATR parameters
#define ATR_PERIOD 14

// Risk management parameters
#define DEFAULT_RISK_PERCENT 1.0
#define MAX_DAILY_DRAWDOWN 2.0
#define MAX_TOTAL_DRAWDOWN 5.0
#define MAX_CONSECUTIVE_LOSSES 3
#define MIN_PROFIT_FACTOR 1.5

// Trade execution parameters
#define DEFAULT_SLIPPAGE 3
#define MIN_SPREAD_POINTS 10
#define MAX_SPREAD_POINTS 10

// Time filters
#define TRADING_START_HOUR 2
#define TRADING_END_HOUR 22
#define MONDAY_START_HOUR 2     // 2:00 Monday
#define FRIDAY_END_HOUR 22      // 22:00 Friday

// Position management
#define MAX_POSITIONS 3
#define MIN_DISTANCE_POINTS 20   // Minimum distance between positions
#define TRAIL_START_POINTS 50    // Points in profit to start trailing
#define TRAIL_STEP_POINTS 10     // Trailing step size

// Magic number for trade identification
#define EA_MAGIC 20240315

// Trading Hours (Server Time)
#define TRADING_START_HOUR_SERVER 2     // Trading session start (2:00)
#define TRADING_END_HOUR_SERVER 22    // Trading session end (22:00)

// Trade Parameters
#define TP_ATR_MULTIPLIER 2.0   // Take profit as multiplier of ATR
#define SL_ATR_MULTIPLIER 1.0   // Stop loss as multiplier of ATR
#define TRAILING_START_ATR 1.5   // Start trailing after price moves this many ATR
#define TRAILING_STEP_ATR 0.5   // Trail by this fraction of ATR

// Volatility Thresholds
#define HIGH_VOLATILITY_ATR 0.0015 // High volatility threshold (relative to price)
#define LOW_VOLATILITY_ATR 0.0005 // Low volatility threshold (relative to price) 