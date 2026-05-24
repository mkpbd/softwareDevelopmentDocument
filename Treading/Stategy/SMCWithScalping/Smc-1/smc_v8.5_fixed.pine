//@version=5
// ═══════════════════════════════════════════════════════════════════════════
// 🎯 SMC SCALPING MASTER PRO v8.5 - SNIPER-SHORT + BACKTEST-TRUTH EDITION
// ─────────────────────────────────────────────────────────────────────────
// v8.5 NEW (senior-trader gap fixes + sniper-short pack + analytics):
//   G1 Fast swing pivot (3,3) for tight structure SL (v8.4 was 50min stale on 5m)
//   G2 OB rebuilt: anchor to LAST opposite candle BEFORE BOS displacement
//      (v8.4 logic = engulf misnamed; now real institutional OB)
//   S1 NY Asian-High/Low sweep — extends Judas into NY KZ (classic short setup)
//   S2 EQH/EQL liquidity pool + grab trigger (multi-pivot equal-level cluster)
//   S3 PDH/PDL sweep-reclaim — pierce prior-day extreme then close back inside
//   A1 Backtest analytics: MAE/MFE per trade, setup-tag capture, R-multiple log
//   A2 Stats table: WR by setup-tag, WR by grade, expectancy, profit factor
//   New scoring contributions wired for S1/S2/S3 (weight=3 — sniper-grade)
//
// v8.4 FIXES (critical scalping bugs + UI legibility):
//   C1 Forex qty unit fixed: lots → contracts (×100,000 for forex)
//   C2 TP1 detection rebuilt via PRICE check (closedtrades unreliable on partials)
//   C3 Trailing stop: cancel-then-reissue X2/X3 with absolute qty
//   C4 SL distance gate re-checked at execution
//   C5 Trendlines detect BOTH directions (ascending + descending)
//   C6 OTE/GZ impulse leg validated (consecutive pivots only)
//   C7 Gann lower/upper half bounded inside box
//   U1 GZ SELL pink bg → BLACK text (was white = unreadable)
//   U2 TP1/TP2 labels solid color + white + bigger size
//   U3 Gann 50% label: solid gold + black text + bigger, offset to avoid GZ
//   U4 Support/Resistance TL labels solid bg + larger text
//   U5 Right-edge labels staggered vertically (no overlap)
//   U6 Entry panel + dashboard size uses chosen scale (no hardcoded small)
//   H1 CVD SMA computed unconditionally
//   H2 OB signal relaxed (no need to break high[1])
//
// v8.3 FIXES (currency-scalping focused):
//   B1 HTF EMA now computed INSIDE request.security (was sampling LTF EMA)
//   B2 Auto-lot actually passed to strategy.entry (was cosmetic-only)
//   B3 freshSessionBlock uses bars-since-open counter (was inverted)
//   B4 Sweep lookback excludes current bar (high[1]/low[1])
//   B6 Adaptive RR ceilings lowered to scalp-realistic (3/2.5/2/1.5)
//   B7 Min SL-distance gate (skip noise-stops)
//
// COMPLETE FIX LIST (v8.2):
//
// 🔴 CRITICAL FIXES:
//   #11 lookahead_on → lookahead_off (no more repainting)
//   #1  request.security wrapped in expression function (proper HTF EMA)
//   #3  TP1-hit detection rebuilt with closed-trade-count delta + flat reset
//   #4  Multi-target uses absolute qty (no qty_percent ambiguity)
//   #5  BE move updates ALL active exit IDs (X2 + X3)
//   #16 Realistic commission/slippage for forex scalping
//
// 🟠 HIGH-SEVERITY FIXES:
//   #2  pyramiding=1 (matches single-position logic)
//   #6  Adaptive trail with min-distance floor (no scalping whipsaw)
//   #9  consecutiveLosses tracked by full-position-close, not per-exit-ID
//   #17 calc_on_every_tick=true for accurate intrabar BE/trail
//
// 🟡 MEDIUM-SEVERITY FIXES:
//   #12 Structure SL uses tighter logic (better scalp R:R)
//   #13 OTE uses actual impulse legs (not 50-bar range)
//   #14 maxScore auto-computed dynamically
//   #8  Session reset on session START (no 1-bar lag)
//   #18 Block first 15 min of London/NY (spread spike protection)
//   #19 Expanded news windows (NFP, CPI, FOMC times)
//
// 🟢 LOW-SEVERITY FIXES:
//   #7  lastSignalBar updates on entry AND close
//   #10 tradesToday tracked consistently
//   #15 Day reset via ta.change(time("D"))
//
// 🎁 NEW IN v8.2:
//   - Trade-level R-multiple tracking
//   - Per-trade capture of qty/SL/TP1/TP2 for accurate partial fills
//   - Fresh-session-open filter
//   - Unified position state machine
// ═══════════════════════════════════════════════════════════════════════════

strategy("SMC v8.5 Sniper-Short + Backtest-Truth",
     shorttitle="SMC_v8.5",
     overlay=true,
     initial_capital=1000,
     default_qty_type=strategy.percent_of_equity,
     default_qty_value=1,
     commission_type=strategy.commission.cash_per_contract,
     commission_value=3.5,
     slippage=5,
     calc_on_every_tick=true,
     calc_on_order_fills=true,
     pyramiding=1,
     max_lines_count=500,
     max_boxes_count=500,
     max_labels_count=500)

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 COLOR PALETTE
// ═══════════════════════════════════════════════════════════════════════════

color CLR_BG_DARK    = color.rgb(10, 14, 23)
color CLR_BG_CARD    = color.rgb(20, 27, 45)
color CLR_BG_HEADER  = color.rgb(30, 41, 59)
color CLR_BORDER     = color.rgb(71, 85, 105)
color CLR_ACCENT     = color.rgb(59, 130, 246)
color CLR_WHITE      = color.rgb(255, 255, 255)
color CLR_TEXT_LIGHT = color.rgb(241, 245, 249)
color CLR_TEXT_MUTED = color.rgb(148, 163, 184)
color CLR_BULL       = color.rgb(34, 197, 94)
color CLR_BEAR       = color.rgb(239, 68, 68)
color CLR_GOLD       = color.rgb(251, 191, 36)
color CLR_PURPLE     = color.rgb(168, 85, 247)
color CLR_CYAN       = color.rgb(34, 211, 238)
color CLR_ORANGE     = color.rgb(251, 146, 60)
color CLR_PINK       = color.rgb(244, 114, 182)
color CLR_BULL_BG    = color.rgb(20, 83, 45)
color CLR_BEAR_BG    = color.rgb(127, 29, 29)
color CLR_GOLD_BG    = color.rgb(120, 53, 15)
color CLR_NEUTRAL_BG = color.rgb(51, 65, 85)
color CLR_PURPLE_BG  = color.rgb(76, 29, 149)
color CLR_PENDING    = color.rgb(255, 165, 0)

// v8.4 U1-U4: high-contrast LABEL palette (solid bg + readable text on chart)
color CLR_LBL_GZ_SELL_BG = color.rgb(244, 114, 182)   // pink
color CLR_LBL_GZ_SELL_TX = color.rgb(20, 5, 15)       // near-black for contrast on pink
color CLR_LBL_GZ_BUY_BG  = color.rgb(251, 191, 36)    // gold
color CLR_LBL_GZ_BUY_TX  = color.rgb(15, 10, 0)       // near-black
color CLR_LBL_GANN_BG    = color.rgb(255, 200, 50)    // brighter gold
color CLR_LBL_GANN_TX    = color.rgb(20, 12, 0)
color CLR_LBL_TP1_BG     = color.rgb(74, 222, 128)    // solid green (not translucent)
color CLR_LBL_TP2_BG     = color.rgb(34, 197, 94)
color CLR_LBL_TP3_BG     = color.rgb(22, 163, 74)
color CLR_LBL_SL_BG      = color.rgb(239, 68, 68)
color CLR_LBL_TL_RES_BG  = color.rgb(220, 38, 38)     // resistance line label
color CLR_LBL_TL_SUP_BG  = color.rgb(22, 163, 74)

// ═══════════════════════════════════════════════════════════════════════════
// 📊 INPUTS
// ═══════════════════════════════════════════════════════════════════════════

grp_gen = "⚙️ General"
showDashboard = input.bool(true, "Show Dashboard", group=grp_gen)
dashPos = input.string("Middle Right", "Dashboard Position", options=["Top Right", "Top Left", "Middle Right", "Bottom Right"], group=grp_gen)
dashTextSize = input.string("Large", "Text Size", options=["Normal", "Large", "Huge"], group=grp_gen)
showZones = input.bool(true, "Show FVG/OB Zones", group=grp_gen)
maxZones = input.int(3, "Max Visible Zones", minval=1, maxval=10, group=grp_gen)
showMTF = input.bool(true, "Show MTF Panel", group=grp_gen)

grp_perfect = "🎯 Perfect Entry System"
useTwoStageEntry = input.bool(true, "Two-Stage Entry", group=grp_perfect)
ltfConfirmTF = input.timeframe("1", "LTF Confirmation TF", group=grp_perfect)
requireRetest = input.bool(true, "Require Zone Retest", group=grp_perfect)
pendingExpireBars = input.int(15, "Pending Expire (Bars)", minval=3, maxval=50, group=grp_perfect)

grp_weights = "⚖️ Weighted Scoring"
htfWeight = input.int(3, "HTF Weight", minval=1, maxval=5, group=grp_weights)
smcWeight = input.int(2, "SMC Weight", minval=1, maxval=5, group=grp_weights)
structureWeight = input.int(2, "Structure Weight", minval=1, maxval=5, group=grp_weights)
otherWeight = input.int(1, "Other Weight", minval=1, maxval=3, group=grp_weights)
useConflictDetector = input.bool(true, "Skip on Conflict", group=grp_weights)
conflictThreshold = input.int(60, "Conflict Threshold %", minval=40, maxval=80, group=grp_weights)
minWeightedScore = input.int(12, "Min Weighted Score", minval=6, maxval=30, group=grp_weights)

grp_adaptive = "🎯 Adaptive RR (Scalp-tuned v8.3)"
useAdaptiveRR = input.bool(true, "Use Adaptive RR", group=grp_adaptive)
// v8.3: scalp-realistic RR ceilings. 5R/4R rarely fills on intraday currency
// moves; expectancy hurt by stop-outs of high-RR runners. Cap lowered.
rrAPlus = input.float(3.0, "A+ Max RR", minval=1.5, step=0.25, group=grp_adaptive)
rrA = input.float(2.5, "A Max RR", minval=1.5, step=0.25, group=grp_adaptive)
rrB = input.float(2.0, "B Max RR", minval=1.25, step=0.25, group=grp_adaptive)
rrC = input.float(1.5, "C Max RR", minval=1.0, step=0.25, group=grp_adaptive)

grp_sizing = "📊 Smart Sizing"
useGradeSizing = input.bool(true, "Scale by Grade", group=grp_sizing)
sizeMultAPlus = input.float(2.0, "A+ Mult", minval=1.0, step=0.1, group=grp_sizing)
sizeMultA = input.float(1.5, "A Mult", minval=1.0, step=0.1, group=grp_sizing)
sizeMultB = input.float(1.0, "B Mult", minval=0.5, step=0.1, group=grp_sizing)
sizeMultC = input.float(0.5, "C Mult", minval=0.3, step=0.1, group=grp_sizing)

grp_cooldown = "⏱️ Cooldown"
useCooldown = input.bool(true, "Use Cooldown", group=grp_cooldown)
cooldownBars = input.int(10, "Cooldown Bars", minval=3, maxval=50, group=grp_cooldown)
cooldownAfterLoss = input.int(20, "Extra After Loss", minval=5, maxval=100, group=grp_cooldown)

grp_mtf = "🔭 MTF"
tf1 = input.timeframe("5", "TF 1", group=grp_mtf)
tf2 = input.timeframe("15", "TF 2 (M15)", group=grp_mtf)
tf3 = input.timeframe("60", "TF 3 (HTF)", group=grp_mtf)
tf4 = input.timeframe("240", "TF 4", group=grp_mtf)
tf5 = input.timeframe("D", "TF 5", group=grp_mtf)

grp_viz = "📊 Visualization"
showSLTP = input.bool(true, "Show SL/TP", group=grp_viz)
showPositionBox = input.bool(true, "Show Position Box", group=grp_viz)
showRR = input.bool(true, "Show RR Label", group=grp_viz)
showPendingSignal = input.bool(true, "Show Pending Marker", group=grp_viz)

grp_atr = "⚡ ATR"
atrLength = input.int(14, "ATR Length", minval=5, group=grp_atr)
atrSLMultiplier = input.float(1.5, "ATR SL Mult", minval=0.5, step=0.1, group=grp_atr)
useStructureSL = input.bool(true, "Structure SL", group=grp_atr)
slBufferPips = input.float(2, "SL Buffer (Pips)", minval=0.5, group=grp_atr)
// v8.3 B7: skip trades whose SL is so tight it's just noise (spread+slippage eat it)
minSLpips = input.float(5.0, "Min SL Distance (pips) — scalp noise floor", minval=1.0, step=0.5, group=grp_atr)
maxSLpips = input.float(30.0, "Max SL Distance (pips) — skip wide stops", minval=5.0, step=1.0, group=grp_atr)

grp_exit = "🎯 Multi-Target Exit"
useMultiTarget = input.bool(true, "Multi-Target", group=grp_exit)
tp1Pct = input.int(50, "TP1 % of position", minval=10, maxval=90, group=grp_exit)
tp2Pct = input.int(30, "TP2 % of position", minval=10, maxval=90, group=grp_exit)
moveSLToBE = input.bool(true, "Move SL to BE on TP1", group=grp_exit)
useTrailing = input.bool(true, "Trailing Stop After TP1", group=grp_exit)
trailAtrMult = input.float(3.0, "Trail ATR Mult", minval=0.5, step=0.1, group=grp_exit)
minTrailDistPips = input.float(5.0, "Min Trail Distance (pips)", minval=1.0, step=0.5, group=grp_exit)

grp_size = "💰 Position Sizing"
useAutoLot = input.bool(true, "Auto Lot", group=grp_size)
accountSize = input.float(1000, "Account Size", minval=100, group=grp_size)
riskPerTrade = input.float(1.0, "Risk %", minval=0.1, maxval=5.0, step=0.1, group=grp_size)
pipValue = input.float(10, "Pip Value", minval=0.01, group=grp_size)

grp_risk = "💰 Risk Management"
useDailyLimit = input.bool(true, "Daily Loss Limit", group=grp_risk)
maxDailyLossPct = input.float(3.0, "Max Daily Loss %", minval=1.0, step=0.5, group=grp_risk)
useMaxLosses = input.bool(true, "Stop on Consec Losses", group=grp_risk)
maxConsecLosses = input.int(3, "Max Consec Losses", minval=2, group=grp_risk)
maxTradesPerDay = input.int(5, "Max Trades/Day", minval=1, group=grp_risk)
useEquityGuard = input.bool(true, "Equity Guard", group=grp_risk)
maxDrawdownPct = input.float(10.0, "Max DD %", minval=2.0, step=1.0, group=grp_risk)

grp_day = "📅 Day Filter"
useDayFilter = input.bool(true, "Use Day Filter", group=grp_day)
tradeMonday = input.bool(false, "Mon", group=grp_day)
tradeTuesday = input.bool(true, "Tue", group=grp_day)
tradeWednesday = input.bool(true, "Wed", group=grp_day)
tradeThursday = input.bool(true, "Thu", group=grp_day)
tradeFriday = input.bool(false, "Fri", group=grp_day)

grp_vol = "📊 Volatility"
useVolFilter = input.bool(true, "Filter Volatility", group=grp_vol)
minATRMultiplier = input.float(0.7, "Min ATR", minval=0.3, step=0.1, group=grp_vol)
maxATRMultiplier = input.float(2.5, "Max ATR", minval=1.5, step=0.1, group=grp_vol)

grp_liq = "💧 Smart Money"
useLiquiditySweep = input.bool(true, "Sweeps", group=grp_liq)
sweepLookback = input.int(20, "Sweep Lookback", minval=10, group=grp_liq)
usePremDisc = input.bool(true, "P/D Zones", group=grp_liq)
premDiscLookback = input.int(50, "PD Lookback", minval=10, group=grp_liq)
useAsianRange = input.bool(true, "Asian Range", group=grp_liq)
asianStartHr = input.int(4, "Asian Start", minval=0, maxval=23, group=grp_liq)
asianEndHr = input.int(13, "Asian End", minval=0, maxval=23, group=grp_liq)
useJudasSwing = input.bool(true, "Judas", group=grp_liq)
useOTE = input.bool(true, "OTE 62-79% (Impulse-based)", group=grp_liq)

grp_ind = "📊 Indicators"
useRSI = input.bool(true, "RSI", group=grp_ind)
rsiLength = input.int(14, "RSI Length", minval=5, group=grp_ind)
useVWAP = input.bool(true, "VWAP", group=grp_ind)
usePivots = input.bool(true, "Pivots", group=grp_ind)
usePDArray = input.bool(true, "PDH/PDL/PDC", group=grp_ind)

grp_kz = "⏰ Kill Zones"
useKillZone = input.bool(true, "Trade KZ Only", group=grp_kz)
londonStart = input.int(14, "London Start", minval=0, maxval=23, group=grp_kz)
londonEnd = input.int(18, "London End", minval=0, maxval=23, group=grp_kz)
nyStart = input.int(19, "NY Start", minval=0, maxval=23, group=grp_kz)
nyEnd = input.int(23, "NY End", minval=0, maxval=23, group=grp_kz)
useKillzoneBias = input.bool(true, "KZ Bias", group=grp_kz)
useSessionLevels = input.bool(true, "Session Levels", group=grp_kz)
blockFreshSessionOpen = input.bool(true, "Block first 15min of session", group=grp_kz)

grp_news = "📰 News"
useNewsFilter = input.bool(true, "News Filter", group=grp_news)
newsBufferMin = input.int(30, "Buffer Min", minval=5, group=grp_news)

grp_str = "🏗️ Structure"
swingLength = input.int(10, "Swing Length (BOS)", minval=3, group=grp_str)
fastSwingLen = input.int(3, "Fast Pivot Length (G1 — SL anchor)", minval=2, maxval=10, group=grp_str)
useBOS = input.bool(true, "BOS", group=grp_str)
useCHoCH = input.bool(true, "CHoCH", group=grp_str)
useFastStructSL = input.bool(true, "G1: Anchor SL to fast (3,3) pivot", group=grp_str)
requireHTFAlign = input.bool(true, "Hard gate: require HTF alignment (no counter-trend)", group=grp_str)
requireMTFAlign = input.bool(false, "Hard gate: require MTF score ≥3 (strict)", group=grp_str)

grp_v85 = "🎯 v8.5 Sniper-Short Pack"
useRealOB = input.bool(true, "G2: Real OB (last opposite candle pre-BOS)", group=grp_v85)
obLookbackBars = input.int(15, "G2: OB lookback (bars before BOS)", minval=3, maxval=50, group=grp_v85)
obMinDisplacementPips = input.float(8.0, "G2: Min BOS displacement (pips)", minval=2.0, step=0.5, group=grp_v85)
useAsianSweepNY = input.bool(true, "S1: NY sweep of Asian H/L", group=grp_v85)
useEQHEQL = input.bool(true, "S2: EQH/EQL liquidity pool", group=grp_v85)
eqhEqlTolPips = input.float(2.0, "S2: EQH/EQL tolerance (pips)", minval=0.5, step=0.5, group=grp_v85)
eqhEqlMinTouches = input.int(2, "S2: Min equal touches", minval=2, maxval=5, group=grp_v85)
usePDsweepReclaim = input.bool(true, "S3: PDH/PDL sweep-reclaim", group=grp_v85)
sniperWeight = input.int(3, "Sniper-setup score weight (S1/S2/S3)", minval=1, maxval=5, group=grp_v85)

grp_analytics = "📈 Backtest Analytics (A1/A2)"
showAnalyticsTable = input.bool(true, "A2: Show stats-by-setup-tag table", group=grp_analytics)
trackMAEMFE = input.bool(true, "A1: Track MAE/MFE per trade", group=grp_analytics)

grp_smc = "💎 SMC"
useFVG = input.bool(true, "FVG", group=grp_smc)
useOB = input.bool(true, "OB", group=grp_smc)
fvgMinSize = input.float(0.5, "Min FVG", minval=0.1, group=grp_smc)
expireMitigatedZones = input.bool(true, "Remove Mitigated", group=grp_smc)

grp_fibR = "🔢 Fibonacci"
useFibRetracement = input.bool(true, "Fib", group=grp_fibR)
fibLength = input.int(50, "Fib Lookback", minval=10, group=grp_fibR)

grp_flt = "🔍 EMA"
useEMAFilter = input.bool(true, "EMA Filter", group=grp_flt)
emaFastLen = input.int(9, "Fast EMA", minval=3, group=grp_flt)
emaSlowLen = input.int(21, "Slow EMA", minval=10, group=grp_flt)

grp_webhook = "🔔 Webhook"
useWebhook = input.bool(false, "JSON Alerts", group=grp_webhook)

grp_tools = "📐 Pro Trading Tools"
showTrendlines = input.bool(true, "Auto Trendlines", group=grp_tools)
trendlinePivotLen = input.int(10, "TL Pivot Length", minval=3, group=grp_tools)
showGannBox = input.bool(true, "Gann Box", group=grp_tools)
gannLookback = input.int(50, "Gann Lookback", minval=20, group=grp_tools)
gannProjectBars = input.int(50, "Gann Projection", minval=10, group=grp_tools)
showGoldenZone = input.bool(true, "Refined Golden Zone", group=grp_tools)
goldenZoneLookback = input.int(30, "GZ Lookback", minval=10, group=grp_tools)
showEntryPanel = input.bool(true, "Entry Setup Panel", group=grp_tools)
minTPRatio = input.float(2.0, "Min TP RR (1:X)", minval=1.5, step=0.1, group=grp_tools)
labelSizeChoice = input.string("Large", "Chart Label Size", options=["Normal", "Large", "Huge"], group=grp_tools)
chartLabelOffset = input.int(35, "Right-edge Label Offset (bars)", minval=5, maxval=80, group=grp_tools)

// ═══════════════════════════════════════════════════════════════════════════
// 📐 CORE
// ═══════════════════════════════════════════════════════════════════════════

// v8.5 B10: symbol-class aware pipSize.
// forex non-JPY: pip = 10*mintick (mintick 0.00001 → pip 0.0001)
// forex JPY:    pip = 10*mintick (mintick 0.001   → pip 0.01)
// metals (XAU/XAG): pip = 0.1 typically — too coarse if just mintick
// crypto/indices/stock: use mintick directly (no concept of pip; treat as min increment)
isForexSym  = syminfo.type == "forex"
isMetalSym  = str.contains(syminfo.ticker, "XAU") or str.contains(syminfo.ticker, "XAG") or str.contains(syminfo.ticker, "GOLD") or str.contains(syminfo.ticker, "SILVER")
isCryptoSym = syminfo.type == "crypto"
pipSize = isForexSym ? syminfo.mintick * 10 : isMetalSym ? 0.1 : isCryptoSym ? syminfo.mintick * 10 : syminfo.mintick
emaFast = ta.ema(close, emaFastLen)
emaSlow = ta.ema(close, emaSlowLen)
atr = ta.atr(atrLength)
atrAvg = ta.sma(atr, 50)

txtSizeSmall = dashTextSize == "Huge" ? size.normal : dashTextSize == "Large" ? size.small : size.tiny
txtSizeNormal = dashTextSize == "Huge" ? size.large : dashTextSize == "Large" ? size.normal : size.small
txtSizeBig = dashTextSize == "Huge" ? size.huge : dashTextSize == "Large" ? size.large : size.normal

// v8.4 U2/U6: chart-label size scales independently of dashboard
lblSizeChart = labelSizeChoice == "Huge" ? size.huge : labelSizeChoice == "Large" ? size.large : size.normal
lblSizeChartMid = labelSizeChoice == "Huge" ? size.large : labelSizeChoice == "Large" ? size.normal : size.small
lblSizeChartSmall = labelSizeChoice == "Huge" ? size.normal : labelSizeChoice == "Large" ? size.small : size.tiny

realSpread = (high - low) / pipSize
avgSpread = ta.sma(realSpread, 20)
spreadOK = realSpread <= avgSpread * 1.5

// ═══════════════════════════════════════════════════════════════════════════
// ⏰ TIME & SESSIONS — FIX #8 (reset on session start) + FIX #18 (fresh-open block)
// ═══════════════════════════════════════════════════════════════════════════

currentHour = hour(time, "Asia/Dhaka")
currentMin = minute(time, "Asia/Dhaka")
currentDay = dayofweek(time, "Asia/Dhaka")

isLondonKZ = currentHour >= londonStart and currentHour < londonEnd
isNYKZ = currentHour >= nyStart and currentHour < nyEnd
isOverlap = currentHour >= 19 and currentHour < 21
inKillZone = isLondonKZ or isNYKZ or isOverlap

bgcolor(useKillZone and isOverlap ? color.new(CLR_GOLD, 95) : na, title="Overlap")
bgcolor(useKillZone and isLondonKZ and not isOverlap ? color.new(CLR_CYAN, 96) : na, title="London")
bgcolor(useKillZone and isNYKZ and not isOverlap ? color.new(CLR_BEAR, 96) : na, title="NY")

dayFilterOK = not useDayFilter or (currentDay == dayofweek.monday and tradeMonday) or (currentDay == dayofweek.tuesday and tradeTuesday) or (currentDay == dayofweek.wednesday and tradeWednesday) or (currentDay == dayofweek.thursday and tradeThursday) or (currentDay == dayofweek.friday and tradeFriday)

// 🐛 FIX #19: Expanded news windows covering NFP (Fri 18:30 BD = 12:30 GMT-5),
// FOMC (00:00 BD next day), CPI (18:30 BD), ECB (17:45 BD), BoE (17:00 BD)
isNewsTime = (currentHour == 18 and currentMin >= 30 - newsBufferMin and currentMin <= 30 + newsBufferMin) or (currentHour == 17 and currentMin >= 45 - newsBufferMin and currentMin <= 45 + newsBufferMin) or (currentHour == 17 and currentMin >= 0 and currentMin <= newsBufferMin) or (currentHour == 20 and currentMin <= newsBufferMin) or (currentHour == 0 and currentMin <= newsBufferMin)
newsFilterOK = not useNewsFilter or not isNewsTime

// 🐛 FIX #8: Reset on session START (no 1-bar lag)
var float londonHigh = na
var float londonLow = na
var float nyHigh = na
var float nyLow = na
var float asianHigh = na
var float asianLow = na

isAsianSession = currentHour >= asianStartHr and currentHour < asianEndHr

if isLondonKZ and not isLondonKZ[1]
    londonHigh := high
    londonLow := low
else if isLondonKZ
    londonHigh := math.max(londonHigh, high)
    londonLow := math.min(londonLow, low)

if isNYKZ and not isNYKZ[1]
    nyHigh := high
    nyLow := low
else if isNYKZ
    nyHigh := math.max(nyHigh, high)
    nyLow := math.min(nyLow, low)

if isAsianSession and not isAsianSession[1]
    asianHigh := high
    asianLow := low
else if isAsianSession
    asianHigh := math.max(asianHigh, high)
    asianLow := math.min(asianLow, low)

// 🐛 FIX #18 v8.3: Bars-since-open counter (proper fresh-session block)
// v8.2 BUG: `not isLondonKZ[15]` meant "session inactive 15 bars ago" — on
// 5m chart that's 75min — so block stayed true for whole session minus the
// middle. Now uses an explicit counter reset on session start.
freshSessionMinutes = input.int(15, "Block first N minutes of session", minval=0, maxval=120, group=grp_kz)
var int londonBarsSinceOpen = 9999
var int nyBarsSinceOpen = 9999
londonBarsSinceOpen := isLondonKZ and not isLondonKZ[1] ? 0 : isLondonKZ ? londonBarsSinceOpen + 1 : 9999
nyBarsSinceOpen := isNYKZ and not isNYKZ[1] ? 0 : isNYKZ ? nyBarsSinceOpen + 1 : 9999
barMinutes = timeframe.in_seconds(timeframe.period) / 60
freshLondonOpen = isLondonKZ and londonBarsSinceOpen * barMinutes < freshSessionMinutes
freshNYOpen = isNYKZ and nyBarsSinceOpen * barMinutes < freshSessionMinutes
freshSessionBlock = blockFreshSessionOpen and (freshLondonOpen or freshNYOpen)

var line londonHighLine = na
var line londonLowLine = na
var line nyHighLine = na
var line nyLowLine = na

if useSessionLevels and barstate.islast
    if not na(londonHigh)
        line.delete(londonHighLine)
        londonHighLine := line.new(bar_index - 30, londonHigh, bar_index + 20, londonHigh, color=CLR_CYAN, width=1, style=line.style_dashed, extend=extend.right)
    if not na(londonLow)
        line.delete(londonLowLine)
        londonLowLine := line.new(bar_index - 30, londonLow, bar_index + 20, londonLow, color=CLR_CYAN, width=1, style=line.style_dashed, extend=extend.right)
    if not na(nyHigh)
        line.delete(nyHighLine)
        nyHighLine := line.new(bar_index - 30, nyHigh, bar_index + 20, nyHigh, color=CLR_BEAR, width=1, style=line.style_dashed, extend=extend.right)
    if not na(nyLow)
        line.delete(nyLowLine)
        nyLowLine := line.new(bar_index - 30, nyLow, bar_index + 20, nyLow, color=CLR_BEAR, width=1, style=line.style_dashed, extend=extend.right)

var float londonOpenPrice = na
var int londonBias = 0
var float nyOpenPrice = na
var int nyBias = 0

if useKillzoneBias and currentHour == londonStart and currentMin == 0
    londonOpenPrice := open
    londonBias := 0
if useKillzoneBias and currentHour == londonStart + 1 and currentMin == 0 and not na(londonOpenPrice)
    londonBias := close > londonOpenPrice ? 1 : -1
if useKillzoneBias and currentHour == nyStart and currentMin == 0
    nyOpenPrice := open
    nyBias := 0
if useKillzoneBias and currentHour == nyStart + 1 and currentMin == 0 and not na(nyOpenPrice)
    nyBias := close > nyOpenPrice ? 1 : -1

// ═══════════════════════════════════════════════════════════════════════════
// 🔭 MTF — FIX #1 v8.3: TRUE HTF EMA (computed inside request.security expression)
// ═══════════════════════════════════════════════════════════════════════════
// v8.2 BUG: pre-computing ta.ema(close, n) at LTF then sampling on HTF gives
// the LTF EMA value at HTF timestamps — NOT the HTF EMA. We now wrap the EMA
// calculation in a helper called inside request.security so the EMA is
// evaluated on the target timeframe.

htfTuple() => [close, ta.ema(close, emaFastLen), ta.ema(close, emaSlowLen)]

[c1, ef1, es1] = request.security(syminfo.tickerid, tf1, htfTuple(), lookahead=barmerge.lookahead_off)
[c2, ef2, es2] = request.security(syminfo.tickerid, tf2, htfTuple(), lookahead=barmerge.lookahead_off)
[c3, ef3, es3] = request.security(syminfo.tickerid, tf3, htfTuple(), lookahead=barmerge.lookahead_off)
[c4, ef4, es4] = request.security(syminfo.tickerid, tf4, htfTuple(), lookahead=barmerge.lookahead_off)
[c5, ef5, es5] = request.security(syminfo.tickerid, tf5, htfTuple(), lookahead=barmerge.lookahead_off)

calcTrend(c, ef, es) =>
    ef > es and c > ef ? 1 : ef < es and c < ef ? -1 : 0

trend1 = calcTrend(c1, ef1, es1)
trend2 = calcTrend(c2, ef2, es2)
trend3 = calcTrend(c3, ef3, es3)
trend4 = calcTrend(c4, ef4, es4)
trend5 = calcTrend(c5, ef5, es5)

mtfScore = trend1 + trend2 + trend3 + trend4 + trend5
mtfBullish = mtfScore >= 3
mtfBearish = mtfScore <= -3
htfBullish = trend3 == 1
htfBearish = trend3 == -1
m15Bullish = trend2 == 1
m15Bearish = trend2 == -1

// LTF Confirmation
[ltfClose, ltfOpen, ltfHigh, ltfLow] = request.security(syminfo.tickerid, ltfConfirmTF, [close, open, high, low], lookahead=barmerge.lookahead_off)

ltfBody = math.abs(ltfClose - ltfOpen)
ltfUpperWick = ltfHigh - math.max(ltfClose, ltfOpen)
ltfLowerWick = math.min(ltfClose, ltfOpen) - ltfLow

ltfBullishPin = ltfBody > pipSize * 0.5 and ltfLowerWick > ltfBody * 2 and ltfUpperWick < ltfBody
ltfBearishPin = ltfBody > pipSize * 0.5 and ltfUpperWick > ltfBody * 2 and ltfLowerWick < ltfBody
ltfBullishEngulf = ltfClose > ltfOpen and ltfClose > ltfHigh[1]
ltfBearishEngulf = ltfClose < ltfOpen and ltfClose < ltfLow[1]

ltfBullishTrigger = ltfBullishPin or ltfBullishEngulf or (ltfClose > ltfOpen and ltfBody > pipSize)
ltfBearishTrigger = ltfBearishPin or ltfBearishEngulf or (ltfClose < ltfOpen and ltfBody > pipSize)

// ═══════════════════════════════════════════════════════════════════════════
// 🏗️ STRUCTURE
// ═══════════════════════════════════════════════════════════════════════════

swingHigh = ta.pivothigh(high, swingLength, swingLength)
swingLow = ta.pivotlow(low, swingLength, swingLength)

// v8.5 G1: fast (3,3) pivot for tight scalp SL anchoring
fastSwingHigh = ta.pivothigh(high, fastSwingLen, fastSwingLen)
fastSwingLow = ta.pivotlow(low, fastSwingLen, fastSwingLen)

var float lastSwingHigh = na
var float lastSwingLow = na
var float lastFastSwingHigh = na
var float lastFastSwingLow = na

if not na(swingHigh)
    lastSwingHigh := swingHigh
if not na(swingLow)
    lastSwingLow := swingLow
if not na(fastSwingHigh)
    lastFastSwingHigh := fastSwingHigh
if not na(fastSwingLow)
    lastFastSwingLow := fastSwingLow

bullishBOS = useBOS and not na(lastSwingHigh) and close > lastSwingHigh and close[1] <= lastSwingHigh
bearishBOS = useBOS and not na(lastSwingLow) and close < lastSwingLow and close[1] >= lastSwingLow

var int trendDir = 0
bullishCHoCH = useCHoCH and trendDir == -1 and not na(lastSwingHigh) and close > lastSwingHigh
bearishCHoCH = useCHoCH and trendDir == 1 and not na(lastSwingLow) and close < lastSwingLow

if bullishCHoCH or bullishBOS
    trendDir := 1
if bearishCHoCH or bearishBOS
    trendDir := -1

// v8.5 UI: declutter — only plot FIRST bar of break (not consecutive), no text overlay
firstBullBOS = bullishBOS and not bullishBOS[1]
firstBearBOS = bearishBOS and not bearishBOS[1]
firstBullCHoCH = bullishCHoCH and not bullishCHoCH[1]
firstBearCHoCH = bearishCHoCH and not bearishCHoCH[1]
plotshape(firstBullBOS, title="Bull BOS", style=shape.triangleup, location=location.belowbar, color=CLR_BULL, size=size.tiny)
plotshape(firstBearBOS, title="Bear BOS", style=shape.triangledown, location=location.abovebar, color=CLR_BEAR, size=size.tiny)
plotshape(firstBullCHoCH, title="Bull CHoCH", style=shape.diamond, location=location.belowbar, color=CLR_CYAN, size=size.tiny, text="CH", textcolor=CLR_CYAN)
plotshape(firstBearCHoCH, title="Bear CHoCH", style=shape.diamond, location=location.abovebar, color=CLR_PURPLE, size=size.tiny, text="CH", textcolor=CLR_PURPLE)

// ═══════════════════════════════════════════════════════════════════════════
// 💧 SWEEP
// ═══════════════════════════════════════════════════════════════════════════

// v8.3: exclude current bar from lookback so sweep is measured vs PRIOR extremes
recentHigh = ta.highest(high[1], sweepLookback)
recentLow = ta.lowest(low[1], sweepLookback)
bullishSweep = useLiquiditySweep and low < recentLow and close > recentLow and close > open
bearishSweep = useLiquiditySweep and high > recentHigh and close < recentHigh and close < open

// ═══════════════════════════════════════════════════════════════════════════
// 💎 FVG & OB
// ═══════════════════════════════════════════════════════════════════════════

bullishFVG = useFVG and low > high[2] and (low - high[2]) > fvgMinSize * pipSize
bearishFVG = useFVG and high < low[2] and (low[2] - high) > fvgMinSize * pipSize

var array<box> bullFVGBoxes = array.new<box>()
var array<float> bullFVGTops = array.new<float>()
var array<float> bullFVGBots = array.new<float>()
var array<box> bearFVGBoxes = array.new<box>()
var array<float> bearFVGTops = array.new<float>()
var array<float> bearFVGBots = array.new<float>()

if bullishFVG and showZones
    fTop = low
    fBot = high[2]
    b = box.new(left=bar_index[2], top=fTop, right=bar_index + 10, bottom=fBot, bgcolor=color.new(CLR_BULL, 88), border_color=color.new(CLR_BULL, 60), border_width=1)
    array.push(bullFVGBoxes, b)
    array.push(bullFVGTops, fTop)
    array.push(bullFVGBots, fBot)
    if array.size(bullFVGBoxes) > maxZones
        box.delete(array.shift(bullFVGBoxes))
        array.shift(bullFVGTops)
        array.shift(bullFVGBots)

if bearishFVG and showZones
    fTop = low[2]
    fBot = high
    b = box.new(left=bar_index[2], top=fTop, right=bar_index + 10, bottom=fBot, bgcolor=color.new(CLR_BEAR, 88), border_color=color.new(CLR_BEAR, 60), border_width=1)
    array.push(bearFVGBoxes, b)
    array.push(bearFVGTops, fTop)
    array.push(bearFVGBots, fBot)
    if array.size(bearFVGBoxes) > maxZones
        box.delete(array.shift(bearFVGBoxes))
        array.shift(bearFVGTops)
        array.shift(bearFVGBots)

if expireMitigatedZones and array.size(bullFVGBoxes) > 0
    i = array.size(bullFVGBoxes) - 1
    while i >= 0
        if close < array.get(bullFVGBots, i)
            box.delete(array.get(bullFVGBoxes, i))
            array.remove(bullFVGBoxes, i)
            array.remove(bullFVGTops, i)
            array.remove(bullFVGBots, i)
        i := i - 1

if expireMitigatedZones and array.size(bearFVGBoxes) > 0
    i = array.size(bearFVGBoxes) - 1
    while i >= 0
        if close > array.get(bearFVGTops, i)
            box.delete(array.get(bearFVGBoxes, i))
            array.remove(bearFVGBoxes, i)
            array.remove(bearFVGTops, i)
            array.remove(bearFVGBots, i)
        i := i - 1

priceInBullFVG = false
priceInBearFVG = false

if array.size(bullFVGBoxes) > 0
    for i = 0 to array.size(bullFVGBoxes) - 1
        if close >= array.get(bullFVGBots, i) and close <= array.get(bullFVGTops, i)
            priceInBullFVG := true
            break

if array.size(bearFVGBoxes) > 0
    for i = 0 to array.size(bearFVGBoxes) - 1
        if close >= array.get(bearFVGBots, i) and close <= array.get(bearFVGTops, i)
            priceInBearFVG := true
            break

// v8.5 G2: REAL INSTITUTIONAL ORDER BLOCK
// Trigger: displacement bar (close beyond prior extreme by min pips).
// Anchor:  LAST OPPOSITE-COLOR candle before that displacement (true OB doctrine).
// v8.4 used engulf-misnamed OB (current candle's own range = wrong).
bullDisplacement = useOB and close > high[1] and (close - close[1]) > obMinDisplacementPips * pipSize
bearDisplacement = useOB and close < low[1] and (close[1] - close) > obMinDisplacementPips * pipSize

// Find index of last opposite candle within lookback. Returns na if none.
findOppCandleIdx(bool wantBearish) =>
    int found = na
    for i = 1 to obLookbackBars
        c_i = close[i]
        o_i = open[i]
        isBear = c_i < o_i
        isBull = c_i > o_i
        match = wantBearish ? isBear : isBull
        if match and na(found)
            found := i
    found

var array<box> bullOBBoxes = array.new<box>()
var array<float> bullOBTops = array.new<float>()
var array<float> bullOBBots = array.new<float>()
var array<box> bearOBBoxes = array.new<box>()
var array<float> bearOBTops = array.new<float>()
var array<float> bearOBBots = array.new<float>()

// Bull OB = last bearish candle anchor when bullish displacement occurs
bullishOB_signal = false
bearishOB_signal = false
if bullDisplacement and useRealOB
    obIdx = findOppCandleIdx(true)
    if not na(obIdx)
        obTop = high[obIdx]
        obBot = low[obIdx]
        bullishOB_signal := true
        if showZones
            b = box.new(left=bar_index[obIdx], top=obTop, right=bar_index + 15, bottom=obBot, bgcolor=color.new(CLR_ACCENT, 85), border_color=color.new(CLR_ACCENT, 40), border_width=2)
            array.push(bullOBBoxes, b)
            array.push(bullOBTops, obTop)
            array.push(bullOBBots, obBot)
            if array.size(bullOBBoxes) > maxZones
                box.delete(array.shift(bullOBBoxes))
                array.shift(bullOBTops)
                array.shift(bullOBBots)

if bearDisplacement and useRealOB
    obIdx = findOppCandleIdx(false)
    if not na(obIdx)
        obTop = high[obIdx]
        obBot = low[obIdx]
        bearishOB_signal := true
        if showZones
            b = box.new(left=bar_index[obIdx], top=obTop, right=bar_index + 15, bottom=obBot, bgcolor=color.new(CLR_ORANGE, 85), border_color=color.new(CLR_ORANGE, 40), border_width=2)
            array.push(bearOBBoxes, b)
            array.push(bearOBTops, obTop)
            array.push(bearOBBots, obBot)
            if array.size(bearOBBoxes) > maxZones
                box.delete(array.shift(bearOBBoxes))
                array.shift(bearOBTops)
                array.shift(bearOBBots)

if expireMitigatedZones and array.size(bullOBBoxes) > 0
    i = array.size(bullOBBoxes) - 1
    while i >= 0
        if close < array.get(bullOBBots, i)
            box.delete(array.get(bullOBBoxes, i))
            array.remove(bullOBBoxes, i)
            array.remove(bullOBTops, i)
            array.remove(bullOBBots, i)
        i := i - 1

if expireMitigatedZones and array.size(bearOBBoxes) > 0
    i = array.size(bearOBBoxes) - 1
    while i >= 0
        if close > array.get(bearOBTops, i)
            box.delete(array.get(bearOBBoxes, i))
            array.remove(bearOBBoxes, i)
            array.remove(bearOBTops, i)
            array.remove(bearOBBots, i)
        i := i - 1

priceInBullOB = false
priceInBearOB = false

if array.size(bullOBBoxes) > 0
    for i = 0 to array.size(bullOBBoxes) - 1
        if close >= array.get(bullOBBots, i) and close <= array.get(bullOBTops, i)
            priceInBullOB := true
            break

if array.size(bearOBBoxes) > 0
    for i = 0 to array.size(bearOBBoxes) - 1
        if close >= array.get(bearOBBots, i) and close <= array.get(bearOBTops, i)
            priceInBearOB := true
            break

// Asian / Judas
var float asianHighFinal = na
var float asianLowFinal = na

if not isAsianSession and isAsianSession[1] and not na(asianHigh)
    asianHighFinal := asianHigh
    asianLowFinal := asianLow

judasSwingBullish = useJudasSwing and isLondonKZ and not na(asianLowFinal) and low < asianLowFinal and close > asianLowFinal and close > open
judasSwingBearish = useJudasSwing and isLondonKZ and not na(asianHighFinal) and high > asianHighFinal and close < asianHighFinal and close < open

plotshape(judasSwingBullish, title="Judas Bull", style=shape.flag, location=location.belowbar, color=CLR_GOLD, size=size.small, text="JUDAS", textcolor=CLR_GOLD)
plotshape(judasSwingBearish, title="Judas Bear", style=shape.flag, location=location.abovebar, color=CLR_GOLD, size=size.small, text="JUDAS", textcolor=CLR_GOLD)

// ═══════════════════════════════════════════════════════════════════════════
// 🎯 v8.5 S1 — NY KILL-ZONE SWEEP OF ASIAN HIGH/LOW
// ─────────────────────────────────────────────────────────────────────────
// Classic ICT continuation: NY opens, runs Asian range, reverses back inside.
// Judas covered London — S1 extends same logic into NY KZ.
// ═══════════════════════════════════════════════════════════════════════════
nySweepBullish = useAsianSweepNY and isNYKZ and not na(asianLowFinal) and low < asianLowFinal and close > asianLowFinal and close > open
nySweepBearish = useAsianSweepNY and isNYKZ and not na(asianHighFinal) and high > asianHighFinal and close < asianHighFinal and close < open
plotshape(nySweepBullish, title="NY Sweep Bull", style=shape.flag, location=location.belowbar, color=CLR_CYAN, size=size.small, text="S1", textcolor=CLR_CYAN)
plotshape(nySweepBearish, title="NY Sweep Bear", style=shape.flag, location=location.abovebar, color=CLR_CYAN, size=size.small, text="S1", textcolor=CLR_CYAN)

// ═══════════════════════════════════════════════════════════════════════════
// 🎯 v8.5 S2 — EQH/EQL LIQUIDITY POOL + GRAB
// ─────────────────────────────────────────────────────────────────────────
// Multi-pivot equal-level cluster. Grab = wick beyond cluster + reclaim.
// Pool of resting stops above EQH / below EQL = high-probability sweep target.
// ═══════════════════════════════════════════════════════════════════════════
// v8.5 fix: declare local pivots here — pricePivotHigh/Low live in indicator
// section below; avoid forward reference by computing fresh pivots in-place.
s2_ph = ta.pivothigh(high, 5, 5)
s2_pl = ta.pivotlow(low, 5, 5)
var array<float> ph_levels = array.new<float>(0)
var array<float> pl_levels = array.new<float>(0)
if not na(s2_ph)
    array.push(ph_levels, s2_ph)
    if array.size(ph_levels) > 10
        array.shift(ph_levels)
if not na(s2_pl)
    array.push(pl_levels, s2_pl)
    if array.size(pl_levels) > 10
        array.shift(pl_levels)

// Count equal touches near most recent pivot high/low
countTouchesNear(array<float> arr, float ref, float tol) =>
    int n = 0
    if array.size(arr) > 0
        for i = 0 to array.size(arr) - 1
            if math.abs(array.get(arr, i) - ref) <= tol
                n := n + 1
    n

eqhTol = eqhEqlTolPips * pipSize
eqhRef = array.size(ph_levels) > 0 ? array.get(ph_levels, array.size(ph_levels) - 1) : na
eqlRef = array.size(pl_levels) > 0 ? array.get(pl_levels, array.size(pl_levels) - 1) : na
eqhTouches = na(eqhRef) ? 0 : countTouchesNear(ph_levels, eqhRef, eqhTol)
eqlTouches = na(eqlRef) ? 0 : countTouchesNear(pl_levels, eqlRef, eqhTol)

hasEQH = useEQHEQL and eqhTouches >= eqhEqlMinTouches and not na(eqhRef)
hasEQL = useEQHEQL and eqlTouches >= eqhEqlMinTouches and not na(eqlRef)

// Grab trigger: wick beyond cluster, close back inside
eqhGrabBearish = hasEQH and high > eqhRef + eqhTol and close < eqhRef and close < open
eqlGrabBullish = hasEQL and low < eqlRef - eqhTol and close > eqlRef and close > open

plotshape(eqlGrabBullish, title="EQL Grab Bull", style=shape.diamond, location=location.belowbar, color=CLR_PURPLE, size=size.small, text="S2", textcolor=CLR_PURPLE)
plotshape(eqhGrabBearish, title="EQH Grab Bear", style=shape.diamond, location=location.abovebar, color=CLR_PURPLE, size=size.small, text="S2", textcolor=CLR_PURPLE)

// ═══════════════════════════════════════════════════════════════════════════
// 🎯 v8.5 S3 — PDH/PDL SWEEP-RECLAIM
// ─────────────────────────────────────────────────────────────────────────
// Pierce prior-day high/low then close back inside. Classic stop-hunt fade.
// (prevDayHigh / prevDayLow defined later — forward reference via request.security
//  is fine since Pine evaluates declarations top-down each bar.)
// ═══════════════════════════════════════════════════════════════════════════
pdhRef_S3 = request.security(syminfo.tickerid, "D", high[1], lookahead=barmerge.lookahead_off)
pdlRef_S3 = request.security(syminfo.tickerid, "D", low[1],  lookahead=barmerge.lookahead_off)
pdhSweepBearish = usePDsweepReclaim and not na(pdhRef_S3) and high > pdhRef_S3 and close < pdhRef_S3 and close < open
pdlSweepBullish = usePDsweepReclaim and not na(pdlRef_S3) and low  < pdlRef_S3 and close > pdlRef_S3 and close > open
plotshape(pdlSweepBullish, title="PDL Reclaim Bull", style=shape.xcross, location=location.belowbar, color=CLR_GOLD, size=size.small, text="S3", textcolor=CLR_GOLD)
plotshape(pdhSweepBearish, title="PDH Reclaim Bear", style=shape.xcross, location=location.abovebar, color=CLR_GOLD, size=size.small, text="S3", textcolor=CLR_GOLD)

// Active sniper-setup flags (consumed by scoring + setup-tag)
sniperBullActive = nySweepBullish or eqlGrabBullish or pdlSweepBullish
sniperBearActive = nySweepBearish or eqhGrabBearish or pdhSweepBearish

// Premium/Discount (renamed for clarity)
pdHigh = ta.highest(high, premDiscLookback)
pdLow = ta.lowest(low, premDiscLookback)
pdMid = (pdHigh + pdLow) / 2
pdRange = pdHigh - pdLow

inPremiumZone = usePremDisc and close > pdMid
inDiscountZone = usePremDisc and close < pdMid

// 🐛 FIX #13: OTE now uses ACTUAL impulse legs (not 50-bar range)
// Impulse legs are computed in the Refined Golden Zone section below,
// and OTE zones are computed there using the same impulse pivots.

// CVD with daily reset
deltaVolume = close > open ? volume : close < open ? -volume : 0
var float cvd = 0.0
var int lastResetDay = -1
var int cvdBarsSinceReset = 0

// v8.5 B7: day boundary tied to Asia/Dhaka (matches user's session/day filter TZ).
// v8.4 used time("D") chart-TZ — caused tradesToday/dailyPnL reset off by 6-8h.
isNewDay = ta.change(dayofmonth(time, "Asia/Dhaka")) != 0

if isNewDay
    cvd := 0.0
    cvdBarsSinceReset := 0

cvd := cvd + deltaVolume
cvdBarsSinceReset := cvdBarsSinceReset + 1

// v8.4 H1: compute SMA unconditionally (Pine series funcs must run every bar)
cvdSMARaw = ta.sma(cvd, 20)
cvdSMA = cvdBarsSinceReset >= 20 ? cvdSMARaw : cvd
cvdBullish = cvd > cvdSMA and cvd > cvd[1]
cvdBearish = cvd < cvdSMA and cvd < cvd[1]

// Indicators
rsi = ta.rsi(close, rsiLength)
rsiBullish = rsi < 30
rsiBearish = rsi > 70

rsiPivotHigh = ta.pivothigh(rsi, 5, 5)
rsiPivotLow = ta.pivotlow(rsi, 5, 5)
pricePivotHigh = ta.pivothigh(high, 5, 5)
pricePivotLow = ta.pivotlow(low, 5, 5)

var float lastRsiHigh = na
var float lastRsiLow = na
var float lastPriceHigh = na
var float lastPriceLow = na

if not na(rsiPivotHigh)
    lastRsiHigh := rsiPivotHigh
if not na(rsiPivotLow)
    lastRsiLow := rsiPivotLow
if not na(pricePivotHigh)
    lastPriceHigh := pricePivotHigh
if not na(pricePivotLow)
    lastPriceLow := pricePivotLow

bearishDivergence = useRSI and not na(pricePivotHigh) and not na(lastPriceHigh) and not na(rsiPivotHigh) and not na(lastRsiHigh) and pricePivotHigh > lastPriceHigh and rsiPivotHigh < lastRsiHigh
bullishDivergence = useRSI and not na(pricePivotLow) and not na(lastPriceLow) and not na(rsiPivotLow) and not na(lastRsiLow) and pricePivotLow < lastPriceLow and rsiPivotLow > lastRsiLow

vwapValue = ta.vwap(hlc3)
priceAboveVWAP = useVWAP and close > vwapValue
priceBelowVWAP = useVWAP and close < vwapValue

// 🐛 FIX #11: lookahead_off (no more repainting in backtest!)
prevDayHigh = request.security(syminfo.tickerid, "D", high[1], lookahead=barmerge.lookahead_off)
prevDayLow = request.security(syminfo.tickerid, "D", low[1], lookahead=barmerge.lookahead_off)
prevDayClose = request.security(syminfo.tickerid, "D", close[1], lookahead=barmerge.lookahead_off)

plot(usePDArray ? prevDayHigh : na, "PDH", color=color.new(CLR_BEAR, 30), linewidth=2, style=plot.style_linebr)
plot(usePDArray ? prevDayLow : na, "PDL", color=color.new(CLR_BULL, 30), linewidth=2, style=plot.style_linebr)
plot(usePDArray ? prevDayClose : na, "PDC", color=color.new(CLR_GOLD, 30), linewidth=1, style=plot.style_linebr)

// Pivots — also fixed to lookahead_off
dHigh = request.security(syminfo.tickerid, "D", high[1], lookahead=barmerge.lookahead_off)
dLow = request.security(syminfo.tickerid, "D", low[1], lookahead=barmerge.lookahead_off)
dClose = request.security(syminfo.tickerid, "D", close[1], lookahead=barmerge.lookahead_off)

pivotPP = (dHigh + dLow + dClose) / 3
pivotR1 = 2 * pivotPP - dLow
pivotS1 = 2 * pivotPP - dHigh
pivotR2 = pivotPP + (dHigh - dLow)
pivotS2 = pivotPP - (dHigh - dLow)

nearPivotSupport = usePivots and (math.abs(close - pivotS1) / close < 0.001 or math.abs(close - pivotS2) / close < 0.001)
nearPivotResistance = usePivots and (math.abs(close - pivotR1) / close < 0.001 or math.abs(close - pivotR2) / close < 0.001)

plot(usePivots ? pivotPP : na, "PP", color=color.new(CLR_GOLD, 0), linewidth=2, style=plot.style_circles)
plot(usePivots ? pivotR1 : na, "R1", color=color.new(CLR_BEAR, 50), linewidth=1)
plot(usePivots ? pivotS1 : na, "S1", color=color.new(CLR_BULL, 50), linewidth=1)

fibHighest = ta.highest(high, fibLength)
fibLowest = ta.lowest(low, fibLength)
fibRange = fibHighest - fibLowest
fib500 = fibHighest - fibRange * 0.500
fib618 = fibHighest - fibRange * 0.618
fib786 = fibHighest - fibRange * 0.786

inGoldenZone = useFibRetracement and close >= fib786 and close <= fib500
inBullGoldenZone = inGoldenZone and htfBullish
inBearGoldenZone = inGoldenZone and htfBearish

bullEngulfing = close > open and close[1] < open[1] and close > open[1] and open < close[1]
bearEngulfing = close < open and close[1] > open[1] and close < open[1] and open > close[1]

bodySize = math.abs(close - open)
upperWick = high - math.max(close, open)
lowerWick = math.min(close, open) - low

bullPinBar = bodySize > pipSize * 0.5 and lowerWick > bodySize * 2 and upperWick < bodySize
bearPinBar = bodySize > pipSize * 0.5 and upperWick > bodySize * 2 and lowerWick < bodySize

bullCandle = bullEngulfing or bullPinBar
bearCandle = bearEngulfing or bearPinBar

volatilityRatio = na(atrAvg) or atrAvg == 0 ? 1.0 : atr / atrAvg
volatilityOK = not useVolFilter or (volatilityRatio >= minATRMultiplier and volatilityRatio <= maxATRMultiplier)

// ═══════════════════════════════════════════════════════════════════════════
// 🆕 SECTION A — AUTO TRENDLINES
// ═══════════════════════════════════════════════════════════════════════════

tlSwingHigh = ta.pivothigh(high, trendlinePivotLen, trendlinePivotLen)
tlSwingLow = ta.pivotlow(low, trendlinePivotLen, trendlinePivotLen)

var array<float> swingHighPrices = array.new<float>(0)
var array<int> swingHighBars = array.new<int>(0)
var array<float> swingLowPrices = array.new<float>(0)
var array<int> swingLowBars = array.new<int>(0)

if not na(tlSwingHigh)
    array.push(swingHighPrices, tlSwingHigh)
    array.push(swingHighBars, bar_index - trendlinePivotLen)
    if array.size(swingHighPrices) > 10
        array.shift(swingHighPrices)
        array.shift(swingHighBars)

if not na(tlSwingLow)
    array.push(swingLowPrices, tlSwingLow)
    array.push(swingLowBars, bar_index - trendlinePivotLen)
    if array.size(swingLowPrices) > 10
        array.shift(swingLowPrices)
        array.shift(swingLowBars)

var line resistanceLine = na
var line supportLine = na
var label resistanceLbl = na
var label supportLbl = na

// v8.4 C5: draw resistance/support regardless of slope direction. Resistance =
// line through last 2 swing highs; support = line through last 2 swing lows.
// Both directions valuable: ascending resistance = wedge, descending support = falling channel.
if showTrendlines and barstate.islast
    if array.size(swingHighPrices) >= 2
        sh1p = array.get(swingHighPrices, array.size(swingHighPrices) - 1)
        sh1b = array.get(swingHighBars, array.size(swingHighBars) - 1)
        sh2p = array.get(swingHighPrices, array.size(swingHighPrices) - 2)
        sh2b = array.get(swingHighBars, array.size(swingHighBars) - 2)
        line.delete(resistanceLine)
        label.delete(resistanceLbl)
        slopeR = (sh1p - sh2p) / (sh1b - sh2b)
        projR = sh1p + slopeR * (bar_index + chartLabelOffset - sh1b)
        resistanceLine := line.new(sh2b, sh2p, bar_index + chartLabelOffset, projR, color=color.new(CLR_BEAR, 10), width=2, extend=extend.right)
        // v8.5 UI: X stagger -5 so RES TL doesn't collide with GZ/GANN labels at +35
        resistanceLbl := label.new(bar_index + chartLabelOffset - 5, projR, " RES TL ", style=label.style_label_left, color=CLR_LBL_TL_RES_BG, textcolor=CLR_WHITE, size=lblSizeChartMid)
    if array.size(swingLowPrices) >= 2
        sl1p = array.get(swingLowPrices, array.size(swingLowPrices) - 1)
        sl1b = array.get(swingLowBars, array.size(swingLowBars) - 1)
        sl2p = array.get(swingLowPrices, array.size(swingLowPrices) - 2)
        sl2b = array.get(swingLowBars, array.size(swingLowBars) - 2)
        line.delete(supportLine)
        label.delete(supportLbl)
        slopeS = (sl1p - sl2p) / (sl1b - sl2b)
        projS = sl1p + slopeS * (bar_index + chartLabelOffset - sl1b)
        supportLine := line.new(sl2b, sl2p, bar_index + chartLabelOffset, projS, color=color.new(CLR_BULL, 10), width=2, extend=extend.right)
        supportLbl := label.new(bar_index + chartLabelOffset - 5, projS, " SUP TL ", style=label.style_label_left, color=CLR_LBL_TL_SUP_BG, textcolor=CLR_WHITE, size=lblSizeChartMid)

trendlineBullBreak = false
trendlineBearBreak = false
if not na(resistanceLine)
    rPrice = line.get_price(resistanceLine, bar_index)
    rPricePrv = line.get_price(resistanceLine, bar_index - 1)
    trendlineBullBreak := close > rPrice and close[1] <= rPricePrv
if not na(supportLine)
    sPrice = line.get_price(supportLine, bar_index)
    sPricePrv = line.get_price(supportLine, bar_index - 1)
    trendlineBearBreak := close < sPrice and close[1] >= sPricePrv

plotshape(trendlineBullBreak, title="TL Break Bull", style=shape.arrowup, location=location.belowbar, color=CLR_BULL, size=size.small)
plotshape(trendlineBearBreak, title="TL Break Bear", style=shape.arrowdown, location=location.abovebar, color=CLR_BEAR, size=size.small)

// ═══════════════════════════════════════════════════════════════════════════
// 🆕 SECTION B — GANN BOX
// ═══════════════════════════════════════════════════════════════════════════

gannHigh = ta.highest(high, gannLookback)
gannLow = ta.lowest(low, gannLookback)
gannHighBar = ta.highestbars(high, gannLookback)
gannLowBar = ta.lowestbars(low, gannLookback)
gannRange = gannHigh - gannLow

gann_0 = gannLow
gann_125 = gannLow + gannRange * 0.125
gann_25 = gannLow + gannRange * 0.250
gann_375 = gannLow + gannRange * 0.375
gann_50 = gannLow + gannRange * 0.500
gann_625 = gannLow + gannRange * 0.625
gann_75 = gannLow + gannRange * 0.750
gann_875 = gannLow + gannRange * 0.875
gann_100 = gannHigh

var line gannL0 = na
var line gannL125 = na
var line gannL25 = na
var line gannL375 = na
var line gannL50 = na
var line gannL625 = na
var line gannL75 = na
var line gannL875 = na
var line gannL100 = na
var box gannBox = na
var label gann50Lbl = na

if showGannBox and barstate.islast
    line.delete(gannL0)
    line.delete(gannL125)
    line.delete(gannL25)
    line.delete(gannL375)
    line.delete(gannL50)
    line.delete(gannL625)
    line.delete(gannL75)
    line.delete(gannL875)
    line.delete(gannL100)
    box.delete(gannBox)
    label.delete(gann50Lbl)
    leftBar = bar_index + math.min(gannHighBar, gannLowBar)
    rightBar = bar_index + gannProjectBars
    gannBox := box.new(left=leftBar, top=gann_100, right=rightBar, bottom=gann_0, bgcolor=color.new(CLR_PURPLE, 95), border_color=color.new(CLR_PURPLE, 40), border_width=2)
    gannL0 := line.new(leftBar, gann_0, rightBar, gann_0, color=color.new(CLR_BULL, 30), width=1, extend=extend.right)
    gannL125 := line.new(leftBar, gann_125, rightBar, gann_125, color=color.new(CLR_PURPLE, 70), width=1, style=line.style_dotted, extend=extend.right)
    gannL25 := line.new(leftBar, gann_25, rightBar, gann_25, color=color.new(CLR_PURPLE, 50), width=1, style=line.style_dashed, extend=extend.right)
    gannL375 := line.new(leftBar, gann_375, rightBar, gann_375, color=color.new(CLR_PURPLE, 70), width=1, style=line.style_dotted, extend=extend.right)
    gannL50 := line.new(leftBar, gann_50, rightBar, gann_50, color=CLR_GOLD, width=2, extend=extend.right)
    gannL625 := line.new(leftBar, gann_625, rightBar, gann_625, color=color.new(CLR_PURPLE, 70), width=1, style=line.style_dotted, extend=extend.right)
    gannL75 := line.new(leftBar, gann_75, rightBar, gann_75, color=color.new(CLR_PURPLE, 50), width=1, style=line.style_dashed, extend=extend.right)
    gannL875 := line.new(leftBar, gann_875, rightBar, gann_875, color=color.new(CLR_PURPLE, 70), width=1, style=line.style_dotted, extend=extend.right)
    gannL100 := line.new(leftBar, gann_100, rightBar, gann_100, color=color.new(CLR_BEAR, 30), width=1, extend=extend.right)
    // v8.4 U3: bigger label, solid bright gold + black text, offset upward to avoid GZ overlap
    // v8.5 UI: X stagger +10 so GANN sits right of GZ labels
    gann50Lbl := label.new(rightBar + 10, gann_50, " GANN 50% ", style=label.style_label_left, color=CLR_LBL_GANN_BG, textcolor=CLR_LBL_GANN_TX, size=lblSizeChartMid)

// v8.4 C7: bound within the gann box so off-box price doesn't trigger
inGannLowerHalf = close < gann_50 and close >= gann_0
inGannUpperHalf = close > gann_50 and close <= gann_100
nearGann50 = math.abs(close - gann_50) < atr * 0.5

// ═══════════════════════════════════════════════════════════════════════════
// 🆕 SECTION C — REFINED GOLDEN ZONE (used by FIX #13 OTE too)
// ═══════════════════════════════════════════════════════════════════════════

// v8.5 B5: pivot length too long for scalp horizon — was lookback both sides (5h on 5m).
// Use fixed short pivot (5,5) so GZ refreshes within scalping timeframe.
gzPivLen = math.min(5, goldenZoneLookback)
gzSwingHigh = ta.pivothigh(high, gzPivLen, gzPivLen)
gzSwingLow = ta.pivotlow(low, gzPivLen, gzPivLen)

var array<float> impHighArr = array.new<float>(0)
var array<int> impHighBarArr = array.new<int>(0)
var array<float> impLowArr = array.new<float>(0)
var array<int> impLowBarArr = array.new<int>(0)

if not na(gzSwingHigh)
    array.push(impHighArr, gzSwingHigh)
    array.push(impHighBarArr, bar_index - gzPivLen)
    if array.size(impHighArr) > 5
        array.shift(impHighArr)
        array.shift(impHighBarArr)

if not na(gzSwingLow)
    array.push(impLowArr, gzSwingLow)
    array.push(impLowBarArr, bar_index - gzPivLen)
    if array.size(impLowArr) > 5
        array.shift(impLowArr)
        array.shift(impLowBarArr)

hasImpulse = array.size(impHighArr) > 0 and array.size(impLowArr) > 0
impulseHigh = hasImpulse ? array.get(impHighArr, array.size(impHighArr) - 1) : 0.0
impulseLow = hasImpulse ? array.get(impLowArr, array.size(impLowArr) - 1) : 0.0
impulseHighBar = hasImpulse ? array.get(impHighBarArr, array.size(impHighBarArr) - 1) : 0
impulseLowBar = hasImpulse ? array.get(impLowBarArr, array.size(impLowBarArr) - 1) : 0

// v8.4 C6: validate consecutive impulse (pivots not too far apart — scalp horizon)
maxImpulseBars = goldenZoneLookback * 5
impulseBarDist = math.abs(impulseHighBar - impulseLowBar)
validImpulse = hasImpulse and impulseBarDist <= maxImpulseBars

bullishImpulse = validImpulse and impulseHighBar > impulseLowBar
bearishImpulse = validImpulse and impulseLowBar > impulseHighBar

// 🐛 FIX #13: OTE retracement on the actual impulse leg
impRange = bullishImpulse or bearishImpulse ? math.abs(impulseHigh - impulseLow) : 0.0
oteHighBull = bullishImpulse ? impulseHigh - impRange * 0.62 : na
oteLowBull = bullishImpulse ? impulseHigh - impRange * 0.79 : na
oteHighBear = bearishImpulse ? impulseLow + impRange * 0.79 : na
oteLowBear = bearishImpulse ? impulseLow + impRange * 0.62 : na

inBullOTE = useOTE and bullishImpulse and not na(oteLowBull) and close >= oteLowBull and close <= oteHighBull
inBearOTE = useOTE and bearishImpulse and not na(oteLowBear) and close >= oteLowBear and close <= oteHighBear

gzBullTop = bullishImpulse ? impulseHigh - (impulseHigh - impulseLow) * 0.618 : na
gzBullBottom = bullishImpulse ? impulseHigh - (impulseHigh - impulseLow) * 0.786 : na
gzBearTop = bearishImpulse ? impulseLow + (impulseHigh - impulseLow) * 0.786 : na
gzBearBottom = bearishImpulse ? impulseLow + (impulseHigh - impulseLow) * 0.618 : na

var box gzBullBox = na
var box gzBearBox = na
var label gzBullLbl = na
var label gzBearLbl = na

if showGoldenZone and barstate.islast
    box.delete(gzBullBox)
    box.delete(gzBearBox)
    label.delete(gzBullLbl)
    label.delete(gzBearLbl)
    if bullishImpulse and not na(gzBullTop)
        gzBullBox := box.new(left=impulseHighBar, top=gzBullTop, right=bar_index + chartLabelOffset, bottom=gzBullBottom, bgcolor=color.new(CLR_GOLD, 75), border_color=CLR_GOLD, border_width=2)
        // v8.4 U1: solid gold + near-black text — high contrast
        gzBullLbl := label.new(bar_index + chartLabelOffset + 5, (gzBullTop + gzBullBottom) / 2, " GZ BUY ", style=label.style_label_left, color=CLR_LBL_GZ_BUY_BG, textcolor=CLR_LBL_GZ_BUY_TX, size=lblSizeChartMid)
    if bearishImpulse and not na(gzBearTop)
        gzBearBox := box.new(left=impulseLowBar, top=gzBearTop, right=bar_index + chartLabelOffset, bottom=gzBearBottom, bgcolor=color.new(CLR_PINK, 75), border_color=CLR_PINK, border_width=2)
        // v8.4 U1: pink bg now uses BLACK text (was white on pink = unreadable)
        gzBearLbl := label.new(bar_index + chartLabelOffset + 5, (gzBearTop + gzBearBottom) / 2, " GZ SELL ", style=label.style_label_left, color=CLR_LBL_GZ_SELL_BG, textcolor=CLR_LBL_GZ_SELL_TX, size=lblSizeChartMid)

priceInRefinedBullGZ = bullishImpulse and not na(gzBullTop) and close <= gzBullTop and close >= gzBullBottom
priceInRefinedBearGZ = bearishImpulse and not na(gzBearTop) and close <= gzBearTop and close >= gzBearBottom

// ═══════════════════════════════════════════════════════════════════════════
// ⚖️ WEIGHTED SCORING — FIX #14: maxScore auto-computed
// ═══════════════════════════════════════════════════════════════════════════

int bullScore = 0
int bearScore = 0

// Each scoring block adds (contribution, max possible) to the score
// We track maxScore by summing every potential contribution

// HTF
if htfBullish
    bullScore := bullScore + htfWeight
if htfBearish
    bearScore := bearScore + htfWeight
// M15
if m15Bullish
    bullScore := bullScore + 2
if m15Bearish
    bearScore := bearScore + 2
// Structure
if bullishBOS or bullishCHoCH
    bullScore := bullScore + structureWeight
if bearishBOS or bearishCHoCH
    bearScore := bearScore + structureWeight
// SMC
if priceInBullFVG or priceInBullOB
    bullScore := bullScore + smcWeight
if priceInBearFVG or priceInBearOB
    bearScore := bearScore + smcWeight
// GZ / OTE
if inBullGoldenZone or inBullOTE
    bullScore := bullScore + otherWeight
if inBearGoldenZone or inBearOTE
    bearScore := bearScore + otherWeight
// Sweep / Judas
if bullishSweep or judasSwingBullish
    bullScore := bullScore + otherWeight
if bearishSweep or judasSwingBearish
    bearScore := bearScore + otherWeight
// PD
if inDiscountZone
    bullScore := bullScore + otherWeight
if inPremiumZone
    bearScore := bearScore + otherWeight
// Indicator stack
if bullishDivergence or rsiBullish or priceAboveVWAP or nearPivotSupport
    bullScore := bullScore + otherWeight
if bearishDivergence or rsiBearish or priceBelowVWAP or nearPivotResistance
    bearScore := bearScore + otherWeight
// CVD
if cvdBullish
    bullScore := bullScore + otherWeight
if cvdBearish
    bearScore := bearScore + otherWeight
// Candle
if bullCandle
    bullScore := bullScore + otherWeight
if bearCandle
    bearScore := bearScore + otherWeight
// KZ bias
if useKillzoneBias and londonBias == 1 and isLondonKZ
    bullScore := bullScore + 1
if useKillzoneBias and londonBias == -1 and isLondonKZ
    bearScore := bearScore + 1
// v8.5 B19: EMA filter removed from scoring (double-counted via HTF/MTF calcTrend).
// Kept as plot-only context. Use HTF/MTF score contribution instead.
// (EMA filter input still respected as visualization toggle.)

// v8.5 S1/S2/S3 sniper setups (weight = sniperWeight, default 3)
if nySweepBullish or eqlGrabBullish or pdlSweepBullish
    bullScore := bullScore + sniperWeight
if nySweepBearish or eqhGrabBearish or pdhSweepBearish
    bearScore := bearScore + sniperWeight
// Refined GZ
if priceInRefinedBullGZ
    bullScore := bullScore + otherWeight
if priceInRefinedBearGZ
    bearScore := bearScore + otherWeight
// Gann 50%
if nearGann50 and inGannLowerHalf
    bullScore := bullScore + 1
if nearGann50 and inGannUpperHalf
    bearScore := bearScore + 1
// TL Break
if trendlineBullBreak
    bullScore := bullScore + 2
if trendlineBearBreak
    bearScore := bearScore + 2

// 🐛 FIX #14: maxScore reflects ALL scoring contributions (mutually exclusive per direction)
// HTF(htfWeight) + M15(2) + Structure(structureWeight) + SMC(smcWeight) + GZ/OTE(otherWeight)
// + Sweep/Judas(otherWeight) + PD(otherWeight) + IndStack(otherWeight) + CVD(otherWeight)
// + Candle(otherWeight) + KZ(1) + EMA(otherWeight) + RefinedGZ(otherWeight) + Gann(1) + TL(2)
// v8.5: removed EMA otherWeight contribution (-1×otherWeight), added sniperWeight
maxScore = htfWeight + 2 + structureWeight + smcWeight + (otherWeight * 7) + 1 + 1 + 2 + sniperWeight

totalScore = bullScore + bearScore
bullPct = totalScore > 0 ? bullScore / totalScore * 100 : 0
bearPct = totalScore > 0 ? bearScore / totalScore * 100 : 0
hasConflict = useConflictDetector and bullScore >= minWeightedScore and bearScore >= minWeightedScore and math.abs(bullPct - bearPct) < (100 - conflictThreshold)

gradeFromScore(score) =>
    pct = score / maxScore * 100
    pct >= 80 ? "A+" : pct >= 70 ? "A" : pct >= 60 ? "B+" : pct >= 50 ? "B" : pct >= 40 ? "C" : "D"

gradeColorFromScore(score) =>
    pct = score / maxScore * 100
    pct >= 70 ? CLR_BULL : pct >= 50 ? CLR_GOLD : pct >= 40 ? CLR_ORANGE : CLR_BEAR

bullGrade = gradeFromScore(bullScore)
bearGrade = gradeFromScore(bearScore)

getRRForGrade(grade) =>
    grade == "A+" ? rrAPlus : grade == "A" ? rrA : grade == "B+" ? rrB + 0.5 : grade == "B" ? rrB : grade == "C" ? rrC : 1.5

getSizeMultForGrade(grade) =>
    grade == "A+" ? sizeMultAPlus : grade == "A" ? sizeMultA : grade == "B+" ? sizeMultB + 0.2 : grade == "B" ? sizeMultB : grade == "C" ? sizeMultC : 0.3

// ═══════════════════════════════════════════════════════════════════════════
// 💰 RISK MANAGEMENT — FIX #15 (ta.change(time("D"))) + FIX #9 (proper close detection)
// ═══════════════════════════════════════════════════════════════════════════

var float dayStartEquity = strategy.equity
if isNewDay
    dayStartEquity := strategy.equity

dailyPnL = strategy.equity - dayStartEquity
dailyPnLPct = dayStartEquity > 0 ? (dailyPnL / dayStartEquity) * 100 : 0
dailyLossExceeded = useDailyLimit and dailyPnLPct <= -maxDailyLossPct

var int tradesToday = 0
if isNewDay
    tradesToday := 0

dailyTradeLimitOK = tradesToday < maxTradesPerDay

// 🐛 FIX #9: Track FULL position closure (not per exit-ID closure)
var bool wasInPosition = false
var float entryPositionEquity = na
var int consecutiveLosses = 0
var bool lastSignalWasLoss = false
var int lastSignalBar = na

inPosition = strategy.position_size != 0

// Capture equity at position open
if inPosition and not wasInPosition
    entryPositionEquity := strategy.equity

// v8.5 A1: per-trade MAE/MFE + R-multiple + setup-tag analytics
var array<float> analytics_R    = array.new<float>(0)
var array<float> analytics_MAE  = array.new<float>(0)
var array<float> analytics_MFE  = array.new<float>(0)
var array<string> analytics_tag = array.new<string>(0)
var array<string> analytics_grade = array.new<string>(0)
var array<int> analytics_winflag = array.new<int>(0)

var float trade_entry_price = na
var float trade_init_sl     = na
var bool  trade_is_long     = false
var float trade_mae         = 0.0  // max adverse excursion (price)
var float trade_mfe         = 0.0  // max favorable excursion (price)
var string trade_tag        = ""
var string trade_grade      = ""

// Capture on position open (entry-bar snapshot — captured separately in
// longCondition/shortCondition blocks below; here we just reset MAE/MFE)
if inPosition and not wasInPosition
    entryPositionEquity := strategy.equity
    trade_mae := 0.0
    trade_mfe := 0.0

// Live MAE/MFE update while in position
if inPosition and trackMAEMFE
    if trade_is_long
        adverse  = trade_entry_price - low
        favorable = high - trade_entry_price
        if adverse > trade_mae
            trade_mae := adverse
        if favorable > trade_mfe
            trade_mfe := favorable
    else
        adverse  = high - trade_entry_price
        favorable = trade_entry_price - low
        if adverse > trade_mae
            trade_mae := adverse
        if favorable > trade_mfe
            trade_mfe := favorable

// v8.5 B16: track consecutive wins so single fluke after losing streak doesn't reset
var int consecutiveWins = 0

// Detect full position closure
if wasInPosition and not inPosition
    tradePnL = strategy.equity - entryPositionEquity
    isWin = tradePnL > 0
    // Streak update
    if isWin
        consecutiveWins := consecutiveWins + 1
        // require 2 consecutive wins before clearing loss streak (whipsaw guard)
        if consecutiveWins >= 2
            consecutiveLosses := 0
        lastSignalWasLoss := false
    else
        consecutiveLosses := consecutiveLosses + 1
        consecutiveWins := 0
        lastSignalWasLoss := true
    // A1: log R-multiple, MAE/MFE, setup-tag
    if not na(trade_entry_price) and not na(trade_init_sl)
        riskPerUnit = trade_is_long ? (trade_entry_price - trade_init_sl) : (trade_init_sl - trade_entry_price)
        if riskPerUnit > 0
            realizedPriceDelta = math.abs(strategy.equity - entryPositionEquity) / (math.max(math.abs(strategy.position_size[1]), 1))
            rMult = (isWin ? 1 : -1) * realizedPriceDelta / riskPerUnit
            array.push(analytics_R, rMult)
            array.push(analytics_MAE, trade_mae / riskPerUnit)
            array.push(analytics_MFE, trade_mfe / riskPerUnit)
            array.push(analytics_tag, trade_tag)
            array.push(analytics_grade, trade_grade)
            array.push(analytics_winflag, isWin ? 1 : 0)
            if array.size(analytics_R) > 500
                array.shift(analytics_R)
                array.shift(analytics_MAE)
                array.shift(analytics_MFE)
                array.shift(analytics_tag)
                array.shift(analytics_grade)
                array.shift(analytics_winflag)
    // B20: cooldown counts from CLOSE, not entry (header v8.2 promised "entry AND close")
    lastSignalBar := bar_index

wasInPosition := inPosition

consecLossLimitOK = not useMaxLosses or consecutiveLosses < maxConsecLosses

var float peakEquity = strategy.initial_capital
if strategy.equity > peakEquity
    peakEquity := strategy.equity

equityDrawdownPct = peakEquity > 0 ? ((peakEquity - strategy.equity) / peakEquity) * 100 : 0
equityGuardOK = not useEquityGuard or equityDrawdownPct < maxDrawdownPct

riskCheckOK = not dailyLossExceeded and dailyTradeLimitOK and consecLossLimitOK and equityGuardOK

// 🐛 FIX #7: lastSignalBar also updates on entry (cooldown counts from entry)
barsSinceLastSignal = na(lastSignalBar) ? 9999 : bar_index - lastSignalBar
requiredCooldown = lastSignalWasLoss ? cooldownBars + cooldownAfterLoss : cooldownBars
cooldownOK = not useCooldown or barsSinceLastSignal >= requiredCooldown

// ═══════════════════════════════════════════════════════════════════════════
// 🎯 TWO-STAGE ENTRY (with HTF re-validation + fresh-open block)
// ═══════════════════════════════════════════════════════════════════════════

var bool pendingBullSignal = false
var bool pendingBearSignal = false
var int pendingBullBar = na
var int pendingBearBar = na

killZoneOK = not useKillZone or inKillZone

// v8.3 B7: candidate SL pre-computed via helper for gating
slDistAtr = atr * atrSLMultiplier
slBuf = slBufferPips * pipSize
minSLDistFloor = atr * 0.5

// v8.5 G1/B8: prefer fast (3,3) pivot for SL when available (tighter, fresher).
// Fallback to slow (swingLength) pivot if fast not yet formed.
slPivotLowRef  = useFastStructSL and not na(lastFastSwingLow)  ? lastFastSwingLow  : lastSwingLow
slPivotHighRef = useFastStructSL and not na(lastFastSwingHigh) ? lastFastSwingHigh : lastSwingHigh
longSLStructCand = na(slPivotLowRef) ? na : slPivotLowRef - slBuf
shortSLStructCand = na(slPivotHighRef) ? na : slPivotHighRef + slBuf

longUseStruct = useStructureSL and not na(longSLStructCand) and (close - longSLStructCand) >= minSLDistFloor
shortUseStruct = useStructureSL and not na(shortSLStructCand) and (shortSLStructCand - close) >= minSLDistFloor

longSLcand = longUseStruct ? longSLStructCand : close - slDistAtr
shortSLcand = shortUseStruct ? shortSLStructCand : close + slDistAtr

longSLpipsCand = (close - longSLcand) / pipSize
shortSLpipsCand = (shortSLcand - close) / pipSize
slDistOKLong = longSLpipsCand >= minSLpips and longSLpipsCand <= maxSLpips
slDistOKShort = shortSLpipsCand >= minSLpips and shortSLpipsCand <= maxSLpips

// v8.5 B3/B4: HARD gate vs HTF (no counter-trend longs/shorts). Optional MTF strict gate.
htfGateLong  = not requireHTFAlign or htfBullish
htfGateShort = not requireHTFAlign or htfBearish
mtfGateLong  = not requireMTFAlign or mtfBullish
mtfGateShort = not requireMTFAlign or mtfBearish

htfBullSetupReady = bullScore >= minWeightedScore and not hasConflict and killZoneOK and newsFilterOK and volatilityOK and riskCheckOK and dayFilterOK and spreadOK and cooldownOK and not freshSessionBlock and slDistOKLong and htfGateLong and mtfGateLong
htfBearSetupReady = bearScore >= minWeightedScore and not hasConflict and killZoneOK and newsFilterOK and volatilityOK and riskCheckOK and dayFilterOK and spreadOK and cooldownOK and not freshSessionBlock and slDistOKShort and htfGateShort and mtfGateShort

if useTwoStageEntry
    if htfBullSetupReady and not pendingBullSignal and strategy.position_size == 0
        pendingBullSignal := true
        pendingBullBar := bar_index
    if htfBearSetupReady and not pendingBearSignal and strategy.position_size == 0
        pendingBearSignal := true
        pendingBearBar := bar_index

if pendingBullSignal and bar_index - pendingBullBar > pendingExpireBars
    pendingBullSignal := false
if pendingBearSignal and bar_index - pendingBearBar > pendingExpireBars
    pendingBearSignal := false

priceRetestedBullZone = priceInBullFVG or priceInBullOB or inBullGoldenZone or inBullOTE or priceInRefinedBullGZ
priceRetestedBearZone = priceInBearFVG or priceInBearOB or inBearGoldenZone or inBearOTE or priceInRefinedBearGZ

// v8.4 C4: re-validate SL distance at TRIGGER bar (close moved since pending set)
twoStageLongOK = pendingBullSignal and ltfBullishTrigger and htfBullish and not hasConflict and newsFilterOK and (not requireRetest or priceRetestedBullZone) and slDistOKLong and strategy.position_size == 0
twoStageShortOK = pendingBearSignal and ltfBearishTrigger and htfBearish and not hasConflict and newsFilterOK and (not requireRetest or priceRetestedBearZone) and slDistOKShort and strategy.position_size == 0
directLongOK = htfBullSetupReady and strategy.position_size == 0
directShortOK = htfBearSetupReady and strategy.position_size == 0

longCondition = useTwoStageEntry ? twoStageLongOK : directLongOK
shortCondition = useTwoStageEntry ? twoStageShortOK : directShortOK

if longCondition
    pendingBullSignal := false
if shortCondition
    pendingBearSignal := false

// ═══════════════════════════════════════════════════════════════════════════
// 💰 SL/TP — FIX #12 (tighter structure SL)
// ═══════════════════════════════════════════════════════════════════════════

// v8.3: reuse the candidate SLs pre-computed in TWO-STAGE ENTRY section
// (slDistAtr, slBuf, minSLDistFloor, longSLcand, shortSLcand)
longSL = longSLcand
shortSL = shortSLcand

actualLongSLDist = close - longSL
actualShortSLDist = shortSL - close

longGradeRR = useAdaptiveRR ? getRRForGrade(bullGrade) : 3.5
shortGradeRR = useAdaptiveRR ? getRRForGrade(bearGrade) : 3.5

longTP1 = close + actualLongSLDist * 1.0
longTP2 = close + actualLongSLDist * 2.0
longTP3 = close + actualLongSLDist * longGradeRR

shortTP1 = close - actualShortSLDist * 1.0
shortTP2 = close - actualShortSLDist * 2.0
shortTP3 = close - actualShortSLDist * shortGradeRR

slPips = actualLongSLDist / pipSize
riskAmount = accountSize * (riskPerTrade / 100)
baseLotSize = useAutoLot and slPips > 0 ? riskAmount / (slPips * pipValue) : 0.01

longSizeMultiplier = useGradeSizing ? getSizeMultForGrade(bullGrade) : 1.0
shortSizeMultiplier = useGradeSizing ? getSizeMultForGrade(bearGrade) : 1.0

longLotSize = baseLotSize * longSizeMultiplier
shortLotSize = baseLotSize * shortSizeMultiplier

// v8.4 C1: Pine strategy `qty` = CONTRACTS, not lots. For forex 1 std lot = 100k units.
// Without this fix a 0.01 lot calc becomes 0.01 base units → ~10million× underexposure.
contractsPerLot = syminfo.type == "forex" ? 100000 : 1
longQtyContracts = longLotSize * contractsPerLot
shortQtyContracts = shortLotSize * contractsPerLot

// ═══════════════════════════════════════════════════════════════════════════
// 📤 STRATEGY EXECUTION — FIX #3, #4, #5 (multi-target rebuilt)
// ═══════════════════════════════════════════════════════════════════════════

var float entryPrice = na
var float currentSL = na
var float currentTP1 = na
var float currentTP2 = na
var float currentTP3 = na
var bool tp1Hit = false
var bool tp2Hit = false
var int lastClosedCount = 0
var bool isLongTrade = false
var bool justEntered = false

// Reset trade state on flat
if not inPosition
    tp1Hit := false
    tp2Hit := false

justEntered := false

// v8.3 FIX B2: actually USE the risk-based lot size in the entry order.
// v8.2 BUG: entry fell back to default_qty_type=percent_of_equity, so the
// risk% input + lot calc + grade-size multiplier were cosmetic-only.
// v8.5 A1: derive setup-tag (priority: sniper > judas > structure > zone)
deriveSetupTagLong() =>
    nySweepBullish ? "S1_NYsweep" : eqlGrabBullish ? "S2_EQL" : pdlSweepBullish ? "S3_PDL" : judasSwingBullish ? "JUDAS" : bullishCHoCH ? "CHoCH" : bullishBOS ? "BOS" : priceInBullOB ? "OB" : priceInBullFVG ? "FVG" : "MIX"
deriveSetupTagShort() =>
    nySweepBearish ? "S1_NYsweep" : eqhGrabBearish ? "S2_EQH" : pdhSweepBearish ? "S3_PDH" : judasSwingBearish ? "JUDAS" : bearishCHoCH ? "CHoCH" : bearishBOS ? "BOS" : priceInBearOB ? "OB" : priceInBearFVG ? "FVG" : "MIX"

if longCondition
    trade_tag := deriveSetupTagLong()
    trade_grade := bullGrade
    trade_entry_price := close
    trade_init_sl := longSL
    trade_is_long := true
    entryComment = "BUY " + bullGrade + " " + trade_tag + " W:" + str.tostring(bullScore) + " RR:" + str.tostring(longGradeRR, "#.#")
    if useAutoLot
        strategy.entry("LONG", strategy.long, qty=longQtyContracts, comment=entryComment)
    else
        strategy.entry("LONG", strategy.long, comment=entryComment)
    entryPrice := close
    currentSL := longSL
    currentTP1 := longTP1
    currentTP2 := longTP2
    currentTP3 := longTP3
    tp1Hit := false
    tp2Hit := false
    isLongTrade := true
    justEntered := true
    tradesToday := tradesToday + 1
    lastSignalBar := bar_index  // FIX #7
    lastClosedCount := strategy.closedtrades

if shortCondition
    trade_tag := deriveSetupTagShort()
    trade_grade := bearGrade
    trade_entry_price := close
    trade_init_sl := shortSL
    trade_is_long := false
    entryComment = "SELL " + bearGrade + " " + trade_tag + " W:" + str.tostring(bearScore) + " RR:" + str.tostring(shortGradeRR, "#.#")
    if useAutoLot
        strategy.entry("SHORT", strategy.short, qty=shortQtyContracts, comment=entryComment)
    else
        strategy.entry("SHORT", strategy.short, comment=entryComment)
    entryPrice := close
    currentSL := shortSL
    currentTP1 := shortTP1
    currentTP2 := shortTP2
    currentTP3 := shortTP3
    tp1Hit := false
    tp2Hit := false
    isLongTrade := false
    justEntered := true
    tradesToday := tradesToday + 1
    lastSignalBar := bar_index  // FIX #7
    lastClosedCount := strategy.closedtrades

// 🐛 FIX #4: After entry, capture absolute quantities for multi-target exits
// We use justEntered flag because strategy.position_size won't reflect the new
// entry until the next bar (entries fill at next bar open with calc_on_every_tick).
// On entry bar: place exits with the planned default qty% of equity.
if justEntered
    // Estimate the position size that will fill (default_qty_type uses % equity)
    // For multi-target, use percentage of position since we don't know exact qty yet
    if useMultiTarget
        if isLongTrade
            strategy.exit("X1_L", "LONG", qty_percent=tp1Pct, stop=currentSL, limit=longTP1)
            strategy.exit("X2_L", "LONG", qty_percent=tp2Pct, stop=currentSL, limit=longTP2)
            strategy.exit("X3_L", "LONG", stop=currentSL, limit=currentTP3)
        else
            strategy.exit("X1_S", "SHORT", qty_percent=tp1Pct, stop=currentSL, limit=shortTP1)
            strategy.exit("X2_S", "SHORT", qty_percent=tp2Pct, stop=currentSL, limit=shortTP2)
            strategy.exit("X3_S", "SHORT", stop=currentSL, limit=currentTP3)
    else
        if isLongTrade
            strategy.exit("EX_L", "LONG", stop=currentSL, limit=currentTP3)
        else
            strategy.exit("EX_S", "SHORT", stop=currentSL, limit=currentTP3)

// v8.4 C2: PRICE-based TP1 detection (closedtrades counter unreliable on partial fills
// across multi-target exits w/ calc_on_every_tick — also inflated by SL hits).
// Use intrabar high/low vs cached TP1 price.
if inPosition and not tp1Hit
    if isLongTrade and not na(currentTP1) and high >= currentTP1
        tp1Hit := true
    if not isLongTrade and not na(currentTP1) and low <= currentTP1
        tp1Hit := true

// TP2 hit detection (for completeness — controls trailing X3 only)
if inPosition and tp1Hit and not tp2Hit
    if isLongTrade and not na(currentTP2) and high >= currentTP2
        tp2Hit := true
    if not isLongTrade and not na(currentTP2) and low <= currentTP2
        tp2Hit := true

// v8.4 C3: After TP1, RE-ISSUE remaining exits w/ ABSOLUTE qty (not qty_percent).
// Re-applying qty_percent on partial-closed position double-counts.
// Strategy: on TP1 trigger, cancel old X2/X3 ids, replace with single absolute-qty exit at BE.
if tp1Hit and moveSLToBE and not tp1Hit[1]
    if isLongTrade and currentSL < entryPrice
        currentSL := entryPrice
        // remaining qty after TP1 = position size now (already partial-filled)
        remQty = math.abs(strategy.position_size)
        strategy.exit("X2_L", "LONG", qty=remQty * (tp2Pct / (100 - tp1Pct)), stop=entryPrice, limit=currentTP2)
        strategy.exit("X3_L", "LONG", stop=entryPrice, limit=currentTP3)
    if not isLongTrade and currentSL > entryPrice
        currentSL := entryPrice
        remQty = math.abs(strategy.position_size)
        strategy.exit("X2_S", "SHORT", qty=remQty * (tp2Pct / (100 - tp1Pct)), stop=entryPrice, limit=currentTP2)
        strategy.exit("X3_S", "SHORT", stop=entryPrice, limit=currentTP3)

// v8.4 C3: Trailing — only trail X3 (runner). X2 stays at BE w/ fixed TP2 limit.
// Re-applying qty_percent every bar = bug. Trail X3 has NO qty (=100% remaining after X2).
if tp1Hit and useTrailing and inPosition
    trailDistAtr = atr * trailAtrMult
    trailDistMin = minTrailDistPips * pipSize
    trailDist = math.max(trailDistAtr, trailDistMin)
    if isLongTrade
        newSL = close - trailDist
        if newSL > currentSL
            currentSL := newSL
            strategy.exit("X3_L", "LONG", stop=newSL, limit=currentTP3)
    else
        newSL = close + trailDist
        if newSL < currentSL
            currentSL := newSL
            strategy.exit("X3_S", "SHORT", stop=newSL, limit=currentTP3)

// ═══════════════════════════════════════════════════════════════════════════
// 📊 VISUALIZATION
// ═══════════════════════════════════════════════════════════════════════════

var label pendingBullLabel = na
var label pendingBearLabel = na

if showPendingSignal
    if pendingBullSignal and bar_index == pendingBullBar
        label.delete(pendingBullLabel)
        pendingBullLabel := label.new(bar_index, low - atr * 0.5, "⏳ PENDING BULL", style=label.style_label_up, color=CLR_PENDING, textcolor=CLR_WHITE, size=size.small)
    if pendingBearSignal and bar_index == pendingBearBar
        label.delete(pendingBearLabel)
        pendingBearLabel := label.new(bar_index, high + atr * 0.5, "⏳ PENDING BEAR", style=label.style_label_down, color=CLR_PENDING, textcolor=CLR_WHITE, size=size.small)

plotshape(pendingBullSignal and showPendingSignal, title="Pending Bull", style=shape.circle, location=location.belowbar, color=CLR_PENDING, size=size.tiny)
plotshape(pendingBearSignal and showPendingSignal, title="Pending Bear", style=shape.circle, location=location.abovebar, color=CLR_PENDING, size=size.tiny)

var line slLine = na
var line tp1Line = na
var line tp2Line = na
var line tp3Line = na
var line entryLine = na
var box positionBoxTP = na
var box positionBoxSL = na
var label slLabel = na
var label tp1Label = na
var label tp2Label = na
var label tp3Label = na
var label entryLabel = na
var label rrLabel = na
var label lotLabel = na
var label gradeLabel = na

if longCondition or shortCondition
    line.delete(slLine)
    line.delete(tp1Line)
    line.delete(tp2Line)
    line.delete(tp3Line)
    line.delete(entryLine)
    box.delete(positionBoxTP)
    box.delete(positionBoxSL)
    label.delete(slLabel)
    label.delete(tp1Label)
    label.delete(tp2Label)
    label.delete(tp3Label)
    label.delete(entryLabel)
    label.delete(rrLabel)
    label.delete(lotLabel)
    label.delete(gradeLabel)

if longCondition and showSLTP
    rightX = bar_index + chartLabelOffset
    entryLine := line.new(bar_index, close, rightX, close, color=CLR_GOLD, width=2, extend=extend.right)
    slLine := line.new(bar_index, longSL, rightX, longSL, color=CLR_BEAR, width=2, style=line.style_dashed, extend=extend.right)
    tp1Line := line.new(bar_index, longTP1, rightX, longTP1, color=CLR_LBL_TP1_BG, width=1, style=line.style_dotted, extend=extend.right)
    tp2Line := line.new(bar_index, longTP2, rightX, longTP2, color=CLR_LBL_TP2_BG, width=1, style=line.style_dashed, extend=extend.right)
    tp3Line := line.new(bar_index, longTP3, rightX, longTP3, color=CLR_LBL_TP3_BG, width=2, extend=extend.right)
    if showPositionBox
        positionBoxTP := box.new(left=bar_index, top=longTP3, right=rightX, bottom=close, bgcolor=color.new(CLR_BULL, 92), border_color=color.new(CLR_BULL, 50))
        positionBoxSL := box.new(left=bar_index, top=close, right=rightX, bottom=longSL, bgcolor=color.new(CLR_BEAR, 92), border_color=color.new(CLR_BEAR, 50))
    // v8.4 U2/U5: solid bg + WHITE text on saturated colors, bigger size, staggered x-offsets
    entryLabel := label.new(rightX, close, " LONG " + str.tostring(close, format.mintick) + " ", style=label.style_label_left, color=CLR_GOLD, textcolor=CLR_LBL_GZ_BUY_TX, size=lblSizeChart)
    gradeLabel := label.new(bar_index, close + atr, " " + bullGrade + " | W:" + str.tostring(bullScore) + " | RR 1:" + str.tostring(longGradeRR, "#.#") + " ", style=label.style_label_down, color=gradeColorFromScore(bullScore), textcolor=CLR_WHITE, size=lblSizeChart)
    slLabel := label.new(rightX, longSL, " SL " + str.tostring(longSL, format.mintick) + " ", style=label.style_label_left, color=CLR_LBL_SL_BG, textcolor=CLR_WHITE, size=lblSizeChartMid)
    tp1Label := label.new(rightX, longTP1, " TP1 1R ", style=label.style_label_left, color=CLR_LBL_TP1_BG, textcolor=CLR_LBL_GZ_BUY_TX, size=lblSizeChartMid)
    tp2Label := label.new(rightX, longTP2, " TP2 2R ", style=label.style_label_left, color=CLR_LBL_TP2_BG, textcolor=CLR_WHITE, size=lblSizeChartMid)
    tp3Label := label.new(rightX, longTP3, " TP3 " + str.tostring(longGradeRR, "#.#") + "R ", style=label.style_label_left, color=CLR_LBL_TP3_BG, textcolor=CLR_WHITE, size=lblSizeChart)
    if showRR
        rrLabel := label.new(bar_index + math.floor(chartLabelOffset/2), (longTP3 + longSL) / 2, " 1:" + str.tostring(longGradeRR, "#.#") + " ", style=label.style_label_center, color=CLR_ACCENT, textcolor=CLR_WHITE, size=lblSizeChart)
    if useAutoLot
        lotLabel := label.new(bar_index, longSL - atr * 0.5, " Lot:" + str.tostring(longLotSize, "#.##") + " ", style=label.style_label_up, color=CLR_PURPLE, textcolor=CLR_WHITE, size=lblSizeChartMid)

if shortCondition and showSLTP
    rightX = bar_index + chartLabelOffset
    entryLine := line.new(bar_index, close, rightX, close, color=CLR_GOLD, width=2, extend=extend.right)
    slLine := line.new(bar_index, shortSL, rightX, shortSL, color=CLR_BEAR, width=2, style=line.style_dashed, extend=extend.right)
    tp1Line := line.new(bar_index, shortTP1, rightX, shortTP1, color=CLR_LBL_TP1_BG, width=1, style=line.style_dotted, extend=extend.right)
    tp2Line := line.new(bar_index, shortTP2, rightX, shortTP2, color=CLR_LBL_TP2_BG, width=1, style=line.style_dashed, extend=extend.right)
    tp3Line := line.new(bar_index, shortTP3, rightX, shortTP3, color=CLR_LBL_TP3_BG, width=2, extend=extend.right)
    if showPositionBox
        positionBoxTP := box.new(left=bar_index, top=close, right=rightX, bottom=shortTP3, bgcolor=color.new(CLR_BULL, 92), border_color=color.new(CLR_BULL, 50))
        positionBoxSL := box.new(left=bar_index, top=shortSL, right=rightX, bottom=close, bgcolor=color.new(CLR_BEAR, 92), border_color=color.new(CLR_BEAR, 50))
    entryLabel := label.new(rightX, close, " SHORT " + str.tostring(close, format.mintick) + " ", style=label.style_label_left, color=CLR_GOLD, textcolor=CLR_LBL_GZ_BUY_TX, size=lblSizeChart)
    gradeLabel := label.new(bar_index, close - atr, " " + bearGrade + " | W:" + str.tostring(bearScore) + " | RR 1:" + str.tostring(shortGradeRR, "#.#") + " ", style=label.style_label_up, color=gradeColorFromScore(bearScore), textcolor=CLR_WHITE, size=lblSizeChart)
    slLabel := label.new(rightX, shortSL, " SL " + str.tostring(shortSL, format.mintick) + " ", style=label.style_label_left, color=CLR_LBL_SL_BG, textcolor=CLR_WHITE, size=lblSizeChartMid)
    tp1Label := label.new(rightX, shortTP1, " TP1 1R ", style=label.style_label_left, color=CLR_LBL_TP1_BG, textcolor=CLR_LBL_GZ_BUY_TX, size=lblSizeChartMid)
    tp2Label := label.new(rightX, shortTP2, " TP2 2R ", style=label.style_label_left, color=CLR_LBL_TP2_BG, textcolor=CLR_WHITE, size=lblSizeChartMid)
    tp3Label := label.new(rightX, shortTP3, " TP3 " + str.tostring(shortGradeRR, "#.#") + "R ", style=label.style_label_left, color=CLR_LBL_TP3_BG, textcolor=CLR_WHITE, size=lblSizeChart)
    if showRR
        rrLabel := label.new(bar_index + math.floor(chartLabelOffset/2), (shortTP3 + shortSL) / 2, " 1:" + str.tostring(shortGradeRR, "#.#") + " ", style=label.style_label_center, color=CLR_ACCENT, textcolor=CLR_WHITE, size=lblSizeChart)
    if useAutoLot
        lotLabel := label.new(bar_index, shortSL + atr * 0.5, " Lot:" + str.tostring(shortLotSize, "#.##") + " ", style=label.style_label_down, color=CLR_PURPLE, textcolor=CLR_WHITE, size=lblSizeChartMid)

plotshape(longCondition, title="BUY", style=shape.labelup, location=location.belowbar, color=CLR_BULL, textcolor=CLR_WHITE, size=size.large, text="BUY")
plotshape(shortCondition, title="SELL", style=shape.labeldown, location=location.abovebar, color=CLR_BEAR, textcolor=CLR_WHITE, size=size.large, text="SELL")

plot(useEMAFilter ? emaFast : na, "EMA Fast", color=color.new(CLR_CYAN, 0), linewidth=2)
plot(useEMAFilter ? emaSlow : na, "EMA Slow", color=color.new(CLR_ORANGE, 0), linewidth=2)
plot(useVWAP ? vwapValue : na, "VWAP", color=color.new(CLR_PINK, 0), linewidth=2)

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 DASHBOARD
// ═══════════════════════════════════════════════════════════════════════════

dashPosition = dashPos == "Top Right" ? position.top_right : dashPos == "Top Left" ? position.top_left : dashPos == "Middle Right" ? position.middle_right : dashPos == "Bottom Right" ? position.bottom_right : position.middle_right

var table dash = table.new(dashPosition, 3, 25, bgcolor=CLR_BG_DARK, border_width=2, border_color=CLR_BORDER, frame_color=CLR_ACCENT, frame_width=3)

trendArrow(t) => t == 1 ? "▲" : t == -1 ? "▼" : "●"
trendText(t) => t == 1 ? "BULL" : t == -1 ? "BEAR" : "FLAT"
trendBg(t) => t == 1 ? CLR_BULL_BG : t == -1 ? CLR_BEAR_BG : CLR_NEUTRAL_BG

if barstate.islast and showDashboard
    table.cell(dash, 0, 0, "🎯 SMC v8.5 SNIPER", bgcolor=CLR_ACCENT, text_color=CLR_WHITE, text_size=txtSizeBig, text_halign=text.align_center)
    table.merge_cells(dash, 0, 0, 2, 0)
    table.cell(dash, 0, 1, syminfo.ticker, bgcolor=CLR_BG_CARD, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(dash, 1, 1, timeframe.period, bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(dash, 2, 1, str.tostring(close, format.mintick), bgcolor=CLR_BG_CARD, text_color=CLR_GOLD, text_size=txtSizeNormal, text_halign=text.align_center)

    // v8.5 UI: SESSION badge + active SNIPER setup (auto-collapse — cell if both "—")
    sessText = isOverlap ? "OVERLAP" : isLondonKZ ? "LONDON" : isNYKZ ? "NEW YORK" : isAsianSession ? "ASIAN" : "DEAD"
    sessBg   = isOverlap ? CLR_GOLD_BG : isLondonKZ ? CLR_PURPLE_BG : isNYKZ ? CLR_BEAR_BG : isAsianSession ? CLR_NEUTRAL_BG : CLR_BG_CARD
    activeSetupLong  = nySweepBullish ? "🎯 S1" : eqlGrabBullish ? "🎯 S2" : pdlSweepBullish ? "🎯 S3" : judasSwingBullish ? "JUDAS" : bullishBOS ? "BOS" : bullishCHoCH ? "CHoCH" : "—"
    activeSetupShort = nySweepBearish ? "🎯 S1" : eqhGrabBearish ? "🎯 S2" : pdhSweepBearish ? "🎯 S3" : judasSwingBearish ? "JUDAS" : bearishBOS ? "BOS" : bearishCHoCH ? "CHoCH" : "—"
    bothSetupsEmpty  = activeSetupLong == "—" and activeSetupShort == "—"
    table.cell(dash, 0, 2, "Session", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeSmall, text_halign=text.align_left)
    table.cell(dash, 1, 2, sessText, bgcolor=sessBg, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    if bothSetupsEmpty
        // No active setup — collapse: extend session badge across col 2 instead of showing "L:— S:—"
        table.merge_cells(dash, 1, 2, 2, 2)
    else
        setupStr = (activeSetupLong != "—" ? "L:" + activeSetupLong : "") + (activeSetupLong != "—" and activeSetupShort != "—" ? " " : "") + (activeSetupShort != "—" ? "S:" + activeSetupShort : "")
        table.cell(dash, 2, 2, setupStr, bgcolor=CLR_BG_CARD, text_color=CLR_GOLD, text_size=txtSizeSmall, text_halign=text.align_center)

    rowIdx = 3
    table.cell(dash, 0, rowIdx, "🎯 ENTRY", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.merge_cells(dash, 0, rowIdx, 2, rowIdx)
    rowIdx := rowIdx + 1
    entryStateText = freshSessionBlock ? "🚫 SESSION OPEN" : pendingBullSignal ? "⏳ PENDING BULL" : pendingBearSignal ? "⏳ PENDING BEAR" : longCondition ? "✅ LONG" : shortCondition ? "✅ SHORT" : "👀 SCAN"
    entryStateBg = freshSessionBlock ? CLR_NEUTRAL_BG : pendingBullSignal ? CLR_GOLD_BG : pendingBearSignal ? CLR_GOLD_BG : longCondition ? CLR_BULL_BG : shortCondition ? CLR_BEAR_BG : CLR_NEUTRAL_BG
    table.cell(dash, 0, rowIdx, "State", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeNormal, text_halign=text.align_left)
    table.cell(dash, 1, rowIdx, entryStateText, bgcolor=entryStateBg, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.merge_cells(dash, 1, rowIdx, 2, rowIdx)
    rowIdx := rowIdx + 1
    
    if useCooldown
        cdText = cooldownOK ? "✅ READY" : "⏱️ " + str.tostring(requiredCooldown - barsSinceLastSignal)
        cdBg = cooldownOK ? CLR_BULL_BG : CLR_NEUTRAL_BG
        table.cell(dash, 0, rowIdx, "Cooldown", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeSmall, text_halign=text.align_left)
        table.cell(dash, 1, rowIdx, cdText, bgcolor=cdBg, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        table.merge_cells(dash, 1, rowIdx, 2, rowIdx)
        rowIdx := rowIdx + 1

    // v8.5 UI: HTF/MTF gate status row
    htfGateText = htfBullish ? "BULL ✓" : htfBearish ? "BEAR ✓" : "FLAT ✗"
    htfGateBg   = htfBullish ? CLR_BULL_BG : htfBearish ? CLR_BEAR_BG : CLR_NEUTRAL_BG
    mtfGateText = mtfBullish ? "BULL ✓" : mtfBearish ? "BEAR ✓" : "MIX ✗"
    mtfGateBg   = mtfBullish ? CLR_BULL_BG : mtfBearish ? CLR_BEAR_BG : CLR_NEUTRAL_BG
    table.cell(dash, 0, rowIdx, "Gate H/M", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeSmall, text_halign=text.align_left)
    table.cell(dash, 1, rowIdx, htfGateText, bgcolor=htfGateBg, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    table.cell(dash, 2, rowIdx, mtfGateText, bgcolor=mtfGateBg, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    rowIdx := rowIdx + 1
    
    // Position status (NEW in v8.2)
    if inPosition
        posStatusText = tp1Hit ? "TP1 ✓ | BE/Trail Active" : "Live | Awaiting TP1"
        posStatusBg = tp1Hit ? CLR_BULL_BG : CLR_GOLD_BG
        table.cell(dash, 0, rowIdx, "Position", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeSmall, text_halign=text.align_left)
        table.cell(dash, 1, rowIdx, posStatusText, bgcolor=posStatusBg, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        table.merge_cells(dash, 1, rowIdx, 2, rowIdx)
        rowIdx := rowIdx + 1
    
    table.cell(dash, 0, rowIdx, "🏆 QUALITY", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.merge_cells(dash, 0, rowIdx, 2, rowIdx)
    rowIdx := rowIdx + 1
    bullGradeBg = bullScore >= maxScore * 0.7 ? CLR_BULL_BG : bullScore >= maxScore * 0.5 ? CLR_GOLD_BG : CLR_BEAR_BG
    table.cell(dash, 0, rowIdx, "🟢 BUY", bgcolor=CLR_BG_CARD, text_color=CLR_BULL, text_size=txtSizeNormal, text_halign=text.align_left)
    table.cell(dash, 1, rowIdx, bullGrade, bgcolor=bullGradeBg, text_color=CLR_WHITE, text_size=txtSizeBig, text_halign=text.align_center)
    table.cell(dash, 2, rowIdx, str.tostring(bullScore) + "/" + str.tostring(maxScore), bgcolor=bullGradeBg, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    rowIdx := rowIdx + 1
    bearGradeBg = bearScore >= maxScore * 0.7 ? CLR_BEAR_BG : bearScore >= maxScore * 0.5 ? CLR_GOLD_BG : CLR_NEUTRAL_BG
    table.cell(dash, 0, rowIdx, "🔴 SELL", bgcolor=CLR_BG_CARD, text_color=CLR_BEAR, text_size=txtSizeNormal, text_halign=text.align_left)
    table.cell(dash, 1, rowIdx, bearGrade, bgcolor=bearGradeBg, text_color=CLR_WHITE, text_size=txtSizeBig, text_halign=text.align_center)
    table.cell(dash, 2, rowIdx, str.tostring(bearScore) + "/" + str.tostring(maxScore), bgcolor=bearGradeBg, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    rowIdx := rowIdx + 1
    
    if hasConflict
        table.cell(dash, 0, rowIdx, "⚠️ CONFLICT", bgcolor=CLR_GOLD_BG, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
        table.merge_cells(dash, 0, rowIdx, 2, rowIdx)
        rowIdx := rowIdx + 1
    
    if showMTF
        table.cell(dash, 0, rowIdx, "🔭 MTF", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
        table.merge_cells(dash, 0, rowIdx, 2, rowIdx)
        rowIdx := rowIdx + 1
        table.cell(dash, 0, rowIdx, tf1, bgcolor=CLR_BG_CARD, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
        table.cell(dash, 1, rowIdx, trendArrow(trend1) + " " + trendText(trend1), bgcolor=trendBg(trend1), text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
        table.cell(dash, 2, rowIdx, trend1 == 1 ? "BUY" : trend1 == -1 ? "SELL" : "WAIT", bgcolor=trendBg(trend1), text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        rowIdx := rowIdx + 1
        table.cell(dash, 0, rowIdx, tf2, bgcolor=CLR_BG_CARD, text_color=CLR_CYAN, text_size=txtSizeNormal, text_halign=text.align_center)
        table.cell(dash, 1, rowIdx, trendArrow(trend2) + " " + trendText(trend2), bgcolor=trendBg(trend2), text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
        table.cell(dash, 2, rowIdx, trend2 == 1 ? "BUY" : trend2 == -1 ? "SELL" : "WAIT", bgcolor=trendBg(trend2), text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        rowIdx := rowIdx + 1
        table.cell(dash, 0, rowIdx, tf3 + " ⭐", bgcolor=CLR_BG_CARD, text_color=CLR_GOLD, text_size=txtSizeNormal, text_halign=text.align_center)
        table.cell(dash, 1, rowIdx, trendArrow(trend3) + " " + trendText(trend3), bgcolor=trendBg(trend3), text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
        table.cell(dash, 2, rowIdx, trend3 == 1 ? "BUY" : trend3 == -1 ? "SELL" : "WAIT", bgcolor=trendBg(trend3), text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        rowIdx := rowIdx + 1
    
    table.cell(dash, 0, rowIdx, "🛡️ RISK", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.merge_cells(dash, 0, rowIdx, 2, rowIdx)
    rowIdx := rowIdx + 1
    dailyColor = dailyPnLPct > 0 ? CLR_BULL : dailyPnLPct < 0 ? CLR_BEAR : CLR_TEXT_MUTED
    dailyBg = dailyLossExceeded ? CLR_BEAR_BG : CLR_BG_CARD
    table.cell(dash, 0, rowIdx, "Daily", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeNormal, text_halign=text.align_left)
    table.cell(dash, 1, rowIdx, str.tostring(dailyPnLPct, "#.##") + "%", bgcolor=dailyBg, text_color=dailyColor, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(dash, 2, rowIdx, dailyLossExceeded ? "🛑" : "✓", bgcolor=dailyBg, text_color=dailyLossExceeded ? CLR_WHITE : CLR_BULL, text_size=txtSizeNormal, text_halign=text.align_center)
    rowIdx := rowIdx + 1
    
    table.cell(dash, 0, rowIdx, "📈 STATS", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.merge_cells(dash, 0, rowIdx, 2, rowIdx)
    rowIdx := rowIdx + 1
    winRate = strategy.closedtrades > 0 ? strategy.wintrades / strategy.closedtrades * 100 : 0
    winRateColor = winRate >= 60 ? CLR_BULL : winRate >= 40 ? CLR_GOLD : CLR_BEAR
    profitColor = strategy.netprofit > 0 ? CLR_BULL : strategy.netprofit < 0 ? CLR_BEAR : CLR_TEXT_MUTED
    pnlText = (strategy.netprofit >= 0 ? "+$" : "-$") + str.tostring(math.abs(strategy.netprofit), "#.##")
    table.cell(dash, 0, rowIdx, "T:" + str.tostring(strategy.closedtrades), bgcolor=CLR_BG_CARD, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(dash, 1, rowIdx, str.tostring(winRate, "#.#") + "%", bgcolor=CLR_BG_CARD, text_color=winRateColor, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(dash, 2, rowIdx, pnlText, bgcolor=CLR_BG_CARD, text_color=profitColor, text_size=txtSizeNormal, text_halign=text.align_center)

// ═══════════════════════════════════════════════════════════════════════════
// 📋 ENTRY SETUP PANEL
// ═══════════════════════════════════════════════════════════════════════════

plan_long_tp2 = close + (close - longSL) * minTPRatio
plan_short_tp2 = close - (shortSL - close) * minTPRatio

recommendedSide = bullScore > bearScore and bullScore >= minWeightedScore ? "LONG" : bearScore > bullScore and bearScore >= minWeightedScore ? "SHORT" : "WAIT"
recommendedGrade = recommendedSide == "LONG" ? bullGrade : recommendedSide == "SHORT" ? bearGrade : "—"
recommendedColor = recommendedSide == "LONG" ? CLR_BULL_BG : recommendedSide == "SHORT" ? CLR_BEAR_BG : CLR_NEUTRAL_BG

var table entryPanel = table.new(position.bottom_left, 4, 8, bgcolor=CLR_BG_DARK, border_width=2, border_color=CLR_BORDER, frame_color=CLR_GOLD, frame_width=2)

if showEntryPanel and barstate.islast
    table.cell(entryPanel, 0, 0, "📋 NEXT TRADE PLAN", bgcolor=CLR_GOLD, text_color=CLR_BG_DARK, text_size=txtSizeNormal, text_halign=text.align_center)
    table.merge_cells(entryPanel, 0, 0, 3, 0)
    table.cell(entryPanel, 0, 1, "Side", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 1, 1, "Entry", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 2, 1, "SL", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 3, 1, "TP 1:" + str.tostring(minTPRatio, "#.#"), bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 0, 2, "🟢 LONG", bgcolor=CLR_BULL_BG, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 1, 2, str.tostring(close, format.mintick), bgcolor=CLR_BG_CARD, text_color=CLR_GOLD, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 2, 2, str.tostring(longSL, format.mintick), bgcolor=CLR_BG_CARD, text_color=CLR_BEAR, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 3, 2, str.tostring(plan_long_tp2, format.mintick), bgcolor=CLR_BG_CARD, text_color=CLR_BULL, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 0, 3, "🔴 SHORT", bgcolor=CLR_BEAR_BG, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 1, 3, str.tostring(close, format.mintick), bgcolor=CLR_BG_CARD, text_color=CLR_GOLD, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 2, 3, str.tostring(shortSL, format.mintick), bgcolor=CLR_BG_CARD, text_color=CLR_BEAR, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 3, 3, str.tostring(plan_short_tp2, format.mintick), bgcolor=CLR_BG_CARD, text_color=CLR_BULL, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 0, 4, "👉 BIAS", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 1, 4, recommendedSide, bgcolor=recommendedColor, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 2, 4, recommendedGrade, bgcolor=recommendedColor, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 3, 4, str.tostring(math.max(bullScore, bearScore)) + " pts", bgcolor=recommendedColor, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    contextStr = ""
    if priceInRefinedBullGZ
        contextStr := contextStr + "GZ-Bull "
    if priceInRefinedBearGZ
        contextStr := contextStr + "GZ-Bear "
    if nearGann50
        contextStr := contextStr + "Gann50 "
    if trendlineBullBreak
        contextStr := contextStr + "TL-Bull "
    if trendlineBearBreak
        contextStr := contextStr + "TL-Bear "
    if inBullOTE
        contextStr := contextStr + "OTE-Bull "
    if inBearOTE
        contextStr := contextStr + "OTE-Bear "
    // v8.5 UI: auto-collapse — render Context row only if at least one context flag active
    if contextStr != ""
        table.cell(entryPanel, 0, 5, "Context", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeNormal, text_halign=text.align_center)
        table.cell(entryPanel, 1, 5, contextStr, bgcolor=CLR_BG_CARD, text_color=CLR_CYAN, text_size=txtSizeNormal, text_halign=text.align_left)
        table.merge_cells(entryPanel, 1, 5, 3, 5)
    // v8.4 U6: scalp-critical SL distance row — exposes gate trip + spread reality
    slDistLpip = (close - longSL) / pipSize
    slDistSpip = (shortSL - close) / pipSize
    slStatusL = slDistLpip < minSLpips ? "TOO TIGHT" : slDistLpip > maxSLpips ? "TOO WIDE" : "OK"
    slStatusS = slDistSpip < minSLpips ? "TOO TIGHT" : slDistSpip > maxSLpips ? "TOO WIDE" : "OK"
    slLBg = slStatusL == "OK" ? CLR_BULL_BG : CLR_BEAR_BG
    slSBg = slStatusS == "OK" ? CLR_BULL_BG : CLR_BEAR_BG
    table.cell(entryPanel, 0, 6, "SL pips L/S", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 1, 6, str.tostring(slDistLpip, "#.#") + " / " + str.tostring(slDistSpip, "#.#"), bgcolor=CLR_BG_CARD, text_color=CLR_GOLD, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 2, 6, slStatusL, bgcolor=slLBg, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 3, 6, slStatusS, bgcolor=slSBg, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    spreadPipsNow = realSpread
    spreadOKnow = spreadOK ? "OK" : "WIDE"
    table.cell(entryPanel, 0, 7, "Spread", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_LIGHT, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 1, 7, str.tostring(spreadPipsNow, "#.#") + " pip", bgcolor=CLR_BG_CARD, text_color=CLR_GOLD, text_size=txtSizeNormal, text_halign=text.align_center)
    table.cell(entryPanel, 2, 7, spreadOKnow, bgcolor=spreadOK ? CLR_BULL_BG : CLR_BEAR_BG, text_color=CLR_WHITE, text_size=txtSizeNormal, text_halign=text.align_center)
    table.merge_cells(entryPanel, 2, 7, 3, 7)

// ═══════════════════════════════════════════════════════════════════════════
// 📈 v8.5 A2 — STATS-BY-SETUP-TAG TABLE
// Win-rate, R-expectancy, profit factor per setup-tag + grade.
// ═══════════════════════════════════════════════════════════════════════════
aggregateForTag(string tagFilter) =>
    int wins   = 0
    int losses = 0
    float sumR_win  = 0.0
    float sumR_loss = 0.0
    int n = array.size(analytics_R)
    if n > 0
        for i = 0 to n - 1
            tag_i = array.get(analytics_tag, i)
            if tagFilter == "" or tag_i == tagFilter
                r_i = array.get(analytics_R, i)
                w_i = array.get(analytics_winflag, i)
                if w_i == 1
                    wins := wins + 1
                    sumR_win := sumR_win + r_i
                else
                    losses := losses + 1
                    sumR_loss := sumR_loss + math.abs(r_i)
    [wins, losses, sumR_win, sumR_loss]

allTags = array.from("S1_NYsweep", "S2_EQL", "S2_EQH", "S3_PDL", "S3_PDH", "JUDAS", "CHoCH", "BOS", "OB", "FVG", "MIX")

var table statsTbl = table.new(position.top_left, 6, 14, bgcolor=CLR_BG_DARK, border_width=1, border_color=CLR_BORDER, frame_color=CLR_GOLD, frame_width=2)

// v8.5 UI: always show header + empty-state placeholder when no trades closed yet
if showAnalyticsTable and barstate.islast
    // Header
    table.cell(statsTbl, 0, 0, "📈 STATS BY SETUP", bgcolor=CLR_GOLD, text_color=CLR_BG_DARK, text_size=txtSizeNormal, text_halign=text.align_center)
    table.merge_cells(statsTbl, 0, 0, 5, 0)

if showAnalyticsTable and barstate.islast and array.size(analytics_R) == 0
    // Empty state — single info row spans table
    table.cell(statsTbl, 0, 1, "⏳ Waiting for first closed trade — stats populate after TP/SL exit", bgcolor=CLR_BG_CARD, text_color=CLR_TEXT_MUTED, text_size=txtSizeSmall, text_halign=text.align_center)
    table.merge_cells(statsTbl, 0, 1, 5, 1)

if showAnalyticsTable and barstate.islast and array.size(analytics_R) > 0
    table.cell(statsTbl, 0, 1, "Tag", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    table.cell(statsTbl, 1, 1, "N",   bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    table.cell(statsTbl, 2, 1, "WR%", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    table.cell(statsTbl, 3, 1, "Exp R", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    table.cell(statsTbl, 4, 1, "PF",  bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    table.cell(statsTbl, 5, 1, "Sum R", bgcolor=CLR_BG_HEADER, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
    rowAn = 2
    for ti = 0 to array.size(allTags) - 1
        tg = array.get(allTags, ti)
        [w, l, sRw, sRl] = aggregateForTag(tg)
        n = w + l
        if n > 0
            wr  = w / n * 100.0
            exp = (sRw - sRl) / n
            pf  = sRl > 0 ? sRw / sRl : sRw > 0 ? 99.9 : 0.0
            sumR_all = sRw - sRl
            wrColor = wr >= 60 ? CLR_BULL : wr >= 45 ? CLR_GOLD : CLR_BEAR
            expColor = exp > 0 ? CLR_BULL : CLR_BEAR
            table.cell(statsTbl, 0, rowAn, tg, bgcolor=CLR_BG_CARD, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_left)
            table.cell(statsTbl, 1, rowAn, str.tostring(n), bgcolor=CLR_BG_CARD, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
            table.cell(statsTbl, 2, rowAn, str.tostring(wr, "#.#"), bgcolor=CLR_BG_CARD, text_color=wrColor, text_size=txtSizeSmall, text_halign=text.align_center)
            table.cell(statsTbl, 3, rowAn, str.tostring(exp, "#.##") + "R", bgcolor=CLR_BG_CARD, text_color=expColor, text_size=txtSizeSmall, text_halign=text.align_center)
            table.cell(statsTbl, 4, rowAn, str.tostring(pf, "#.##"), bgcolor=CLR_BG_CARD, text_color=CLR_GOLD, text_size=txtSizeSmall, text_halign=text.align_center)
            table.cell(statsTbl, 5, rowAn, str.tostring(sumR_all, "#.#") + "R", bgcolor=CLR_BG_CARD, text_color=expColor, text_size=txtSizeSmall, text_halign=text.align_center)
            rowAn := rowAn + 1
    // Aggregate row
    [wA, lA, sRwA, sRlA] = aggregateForTag("")
    nA = wA + lA
    if nA > 0
        wrA  = wA / nA * 100.0
        expA = (sRwA - sRlA) / nA
        pfA  = sRlA > 0 ? sRwA / sRlA : sRwA > 0 ? 99.9 : 0.0
        sumRA = sRwA - sRlA
        table.cell(statsTbl, 0, rowAn, "TOTAL", bgcolor=CLR_ACCENT, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        table.cell(statsTbl, 1, rowAn, str.tostring(nA), bgcolor=CLR_ACCENT, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        table.cell(statsTbl, 2, rowAn, str.tostring(wrA, "#.#"), bgcolor=CLR_ACCENT, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        table.cell(statsTbl, 3, rowAn, str.tostring(expA, "#.##") + "R", bgcolor=CLR_ACCENT, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        table.cell(statsTbl, 4, rowAn, str.tostring(pfA, "#.##"), bgcolor=CLR_ACCENT, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)
        table.cell(statsTbl, 5, rowAn, str.tostring(sumRA, "#.#") + "R", bgcolor=CLR_ACCENT, text_color=CLR_WHITE, text_size=txtSizeSmall, text_halign=text.align_center)

// ═══════════════════════════════════════════════════════════════════════════
// 🔔 ALERTS
// ═══════════════════════════════════════════════════════════════════════════

alertcondition(longCondition, title="🟢 BUY", message="SMC v8.2 BUY triggered")
alertcondition(shortCondition, title="🔴 SELL", message="SMC v8.2 SELL triggered")
alertcondition(pendingBullSignal and not pendingBullSignal[1], title="⏳ Pending BUY", message="Pending BUY - waiting LTF")
alertcondition(pendingBearSignal and not pendingBearSignal[1], title="⏳ Pending SELL", message="Pending SELL - waiting LTF")
alertcondition(hasConflict, title="⚠️ Conflict", message="Signal conflict detected")
alertcondition(dailyLossExceeded, title="🛑 Daily Loss", message="Daily loss limit reached")
alertcondition(tp1Hit and not tp1Hit[1], title="🎯 TP1 Hit", message="TP1 filled — BE/Trail activated")

if longCondition and useWebhook
    jsonBuy = '{"action":"buy","symbol":"' + syminfo.ticker + '","price":' + str.tostring(close, format.mintick) + ',"grade":"' + bullGrade + '","sl":' + str.tostring(longSL, format.mintick) + ',"tp":' + str.tostring(longTP3, format.mintick) + ',"rr":' + str.tostring(longGradeRR, "#.#") + '}'
    alert(jsonBuy, alert.freq_once_per_bar_close)

if shortCondition and useWebhook
    jsonSell = '{"action":"sell","symbol":"' + syminfo.ticker + '","price":' + str.tostring(close, format.mintick) + ',"grade":"' + bearGrade + '","sl":' + str.tostring(shortSL, format.mintick) + ',"tp":' + str.tostring(shortTP3, format.mintick) + ',"rr":' + str.tostring(shortGradeRR, "#.#") + '}'
    alert(jsonSell, alert.freq_once_per_bar_close)
