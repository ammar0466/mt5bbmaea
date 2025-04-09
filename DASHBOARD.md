# BBMA EA Dashboard

## Input Parameters

### Moving Averages
| Parameter | Value | Description |
|-----------|-------|-------------|
| MA5_Period | 5 | MA 5 Period |
| MA10_Period | 10 | MA 10 Period |
| EMA50_Period | 50 | EMA 50 Period |
| MA_Method | MODE_SMA | Moving Average Method |
| MA_Price | PRICE_CLOSE | Applied Price |

### Bollinger Bands
| Parameter | Value | Description |
|-----------|-------|-------------|
| BB_Period | 20 | Bollinger Bands Period |
| BB_Deviation | 2.0 | Bollinger Bands Deviation |

### Money Management
| Parameter | Value | Description |
|-----------|-------|-------------|
| RiskPercent | 1.0 | Risk per trade (%) |
| MaxDailyDrawdown | 3.0 | Maximum Daily Drawdown (%) |
| MaxTotalDrawdown | 10.0 | Maximum Total Drawdown (%) |
| MaxLossStreak | 3 | Maximum Consecutive Losses |
| PauseHours | 24 | Pause Hours After Max Losses |
| UseCompounding | false | Use Compounding |
| CompoundMultiplier | 1.5 | Compound Multiplier After Profit |

### News Filter
| Parameter | Value | Description |
|-----------|-------|-------------|
| UseNewsFilter | true | Filter High Impact News |
| NewsMinutesBefore | 30 | Minutes Before News |
| NewsMinutesAfter | 30 | Minutes After News |

### Trading Parameters
| Parameter | Value | Description |
|-----------|-------|-------------|
| MinProfitPips | 20 | Minimum Profit in Pips |
| MaxSpreadPips | 30 | Maximum Spread in Pips |
| UseTrailingStop | true | Use Trailing Stop |
| TrailingStop | 50 | Trailing Stop in Pips |
| TrailingStep | 10 | Trailing Step in Pips |
| UseBreakEven | true | Use Break Even |
| BreakEvenPips | 20 | Break Even Pips |

### Advanced Features
| Parameter | Value | Description |
|-----------|-------|-------------|
| UseVolatilityFilter | true | Filter by Volatility |
| VolatilityPeriod | 14 | Volatility Period |
| MaxVolatility | 2.0 | Maximum Volatility (ATR multiplier) |
| UseTrendFilter | true | Use Trend Filter |
| TrendPeriod | 200 | Trend Period |
| UseTimeFilter | true | Use Time Filter |
| StartHour | 2 | Trading Start Hour |
| EndHour | 21 | Trading End Hour |
| UseFridayFilter | true | Avoid Friday Trading |
| FridayEndHour | 20 | Friday End Hour |

## Current Status

### Account Information
- **Balance**: $10,000.00
- **Equity**: $10,150.00
- **Margin**: $500.00
- **Free Margin**: $9,650.00
- **Margin Level**: 2030.00%

### Trading Statistics
- **Total Trades**: 25
- **Winning Trades**: 18
- **Losing Trades**: 7
- **Win Rate**: 72.00%
- **Profit Factor**: 2.15
- **Average Profit**: $45.20
- **Average Loss**: -$32.10
- **Largest Drawdown**: 2.30%
- **Current Drawdown**: 0.50%

### Current Positions
| Symbol | Type | Volume | Open Price | Current Price | SL | TP | Profit |
|--------|------|--------|------------|---------------|----|----|--------|
| EURUSD | Buy | 0.10 | 1.0850 | 1.0875 | 1.0800 | 1.0950 | +$25.00 |
| GBPUSD | Sell | 0.05 | 1.2650 | 1.2625 | 1.2700 | 1.2550 | +$12.50 |

### Market State
- **Trend**: Uptrend
- **Volatility**: Medium
- **BB Position**: Price near upper band
- **MA Alignment**: Bullish (MA5 > MA10 > EMA50)

### Risk Metrics
- **Daily Drawdown**: 0.50%
- **Max Drawdown**: 2.30%
- **Consecutive Losses**: 0
- **Profit Factor**: 2.15
- **Equity Curve**: ↗️ Rising

## Recent Trades
| Time | Symbol | Type | Volume | Open Price | Close Price | Profit |
|------|--------|------|--------|------------|-------------|--------|
| 10:15 | EURUSD | Buy | 0.10 | 1.0825 | 1.0850 | +$25.00 |
| 09:45 | GBPUSD | Sell | 0.05 | 1.2675 | 1.2650 | +$12.50 |
| 09:00 | EURUSD | Buy | 0.10 | 1.0800 | 1.0825 | +$25.00 |
| 08:30 | GBPUSD | Sell | 0.05 | 1.2700 | 1.2675 | +$12.50 |
| 08:00 | EURUSD | Buy | 0.10 | 1.0775 | 1.0800 | +$25.00 |

## System Messages
- [10:20] Position opened: EURUSD Buy 0.10 at 1.0850
- [10:15] Position closed: EURUSD Buy 0.10 at 1.0850 (Profit: +$25.00)
- [09:50] Position opened: GBPUSD Sell 0.05 at 1.2650
- [09:45] Position closed: GBPUSD Sell 0.05 at 1.2650 (Profit: +$12.50)
- [09:05] Position opened: EURUSD Buy 0.10 at 1.0825 