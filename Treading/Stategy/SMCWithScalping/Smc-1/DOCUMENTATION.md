# SMC SCALPING MASTER PRO v8.5

**Sniper-Short + Backtest-Truth Edition**

A Pine Script v5 trading strategy for TradingView implementing Smart Money Concepts (SMC) for intraday forex scalping with multi-timeframe confluence, weighted scoring, adaptive risk management, and per-setup performance analytics.

---

## Table of Contents

1. [Overview](#overview)
2. [What's New in v8.5](#whats-new-in-v85)
3. [Quick Start](#quick-start)
4. [Strategy Logic](#strategy-logic)
5. [Sniper Setups (S1/S2/S3)](#sniper-setups)
6. [Order Block Doctrine (G2)](#order-block-doctrine)
7. [Weighted Scoring System](#weighted-scoring-system)
8. [Setup-Tag Taxonomy](#setup-tag-taxonomy)
9. [Two-Stage Entry](#two-stage-entry)
10. [Risk Management](#risk-management)
11. [Multi-Target Exit System](#multi-target-exit-system)
12. [Dashboard Reference](#dashboard-reference)
13. [Stats-by-Setup Table](#stats-by-setup-table)
14. [Input Reference](#input-reference)
15. [Tuning Per Symbol Class](#tuning-per-symbol-class)
16. [Troubleshooting](#troubleshooting)
17. [Known Limitations](#known-limitations)
18. [Version History](#version-history)

---

## Overview

This strategy combines:

- **SMC structure** — Break of Structure (BOS), Change of Character (CHoCH), institutional Order Blocks (OB), Fair Value Gaps (FVG)
- **Liquidity concepts** — Asian-range sweeps, Judas swings, EQH/EQL liquidity pools, PDH/PDL sweep-reclaims
- **Multi-timeframe (MTF) trend confluence** — 5 timeframes (TF1–TF5) using HTF EMA stack on each TF
- **Two-stage entry** — HTF setup confirmation, then LTF trigger candle
- **Adaptive risk** — RR ceiling and position size scale by setup grade (A+/A/B+/B/C/D)
- **Per-trade analytics** — MAE/MFE, R-multiple log, win-rate and expectancy broken down by setup tag

Target instruments: forex pairs on M1–M15 timeframes. Symbol-class detection automatically adjusts pip sizing for metals and crypto.

---

## What's New in v8.5

| ID | Feature | Description |
|----|---------|-------------|
| **G1** | Fast pivot SL anchor | SL anchored to fast `(3,3)` pivot for tight scalping stops. Fixes v8.4 issue where `(10,10)` pivot SL was up to 50 min stale on M5. |
| **G2** | Real institutional OB | Order block anchored to the **last opposite-color candle before BOS displacement**, with minimum displacement filter. v8.4 used engulf-misnamed OB (wrong candle). |
| **S1** | NY-on-Asian sweep | NY KZ pierces Asian H/L then reclaims back inside — classic ICT continuation setup. |
| **S2** | EQH/EQL liquidity grab | Multi-pivot equal-level cluster detection, grab trigger fires on wick beyond cluster + close back inside. |
| **S3** | PDH/PDL sweep-reclaim | Pierce prior-day extreme, close back inside — classic stop-hunt fade. |
| **A1** | MAE/MFE + R-multiple log | Per-trade analytics arrays tracking max adverse/favorable excursion in R-multiples plus setup tag. |
| **A2** | Stats-by-setup table | Win-rate, expectancy, profit factor, sum R per setup tag. Lets you cull setups with no edge. |
| **HTF hard gate** | Strict alignment | Blocks counter-trend entries via mandatory HTF alignment (configurable). |
| **MTF strict gate** | Optional 3+ TF align | Optional gate requiring `mtfScore ≥ 3` (i.e. 3 of 5 TFs agreeing). |

---

## Quick Start

1. Open TradingView and create a new Pine script
2. Paste contents of `smc_v8.5_fixed.pine`
3. Save and add to chart
4. Default settings target M5 EURUSD/GBPUSD. For other symbols see [Tuning Per Symbol Class](#tuning-per-symbol-class)
5. Open the strategy settings dialog and adjust:
   - **Account Size** → your actual broker account balance
   - **Risk %** → start with 0.5–1.0%
   - **Pip Value** → broker-specific (default `10` for $10/pip on standard lot)
   - **Day Filter** → enable/disable trading days
   - **Kill Zones** → adjust London/NY/Asian hours if your chart timezone differs from `Asia/Dhaka`

> ⚠️ **Timezone note:** Kill zone hours are interpreted against `Asia/Dhaka` (GMT+6). London KZ default `14–18` = 14:00–18:00 Dhaka = 08:00–12:00 UTC (London open + first half). NY KZ default `19–23` = 13:00–17:00 UTC (NY open + first half). Adjust if you want UTC or local hours.

---

## Strategy Logic

### Entry pipeline

```
┌──────────────────────────────────────────────────────────────┐
│  1. Compute scores (bullScore, bearScore) from confluence     │
│  2. Gate: htfBullSetupReady / htfBearSetupReady               │
│     ├─ Score ≥ minWeightedScore (default 12)                  │
│     ├─ Not in conflict                                        │
│     ├─ In kill zone                                           │
│     ├─ Not news window                                        │
│     ├─ Volatility OK (ATR within band)                        │
│     ├─ Risk OK (daily loss, consec losses, equity DD)         │
│     ├─ Day OK                                                 │
│     ├─ Spread OK                                              │
│     ├─ Cooldown elapsed                                       │
│     ├─ Not fresh session block (first 15 min)                 │
│     ├─ SL distance within [minSLpips, maxSLpips]              │
│     ├─ HTF gate (requireHTFAlign)                             │
│     └─ MTF gate (requireMTFAlign, optional)                   │
│  3. If two-stage entry:                                       │
│     a. Set pending signal on first gate pass                  │
│     b. Wait for LTF trigger candle (pin/engulf/strong body)   │
│     c. Re-validate gates at trigger bar                       │
│     d. Require zone retest if requireRetest=true              │
│  4. Fire strategy.entry with grade-scaled lot size            │
│  5. Place multi-target exits (X1/X2/X3) on entry bar          │
└──────────────────────────────────────────────────────────────┘
```

### Exit pipeline

```
┌──────────────────────────────────────────────────────────────┐
│  Entry: 3 exit orders placed                                  │
│    X1 = TP1 at 1R, qty_percent = tp1Pct (default 50%)         │
│    X2 = TP2 at 2R, qty_percent = tp2Pct (default 30%)         │
│    X3 = TP3 at gradeRR (1.5×–3×), remaining qty (default 20%) │
│                                                               │
│  On TP1 hit (intrabar price >= TP1):                          │
│    ├─ Move SL to BE (entryPrice)                              │
│    ├─ Re-issue X2 with absolute qty (no qty_percent reuse)    │
│    └─ Re-issue X3 with BE stop                                │
│                                                               │
│  After TP1, if useTrailing:                                   │
│    └─ Trail X3 SL by max(ATR×trailAtrMult, minTrailDistPips)  │
└──────────────────────────────────────────────────────────────┘
```

---

## Sniper Setups

These are the **highest weight (default 3)** confluence triggers. They represent ICT-textbook liquidity grab patterns.

### S1 — NY Sweep of Asian H/L

```
Trigger:  Inside NY kill zone
          AND price wicked beyond asianHighFinal/asianLowFinal
          AND close back inside Asian range
          AND candle direction confirms reversal
```

Mirror of Judas (London-time) but extended into NY KZ. Captures classic ICT continuation — institutions raid Asian high or low then reverse to fill positions.

### S2 — EQH/EQL Liquidity Pool Grab

```
Setup:    At least eqhEqlMinTouches pivot highs (default 2) within
          eqhEqlTolPips of each other  →  EQH detected
          (or pivot lows  →  EQL)

Trigger:  Wick pierces EQH+tol  AND  close back below EQH
          (or wick pierces EQL−tol  AND  close back above EQL)
```

Equal-level clusters mark resting stop pools. Smart money sweeps them then reverses.

### S3 — PDH/PDL Sweep-Reclaim

```
Trigger:  high > prevDayHigh  AND  close < prevDayHigh  AND  close < open
          (or low < prevDayLow  AND  close > prevDayLow  AND  close > open)
```

Classic stop-hunt fade of prior-day extreme.

---

## Order Block Doctrine

### G2 — Real Institutional Order Block

**Definition:** An OB is the **last opposite-color candle** preceding a meaningful displacement bar.

**Pipeline:**

1. Detect **displacement** bar: `close > high[1] AND (close − close[1]) ≥ obMinDisplacementPips × pipSize` (mirror for bearish)
2. Scan back up to `obLookbackBars` for the **last bearish candle** (for bullish displacement) or **last bullish candle** (for bearish displacement)
3. Anchor OB box to that candle's high/low
4. Push to active OB array
5. Mitigation: OB removed when close breaks back through it

> **Tunable** via `obLookbackBars` (default 15) and `obMinDisplacementPips` (default 8 pips). Higher displacement → fewer, higher-quality OBs.

This replaces v8.4 OB logic which incorrectly used the displacement candle's own range (engulf-misnamed).

---

## Weighted Scoring System

Every confluence factor contributes a weighted score. Max possible per direction:

```
maxScore = htfWeight                       // default 3
         + 2                               // M15 trend (hardcoded weight)
         + structureWeight                 // BOS / CHoCH, default 2
         + smcWeight                       // FVG / OB, default 2
         + otherWeight × 7                 // GZ/OTE, Sweep/Judas, PD,
                                           //  IndStack, CVD, Candle, RefGZ
         + 1                               // KZ bias
         + 1                               // Gann 50%
         + 2                               // TL break
         + sniperWeight                    // S1/S2/S3, default 3
```

With defaults: `maxScore = 3 + 2 + 2 + 2 + 7 + 1 + 1 + 2 + 3 = 23`

### Grades

| Grade | Score % | Max RR | Size Mult |
|-------|---------|--------|-----------|
| A+    | ≥80%    | 3.0    | 2.0×      |
| A     | ≥70%    | 2.5    | 1.5×      |
| B+    | ≥60%    | 2.5    | 1.2×      |
| B     | ≥50%    | 2.0    | 1.0×      |
| C     | ≥40%    | 1.5    | 0.5×      |
| D     | <40%    | 1.5    | 0.3×      |

`gradeRR` and `sizeMult` defined in `getRRForGrade()` and `getSizeMultForGrade()` Pine functions.

### Conflict detection

Setup is blocked if **both** bullScore and bearScore exceed `minWeightedScore` and the percentage difference is less than `100 − conflictThreshold`. With default `conflictThreshold = 60`, conflict fires when bull and bear are within 40% of each other.

---

## Setup-Tag Taxonomy

When a trade fires, the strategy assigns a setup tag using this priority order (highest first):

| Tag | Trigger |
|-----|---------|
| `S1_NYsweep` | NY KZ sweep of Asian H/L |
| `S2_EQH` / `S2_EQL` | Equal-high/low liquidity grab |
| `S3_PDH` / `S3_PDL` | Prior-day extreme reclaim |
| `JUDAS` | London KZ Asian-range fakeout |
| `CHoCH` | Change of Character |
| `BOS` | Break of Structure |
| `OB` | Price in Order Block |
| `FVG` | Price in Fair Value Gap |
| `MIX` | Mixed confluence (none of the above isolated) |

Tag stored on entry, logged on trade close into `analytics_tag` array, displayed in the Stats-by-Setup table.

---

## Two-Stage Entry

Default behavior with `useTwoStageEntry = true`:

### Stage 1: Pending signal

When `htfBullSetupReady` fires:
- `pendingBullSignal := true`
- `pendingBullBar := bar_index`
- Pending state visualized with orange circle plot + label

Pending expires after `pendingExpireBars` (default 15) bars if no trigger.

### Stage 2: LTF trigger

While pending bullish signal is active:
- Wait for LTF (default 1m) bullish trigger candle: pin bar, engulf, or strong-body close
- Confirm HTF still bullish
- Confirm no conflict
- Confirm news filter still OK
- Re-validate SL distance (close may have moved since pending set)
- Confirm zone retest if `requireRetest = true`

If all pass on the same bar → fire entry. Setup-tag derived at this bar from active triggers.

### Direct entry (alternative)

Set `useTwoStageEntry = false` to skip pending stage. Entry fires immediately on full gate pass. More signals but less precision — recommended only for higher timeframes.

---

## Risk Management

### Daily loss limit

`maxDailyLossPct` (default 3%). When today's equity drawdown exceeds this, no new trades for the rest of the day. Day boundary uses `Asia/Dhaka` for consistency with KZ hours.

### Consecutive losses

`maxConsecLosses` (default 3). After N consecutive full-position losses, entries blocked until at least 2 consecutive wins reset the streak (whipsaw guard).

### Equity guard

`maxDrawdownPct` (default 10%). Tracks peak equity from start; if current equity drops more than N% from peak, entries blocked.

### Daily trade limit

`maxTradesPerDay` (default 5). Caps trades per Dhaka day. Helps with revenge-trading tendency.

### Cooldown

`cooldownBars` (default 10) between trades. Increased by `cooldownAfterLoss` (default +20) after a losing trade. Cooldown counts from full position close, not entry, so long winners don't reduce cooldown to zero.

### Spread filter

`spreadOK` blocks entries when current bar's high-low range exceeds 1.5× the 20-bar average. Captures broker spread widening (mainly during news / session open).

### Volatility filter

`useVolFilter` requires ATR ratio (current ATR / 50-bar average ATR) to be within `[minATRMultiplier, maxATRMultiplier]` (defaults 0.7–2.5). Skips dead and exploding markets.

### Fresh session block

`blockFreshSessionOpen` (default true) blocks entries for `freshSessionMinutes` (default 15) after London or NY open. Skips spread spikes and opening-range whipsaws.

### SL distance gate

`minSLpips` (default 5) and `maxSLpips` (default 30) bracket. Below `min`: stop will be eaten by spread + slippage. Above `max`: stop is too wide for scalping R:R.

---

## Multi-Target Exit System

### Default split

| Exit | Qty | Target | Stop |
|------|-----|--------|------|
| X1   | 50% | TP1 = 1R | Initial SL |
| X2   | 30% | TP2 = 2R | Initial SL → BE on TP1 |
| X3   | 20% (remaining) | TP3 = grade RR | Initial SL → BE on TP1 → trailing |

### BE move on TP1

When `moveSLToBE = true` and TP1 hits, all open exits are re-issued with `stop = entryPrice`. Locked profit + runner.

### Trailing X3

After TP1 hit, X3 (the runner) gets ATR trailing stop: `trailDist = max(ATR × trailAtrMult, minTrailDistPips × pipSize)`. Only updates when new SL is favorable (no widening).

### Re-issue ABSOLUTE qty (not qty_percent)

After TP1 partial fill, re-applying `qty_percent` on the now-50%-position would double-count. Code uses absolute `qty = remPosition × (tp2Pct / (100 - tp1Pct))` to keep the math correct.

---

## Dashboard Reference

The dashboard (default Middle Right) shows real-time status. Rows from top to bottom:

| Row | Label | Meaning |
|-----|-------|---------|
| 0 | `🎯 SMC v8.5 SNIPER` | Title banner |
| 1 | Ticker / TF / Price | Current symbol context |
| 2 | Session / Setup | Active KZ + current sniper trigger if any |
| 3 | `🎯 ENTRY` | Entry section header |
| 4 | State | Scan / Pending / Long / Short / Session Block |
| 5 | Cooldown | Ready or countdown bars |
| 6 | Gate H/M | HTF and MTF alignment status |
| 7 | Position | Only if in position — TP1 status |
| 8+ | `🏆 QUALITY` block | Bull/Bear grade + score |
| ... | Conflict (only if active) | Warning row |
| ... | `🔭 MTF` block | Per-TF trend rows |
| ... | `🛡️ RISK` | Daily P&L % |
| ... | `📈 STATS` | Total trades / WR / net profit |

Auto-collapse:
- Session-row setup cell hides when no active setup
- Conflict row only when conflict detected
- Position row only when in position

---

## Stats-by-Setup Table

Position: Top Left. Always renders header. Shows placeholder until first trade closes.

### Columns

| Col | Meaning |
|-----|---------|
| Tag | Setup label (S1_NYsweep, BOS, etc.) |
| N | Number of closed trades with that tag |
| WR% | Win rate (color-coded: ≥60 green, ≥45 gold, else red) |
| Exp R | Expectancy in R-multiples per trade |
| PF | Profit Factor (sum winning R / sum losing R) |
| Sum R | Cumulative R-multiples |

Bottom row: TOTAL aggregate across all tags.

### How to use

After accumulating ~30+ trades per tag, look for:
- **Tags with PF < 1.0** → consider disabling that setup
- **Tags with WR > 60% and PF > 1.5** → consider increasing `sizeMult` for that path
- **Tags with high N but low Exp R** → tighten gating

This is the primary way to cull bad setups from your live strategy.

---

## Input Reference

### General
- `Show Dashboard` (bool) — toggle dashboard
- `Dashboard Position` (string) — Top/Middle/Bottom Right/Left
- `Text Size` (string) — Normal/Large/Huge
- `Show FVG/OB Zones` (bool)
- `Max Visible Zones` (int 1–10)
- `Show MTF Panel` (bool)

### Perfect Entry System
- `Two-Stage Entry` (bool) — pending+trigger
- `LTF Confirmation TF` (timeframe) — default `"1"` (M1)
- `Require Zone Retest` (bool)
- `Pending Expire (Bars)` (int 3–50)

### Weighted Scoring
- `HTF Weight` (1–5, default 3)
- `SMC Weight` (1–5, default 2)
- `Structure Weight` (1–5, default 2)
- `Other Weight` (1–3, default 1)
- `Skip on Conflict` (bool)
- `Conflict Threshold %` (40–80)
- `Min Weighted Score` (6–30)

### Adaptive RR
- `A+ Max RR` (float, default 3.0)
- `A Max RR` (default 2.5)
- `B Max RR` (default 2.0)
- `C Max RR` (default 1.5)

### Smart Sizing
- `Scale by Grade` (bool)
- `A+ Mult` (default 2.0)
- `A Mult` (default 1.5)
- `B Mult` (default 1.0)
- `C Mult` (default 0.5)

### Cooldown
- `Use Cooldown` (bool)
- `Cooldown Bars` (int 3–50)
- `Extra After Loss` (int 5–100)

### MTF
- `TF 1` through `TF 5` (timeframes, defaults 5/15/60/240/D)

### ATR / SL
- `ATR Length` (int, default 14)
- `ATR SL Mult` (default 1.5)
- `Structure SL` (bool)
- `SL Buffer (Pips)` (default 2)
- `Min SL Distance (pips)` (default 5)
- `Max SL Distance (pips)` (default 30)

### Multi-Target Exit
- `Multi-Target` (bool)
- `TP1 % of position` (10–90, default 50)
- `TP2 % of position` (10–90, default 30)
- `Move SL to BE on TP1` (bool)
- `Trailing Stop After TP1` (bool)
- `Trail ATR Mult` (default 3.0)
- `Min Trail Distance (pips)` (default 5)

### Position Sizing
- `Auto Lot` (bool)
- `Account Size` (float, default 1000)
- `Risk %` (0.1–5, default 1)
- `Pip Value` (default 10)

### Risk Management
- `Daily Loss Limit` (bool)
- `Max Daily Loss %` (default 3)
- `Stop on Consec Losses` (bool)
- `Max Consec Losses` (default 3)
- `Max Trades/Day` (default 5)
- `Equity Guard` (bool)
- `Max DD %` (default 10)

### Day Filter
- `Use Day Filter` (bool)
- `Mon` through `Fri` (bool per day, default Tue/Wed/Thu only)

### Volatility
- `Filter Volatility` (bool)
- `Min ATR` (default 0.7)
- `Max ATR` (default 2.5)

### Smart Money
- `Sweeps` (bool)
- `Sweep Lookback` (default 20)
- `P/D Zones` (bool)
- `PD Lookback` (default 50)
- `Asian Range` (bool)
- `Asian Start/End Hr` (defaults 4 / 13 Dhaka)
- `Judas` (bool)
- `OTE 62-79%` (bool)

### Kill Zones
- `Trade KZ Only` (bool)
- `London Start/End` (defaults 14 / 18 Dhaka)
- `NY Start/End` (defaults 19 / 23 Dhaka)
- `KZ Bias` (bool)
- `Session Levels` (bool)
- `Block first 15min` (bool)
- `Block first N minutes` (default 15)

### Structure
- `Swing Length (BOS)` (default 10)
- `Fast Pivot Length` (default 3) — **v8.5 G1**
- `BOS` / `CHoCH` (bool)
- `G1: Anchor SL to fast pivot` (bool)
- `Hard gate: HTF alignment` (bool, default true) — **v8.5 B3**
- `Hard gate: MTF strict` (bool, default false) — **v8.5 B4**

### v8.5 Sniper-Short Pack
- `G2: Real OB` (bool)
- `G2: OB lookback bars` (default 15)
- `G2: Min BOS displacement (pips)` (default 8)
- `S1: NY sweep of Asian H/L` (bool)
- `S2: EQH/EQL liquidity pool` (bool)
- `S2: EQH/EQL tolerance (pips)` (default 2)
- `S2: Min equal touches` (default 2)
- `S3: PDH/PDL sweep-reclaim` (bool)
- `Sniper-setup score weight` (default 3)

### Analytics
- `A2: Show stats-by-setup-tag table` (bool)
- `A1: Track MAE/MFE per trade` (bool)

### Pro Trading Tools
- `Auto Trendlines` (bool)
- `TL Pivot Length` (default 10)
- `Gann Box` (bool)
- `Gann Lookback/Projection` (defaults 50/50)
- `Refined Golden Zone` (bool)
- `GZ Lookback` (default 30)
- `Entry Setup Panel` (bool)
- `Min TP RR (1:X)` (default 2.0)
- `Chart Label Size` (Normal/Large/Huge)
- `Right-edge Label Offset (bars)` (default 35)

---

## Tuning Per Symbol Class

### Forex (EURUSD, GBPUSD, USDJPY, etc.)

Defaults are tuned for forex on M5. No changes needed.

### Forex JPY pairs

Pip-size auto-detected via `mintick × 10` (mintick = 0.001 → pip = 0.01). No changes needed.

### Metals (XAUUSD, XAGUSD)

Auto-detected. `pipSize = 0.1`. Increase `minSLpips` and `maxSLpips` since gold moves $1–$3 per move:

```
minSLpips = 30   // = $3 SL floor
maxSLpips = 200  // = $20 SL ceiling
```

Also bump `obMinDisplacementPips` to ~30 for meaningful displacement.

### Crypto (BTCUSDT, ETHUSDT)

`pipSize = mintick × 10` (so BTC pip ≈ 1 USD). Pip-based SL won't work well. Recommended: disable `useStructureSL` and let ATR-based SL handle it, then set:

```
minSLpips = 50   // = $50 SL floor for BTC
maxSLpips = 500  // = $500 ceiling
```

For ETH adjust proportionally.

### Indices (US30, NAS100, SPX500)

`pipSize = mintick`. Each "pip" is 1 index point. Tune `minSLpips` to ~10 for US30, ~5 for SPX500.

---

## Troubleshooting

### "No signals firing"

Check the dashboard:
- **Gate H/M row** — both showing ✓? If FLAT, HTF EMA stack disagrees with score direction → either disable `requireHTFAlign` or wait for trend
- **Cooldown** — READY?
- **Daily P&L** — within `maxDailyLoss`?
- **Session** — currently DEAD outside KZ? Enable trades outside KZ via `Trade KZ Only = false`
- **State** — `🚫 SESSION OPEN` means within fresh-session block; reduce `freshSessionMinutes` if too restrictive

Check Entry Setup Panel (bottom left):
- **SL pips L/S** — both OK? If TOO TIGHT or TOO WIDE, tune `minSLpips`/`maxSLpips`
- **Score** — both bull and bear shown. If both < `minWeightedScore`, no setup is qualifying. Lower threshold or wait for clearer move

### "Stats table empty"

By design — populates after first closed trade. Header + placeholder always show.

### "Too many BOS markers on chart"

v8.5 fixes this by only plotting first bar of break (consecutive bars suppressed). If still cluttered, increase `Swing Length (BOS)` from 10 to 15+.

### "Right-edge labels overlap"

Labels are X-staggered: RES TL at offset−5, SUP TL at offset−5, GZ at offset+5, GANN at offset+10. If still tight, increase `chartLabelOffset` from 35 to 50+.

### "Multiple dashboards visible"

You have multiple instances of the indicator on the same chart. Remove v8.4 (or older versions) from indicator stack — keep only v8.5.

### "OB boxes never form"

`obMinDisplacementPips` (default 8) may be too restrictive for low-volatility instruments. Lower to 4–5 for ranging forex, raise to 15+ for trending high-volatility (e.g. metals).

### "GZ box stale / not refreshing"

v8.5 caps GZ pivot to `(5,5)` regardless of `goldenZoneLookback`. If still slow, reduce `goldenZoneLookback` to 10 — `gzPivLen = min(5, goldenZoneLookback)` ensures fast refresh.

---

## Known Limitations

### B11 — Entry visualization off by one bar
`entryLine` and labels drawn at signal bar's `close`, but entry actually fills at next bar's open. Visualization may be off by spread + gap. Use TradingView's actual fill price in strategy tester for accuracy.

### B12 — Forex contract qty rounding
`longLotSize × 100000` may produce fractional contracts that some brokers reject (e.g. 0.013 lots → 1300 units, broker rounds to 1000). Round at broker side or quantize lot to 0.01.

### B14 — ATR warmup
`atr` is `na` for first 14 bars. Guarded but spurious signals possible in first 50 bars of any chart. Trust nothing until 100+ bars in.

### B18 — Trail re-issues every bar
`strategy.exit("X3_L", ...)` re-called every bar updates same-ID order. Minor broker-side spam. Pine native `trail_points` is an alternative but loses fine control.

### Pending re-arm after expire
When a pending signal expires (bar count exceeded), it can re-arm immediately if score still elevated. May result in late entries after zone exhaustion. Reduce `pendingExpireBars` if you see this pattern.

### Day boundary
Uses `dayofmonth(time, "Asia/Dhaka")`. If chart timezone is different, daily reset may misalign. Switch chart to Dhaka or update the TZ string in code.

### Webhook JSON
Webhook fires `alert.freq_once_per_bar_close` not `freq_all`. If your alert needs intrabar firing, change to `alert.freq_all` in the JSON dispatch block.

---

## Version History

### v8.5 (current)
- **G1**: Fast (3,3) pivot SL anchor
- **G2**: Real institutional OB (last opposite candle pre-BOS)
- **S1**: NY-on-Asian sweep
- **S2**: EQH/EQL liquidity pool + grab
- **S3**: PDH/PDL sweep-reclaim
- **A1**: MAE/MFE + R-multiple log
- **A2**: Stats-by-setup table
- **B3/B4**: HTF + MTF hard gates
- **B5**: GZ pivot capped at (5,5)
- **B7**: Day boundary tied to Asia/Dhaka
- **B10**: Symbol-class aware pipSize (forex/JPY/metal/crypto)
- **B16**: Streak reset requires 2 consec wins
- **B19**: EMA dropped from scoring (double-count fix)
- **B20**: Cooldown counts from CLOSE (not entry)
- UI: dash session badge, active setup row, HTF/MTF gate row, auto-collapse "—" cells, declutter BOS markers, label X-stagger

### v8.4
- C1: Forex qty unit fix (lots → contracts ×100k)
- C2: TP1 detection via PRICE check
- C3: Trailing cancel-then-reissue with absolute qty
- C4: SL distance gate re-checked at execution
- C5: Trendlines detect both directions
- C6: OTE/GZ impulse leg validated
- C7: Gann halves bounded inside box
- U1–U6: UI legibility fixes
- H1: CVD SMA computed unconditionally
- H2: OB signal relaxed

### v8.3
- B1: HTF EMA computed inside `request.security`
- B2: Auto-lot actually passed to `strategy.entry`
- B3: `freshSessionBlock` uses bars-since-open counter
- B4: Sweep lookback excludes current bar
- B6: Adaptive RR ceilings lowered to scalp-realistic
- B7: Min SL-distance gate (skip noise stops)

### v8.2
- #11: `lookahead_off` (no repainting)
- #1: `request.security` wrapped properly
- #3–5: Multi-target rebuilt with delta + flat reset, absolute qty, BE on TP1
- #16: Realistic commission/slippage
- #2: `pyramiding=1`
- #6: Adaptive trail with min-distance floor
- #9: `consecutiveLosses` tracked by full close
- #17: `calc_on_every_tick=true`
- #12: Tighter structure SL
- #13: OTE uses actual impulse legs
- #14: `maxScore` auto-computed
- #8: Session reset on session START
- #18: Block first 15 min of session
- #19: Expanded news windows

---

## License & Attribution

This is a personal trading strategy. Use at own risk. Past performance does not guarantee future results. No warranty expressed or implied.

Built for [TradingView](https://www.tradingview.com/) Pine Script v5.

---

## Quick Reference Cheat Sheet

```
╔════════════════════════════════════════════════════════════════╗
║  SMC v8.5 SNIPER  —  DEFAULT TUNING                            ║
╠════════════════════════════════════════════════════════════════╣
║  Instrument:        EURUSD / GBPUSD                            ║
║  Timeframe:         M1–M15                                     ║
║  Account:           $1000  @  1% risk                          ║
║  Min Score:         12 / 23                                    ║
║  Min SL:            5 pips    Max SL:    30 pips               ║
║  Cooldown:          10 bars   (+20 after loss)                 ║
║  Max trades/day:    5         Max consec losses: 3             ║
║  Daily loss cap:    3%        Max DD:     10%                  ║
║                                                                ║
║  ✅ HTF hard gate ON                                            ║
║  ✅ Fast (3,3) SL anchor                                        ║
║  ✅ Real OB (8 pip min displacement)                            ║
║  ✅ Sniper setups S1/S2/S3 wired (weight 3)                     ║
║  ✅ MAE/MFE + R-multiple analytics                              ║
║                                                                ║
║  Workflow: Backtest 3 months → check stats table →             ║
║            disable losing tags → live trade refined config     ║
╚════════════════════════════════════════════════════════════════╝
```
