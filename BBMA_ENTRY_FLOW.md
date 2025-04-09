# BBMA OA Entry Flow Diagram

## Multi-Timeframe Entry Validation Process

```
┌─────────────────────────────────────────────────────────────────┐
│                     FIRST TIMEFRAME (H4+)                        │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │   Reentry   │    │   Extreme   │    │    MHV      │         │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘         │
│         │                  │                  │                 │
└─────────┼──────────────────┼──────────────────┼─────────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SECOND TIMEFRAME (H1)                        │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │   Reentry   │    │   Extreme   │    │    MHV      │         │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘         │
│         │                  │                  │                 │
└─────────┼──────────────────┼──────────────────┼─────────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    THIRD TIMEFRAME (M15)                        │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    FULL STRUCTURE                       │   │
│  │                                                         │   │
│  │  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │   │
│  │  │  Bollinger  │    │  Moving     │    │    EMA 50   │ │   │
│  │  │    Bands    │    │  Averages   │    │             │ │   │
│  │  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘ │   │
│  │         │                  │                  │         │   │
│  └─────────┼──────────────────┼──────────────────┼─────────┘   │
│            │                  │                  │             │
└────────────┼──────────────────┼──────────────────┼─────────────┘
             │                  │                  │
             ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      ENTRY VALIDATION                            │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │  Structure  │    │  Momentum   │    │  Candlestick │         │
│  │  Quality    │◄───┤  Check      │◄───┤  Patterns    │         │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘         │
│         │                  │                  │                 │
└─────────┼──────────────────┼──────────────────┼─────────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      ENTRY DECISION                              │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │  Risk       │    │  Position   │    │  Stop Loss  │         │
│  │  Management │◄───┤  Sizing     │◄───┤  & Take     │         │
│  └──────┬──────┘    └──────┬──────┘    │  Profit     │         │
│         │                  │           └──────┬──────┘         │
└─────────┼──────────────────┼──────────────────┼─────────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      EXECUTE TRADE                               │
└─────────────────────────────────────────────────────────────────┘
```

## Entry Codes and Validation

### R-E-E (Reentry | Extreme | Extreme)
```
H4+ ──► Reentry ──┐
                  │
H1 ──► Extreme ───┼─► M15 ──► Extreme with Full Structure ──► Entry
                  │
M15 ──► Full Structure ──┘
```

### R-E-M (Reentry | Extreme | MHV)
```
H4+ ──► Reentry ──┐
                  │
H1 ──► Extreme ───┼─► M15 ──► MHV with Full Structure ──► Entry
                  │
M15 ──► Full Structure ──┘
```

### R-R-E (Reentry | Reentry | Extreme)
```
H4+ ──► Reentry ──┐
                  │
H1 ──► Reentry ───┼─► M15 ──► Extreme with Full Structure ──► Entry
                  │
M15 ──► Full Structure ──┘
```

## Full Structure Components

```
┌─────────────────────────────────────────────────────────┐
│                    FULL STRUCTURE                       │
│                                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │  Bollinger  │    │  Moving     │    │    EMA 50   │ │
│  │    Bands    │    │  Averages   │    │             │ │
│  │             │    │  (MAHILOW)  │    │             │ │
│  │  ┌─────┐    │    │  ┌─────┐   │    │  ┌─────┐    │ │
│  │  │Upper│    │    │  │ MA5 │   │    │  │ EMA │    │ │
│  │  └─────┘    │    │  └─────┘   │    │  │ 50  │    │ │
│  │  ┌─────┐    │    │  ┌─────┐   │    │  └─────┘    │ │
│  │  │Middle│   │    │  │ MA10│   │    │             │ │
│  │  └─────┘    │    │  └─────┘   │    │             │ │
│  │  ┌─────┐    │    │             │    │             │ │
│  │  │Lower│    │    │             │    │             │ │
│  │  └─────┘    │    │             │    │             │ │
│  └─────────────┘    └─────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Entry Validation Checklist

1. **First Timeframe (H4+)**
   - [ ] Primary structure identified (Reentry, Extreme, or MHV)
   - [ ] Clear trend direction
   - [ ] Previous structure before current setup

2. **Second Timeframe (H1)**
   - [ ] Confirms first timeframe structure
   - [ ] Extreme formation or MHV present
   - [ ] EMA 100 visible for stop loss reference

3. **Third Timeframe (M15)**
   - [ ] Full Structure present
   - [ ] All components properly aligned
   - [ ] Candlestick patterns confirm direction
   - [ ] Momentum check passed

4. **Final Validation**
   - [ ] Risk management parameters set
   - [ ] Position size calculated
   - [ ] Stop loss and take profit levels determined
   - [ ] Entry timing optimized 