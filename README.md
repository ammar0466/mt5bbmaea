# BBMA EA - Bollinger Bands & Moving Average Expert Advisor

## Dashboard Overview

```
+------------------------------------------------------------------+
|                           BBMA EA Dashboard                        |
+------------------------------------------------------------------+
| Account Info:                                                      |
|   Balance:     $10,000.00                                         |
|   Equity:      $10,150.00                                         |
|   Profit:      +$150.00                                           |
|   Drawdown:    1.5%                                               |
+------------------------------------------------------------------+
| Risk Metrics:                                                      |
|   Daily DD:    1.2%                                               |
|   Max DD:      2.5%                                               |
|   Consecutive Losses: 0                                           |
|   Profit Factor: 1.8                                              |
+------------------------------------------------------------------+
| Market State:                                                      |
|   Trend:       Uptrend                                            |
|   Volatility:  Medium                                             |
|   Spread:      1.2 pips                                           |
+------------------------------------------------------------------+
| Open Positions:                                                    |
|   #1: EURUSD Buy  1.0 lots  Entry: 1.0850  SL: 1.0800  TP: 1.0950 |
|   #2: EURUSD Sell 0.5 lots  Entry: 1.0870  SL: 1.0920  TP: 1.0770 |
+------------------------------------------------------------------+
| Trading Status:                                                    |
|   Status:      Active                                             |
|   Last Trade:  2024-03-15 14:30:45                               |
|   Next Check:  2024-03-15 14:31:00                               |
+------------------------------------------------------------------+
```

## Input Parameters

### Moving Averages
```
+------------------------------------------------------------------+
| Moving Averages Settings                                           |
+------------------------------------------------------------------+
| MA5 Period:    5                                                  |
| MA10 Period:   10                                                 |
| EMA50 Period:  50                                                 |
| MA Method:     Simple Moving Average                             |
| Applied Price: Close                                              |
+------------------------------------------------------------------+
```

### Bollinger Bands
```
+------------------------------------------------------------------+
| Bollinger Bands Settings                                          |
+------------------------------------------------------------------+
| BB Period:     20                                                 |
| BB Deviation:  2.0                                                |
+------------------------------------------------------------------+
```

### Money Management
```
+------------------------------------------------------------------+
| Money Management Settings                                         |
+------------------------------------------------------------------+
| Risk per Trade:    1.0%                                          |
| Max Daily DD:      2.0%                                          |
| Max Total DD:      5.0%                                          |
| Max Loss Streak:   3                                             |
| Pause Hours:       24                                            |
| Use Compounding:   No                                            |
| Compound Multiplier: 1.5                                         |
+------------------------------------------------------------------+
```

### Trading Parameters
```
+------------------------------------------------------------------+
| Trading Parameters                                                |
+------------------------------------------------------------------+
| Min Profit Pips:   20                                            |
| Max Spread Pips:   10                                            |
| Use Trailing Stop: Yes                                           |
| Trailing Stop:     50 pips                                       |
| Trailing Step:     10 pips                                       |
| Use Break Even:    Yes                                           |
| Break Even Pips:   20                                            |
+------------------------------------------------------------------+
```

### Advanced Features
```
+------------------------------------------------------------------+
| Advanced Features                                                 |
+------------------------------------------------------------------+
| Use Volatility Filter: Yes                                       |
| Volatility Period:   14                                          |
| Max Volatility:      2.0                                         |
| Use Trend Filter:    Yes                                         |
| Trend Period:        200                                         |
| Use Time Filter:     Yes                                         |
| Start Hour:          2                                           |
| End Hour:            22                                          |
| Use Friday Filter:   Yes                                         |
| Friday End Hour:     20                                          |
+------------------------------------------------------------------+
```

## Performance Metrics

```
+------------------------------------------------------------------+
| Performance Statistics                                             |
+------------------------------------------------------------------+
| Total Trades:       150                                          |
| Win Rate:           65%                                          |
| Profit Factor:      1.8                                          |
| Average Win:        $120                                         |
| Average Loss:       -$80                                         |
| Largest Win:        $350                                         |
| Largest Loss:       -$200                                        |
| Average Trade:      $45                                          |
| Max Drawdown:       2.5%                                         |
| Recovery Factor:    2.1                                          |
+------------------------------------------------------------------+
```

## Trade Signals

```
+------------------------------------------------------------------+
| Signal Generation                                                  |
+------------------------------------------------------------------+
| Buy Signal:                                                        |
|   - Price below lower BB                                          |
|   - MA5 low crosses above MA10 low                                |
|   - Price above EMA50 (trend confirmation)                        |
|                                                                   |
| Sell Signal:                                                      |
|   - Price above upper BB                                          |
|   - MA5 high crosses below MA10 high                              |
|   - Price below EMA50 (trend confirmation)                        |
+------------------------------------------------------------------+
```

## Risk Management Rules

```
+------------------------------------------------------------------+
| Risk Management Rules                                             |
+------------------------------------------------------------------+
| 1. Position Sizing:                                               |
|    - Risk 1% per trade                                           |
|    - Adjust for volatility using ATR                              |
|                                                                   |
| 2. Stop Loss:                                                     |
|    - 1.5 x ATR for initial stop                                   |
|    - Trailing stop after 50 pips profit                           |
|                                                                   |
| 3. Take Profit:                                                   |
|    - 3.0 x ATR for initial target                                 |
|    - Break even after 20 pips profit                              |
|                                                                   |
| 4. Risk Limits:                                                   |
|    - Max 2% daily drawdown                                        |
|    - Max 5% total drawdown                                        |
|    - Max 3 consecutive losses                                     |
|    - 24-hour pause after max losses                               |
+------------------------------------------------------------------+
```

## Features

- Combines Bollinger Bands and Multiple Moving Averages
- Advanced Money Management
- Multiple Risk Management Features
- News Filter
- Volatility Filter
- Trend Filter
- Time Filter
- Break Even Feature
- Trailing Stop
- Compounding Option

## Parameters

### Moving Averages
- MA 5 Period (High and Low)
- MA 10 Period (High and Low)
- EMA 50 Period

### Bollinger Bands
- Period: 20
- Deviation: 2.0

### Risk Management
- Risk per trade: 1%
- Daily drawdown limit: 3%
- Maximum drawdown: 10%
- Maximum consecutive losses: 3
- Pause duration: 24 hours

### Additional Features
- Break even level
- Trailing stop
- News filter
- Volatility filter
- Time filter
- Friday trading filter

## Installation

1. Copy the EA file to your MetaTrader 5 Experts folder
2. Restart MetaTrader 5 or refresh the Expert Advisors
3. The EA will appear in your Navigator window under Expert Advisors

## Usage

1. Drag the EA onto a chart
2. Configure the input parameters
3. Enable AutoTrading
4. Monitor the EA's performance

## Disclaimer

This Expert Advisor is for educational purposes only. Always test thoroughly on a demo account before using with real money. Past performance does not guarantee future results. 