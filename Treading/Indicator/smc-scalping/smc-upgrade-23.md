

//@version=5
indicator("SMC Master Pro v23 | Institutional Upgrade", shorttitle="SMC Pro v23", overlay=true, max_boxes_count=500, max_lines_count=500, max_labels_count=500, max_bars_back=5000)

// v23: ISSUE-2 dedicated ENTRY structure track (pivot 5/8/12) — entries no longer ride pivot-3 noise
//      ISSUE-3 orthogonal confluence (5 capped categories, trend counted once) + rescaled minConfluence
//      ISSUE-4 liq-grab alert text corrected to match v18 reversal logic | ISSUE-5 News→Time Blackout (honest label)
//      ISSUE-6 Institutional Mode forces barstate.isconfirmed | P2 f_equityStep unifies compounding
//      P2 single liquidity-event engine (sweep/grab dedup + classification) | companion: smc_strategy.pine
// v22: CRIT-1 OTE levels computed every bar (was last-bar only → live-only phantom) | HIGH-2 maxScore htfPOI gate
//      HIGH-3 flip exit booked at next-bar open (was close) | MED-4 R-based equity so DD breaker works w/o sizing
//      MED-5 same-bar SL/TP default = SL-first (pessimistic) | MED-6 hard margin block gate at entry
// v21: FIX-1 session/KZ label pool | FIX-2 news re-check at pending exec | FIX-3 drawdownOk same-bar
//      FIX-4 realEquity at flip exit | FIX-5 FVG confluence gate | FIX-6 Judas self-validation
//      FIX-7 OTE confluence +2 | FIX-8 SMT temporal guard | FIX-9 peakEquity unrealized | FIX-10 margin
// v20: f_pushExit pool | peakEquity at TP1/TP2 | CISD ATR gate | Judas one-shot | BPR proximity | news default

// ═══════════════════════════════════════════════════════════════
// 🎨 COLOR PALETTE
// ═══════════════════════════════════════════════════════════════
C_BULL        = #00D9A3
C_BEAR        = #FF2D5E
C_NEUTRAL     = #7B8AA0
C_GOLD        = #FFC700
C_PURPLE      = #C490F0
C_BLUE        = #5BAEFF
C_ORANGE      = #FF9A4A
C_CYAN        = #00E5FF
C_PINK        = #FF6BCB

C_LBL_BULL    = #00A878
C_LBL_BEAR    = #D62650
C_LBL_DARK    = #1E293B
C_LBL_LIGHT   = #F1F5F9

C_TEXT_WHITE  = #FFFFFF
C_TEXT_BLACK  = #000000
C_TEXT_LIGHT  = #F8FAFC
C_TEXT_DARK   = #0F172A
C_TEXT_DIM    = #94A3B8

C_ASIA        = #4D9FFF
C_LONDON      = #FFB800
C_NY          = #FF6BCB

C_FIB_50      = #FFC700
C_FIB_618     = #FF9A4A
C_FIB_786     = #FF2D5E

// ═══════════════════════════════════════════════════════════════
// 🎯 DISPLAY PRESET
// ═══════════════════════════════════════════════════════════════
grpPreset = "🎯 Display Preset"
displayMode = input.string("Trading (Balanced)", "Display Mode", options=["Minimal (Clean)", "Trading (Balanced)", "Full (Everything)"], group=grpPreset)
darkMode = input.bool(true, "Dark Theme", group=grpPreset)
textScale = input.string("Normal", "Text Size", options=["Small", "Normal", "Large"], group=grpPreset)

isMinimal = displayMode == "Minimal (Clean)"
isTrading = displayMode == "Trading (Balanced)"
isFull    = displayMode == "Full (Everything)"

sz_tiny   = textScale == "Large" ? size.small  : textScale == "Normal" ? size.tiny   : size.tiny
sz_small  = textScale == "Large" ? size.normal : textScale == "Normal" ? size.small  : size.small
sz_normal = textScale == "Large" ? size.large  : textScale == "Normal" ? size.normal : size.small
sz_large  = textScale == "Large" ? size.huge   : textScale == "Normal" ? size.large  : size.normal

// ═══════════════════════════════════════════════════════════════
// 📋 INPUTS
// ═══════════════════════════════════════════════════════════════
grpMTF = "🕐 Multi-Timeframe"
htf1 = input.timeframe("60", "HTF #1", group=grpMTF)
htf2 = input.timeframe("240", "HTF #2", group=grpMTF)
htf3 = input.timeframe("D", "HTF #3", group=grpMTF)
showMTFTable = input.bool(true, "Dashboard", group=grpMTF)
tablePosition = input.string("Top Right", "Position", options=["Top Right", "Top Left", "Middle Right", "Bottom Right", "Bottom Left"], group=grpMTF)

grpStruct = "📊 Market Structure"
// v15 P0-1: intSwingLen is PRIMARY driver, swingLen demoted to HTF context only
intSwingLen = input.int(3, "Primary Pivot Length (entry MSS)", minval=2, maxval=10, group=grpStruct, tooltip="v15: PRIMARY trend driver. Short pivots used for both internalTrend and entry MSS. Cuts repaint lag from 8 bars (v14) to 3 bars.")
swingLen = input.int(8, "HTF Context Pivot Length", minval=3, maxval=50, group=grpStruct, tooltip="v15: now HTF-context only — used for trendlines, PD freeze, Fib anchor. NOT used for entry confluence trend.")
useInternalMSS = input.bool(true, "Require MSS at entry", group=grpStruct)
showBOS_user = input.bool(true, "Show BOS", group=grpStruct)
showCHoCH_user = input.bool(true, "Show CHoCH", group=grpStruct)
showSwings_user = input.bool(false, "Swing Labels", group=grpStruct)
maxStructLabels = input.int(3, "Max BOS/CHoCH labels", minval=1, maxval=10, group=grpStruct)
useWickForBOS = input.bool(false, "Wick for BOS (vs close)", group=grpStruct)
firstShiftAsCHoCH = input.bool(true, "First shift = CHoCH", group=grpStruct)
// v23 ISSUE-2: dedicated ENTRY-structure pivot. Display BOS/CHoCH stay on the fast pivot-3 track,
// but entry MSS now requires a higher-quality swing so entries stop firing on micro-noise.
entrySwingSel = input.string("5", "Entry Structure Pivot (MSS)", options=["5", "8", "12"], group=grpStruct, tooltip="v23 ISSUE-2: pivot length used ONLY for entry MSS qualification. Higher = fewer, cleaner entries. Display structure still uses Primary Pivot Length.")
entrySwingLen = entrySwingSel == "12" ? 12 : entrySwingSel == "8" ? 8 : 5

grpTrend = "📈 Trendlines"
showTrendlines_user = input.bool(true, "Trendlines", group=grpTrend)
trendlineExtend = input.bool(false, "Extend forward", group=grpTrend)
maxTrendlines = input.int(2, "Max active per side", minval=1, maxval=4, group=grpTrend)
breakTrendline_user = input.bool(true, "Mark TL break", group=grpTrend)
trendlineMaxAgeBars = input.int(200, "TL max age", minval=20, maxval=1000, group=grpTrend)
trendlineWidth = input.int(3, "TL width", minval=1, maxval=5, group=grpTrend)
trendlineStyle = input.string("Solid", "TL style", options=["Solid", "Dashed", "Dotted"], group=grpTrend)
trendlineGlow = input.bool(true, "Glow", group=grpTrend)
tlBreakMarker = input.string("Tick mark", "TL break marker", options=["Full label", "Tick mark", "Hidden"], group=grpTrend)

grpCleanUI = "✨ Clean UI"
cleanMode = input.bool(false, "Clean UI", group=grpCleanUI)
shortExtensionLines = input.int(5, "Liq label extension", minval=2, maxval=20, group=grpCleanUI)
dedupeSweepLabels = input.bool(true, "Dedupe sweep labels", group=grpCleanUI)
sweepMarkerStyle = input.string("Compact triangle", "Sweep marker", options=["Full label", "Compact triangle", "Diamond only"], group=grpCleanUI)

grpFibR = "📐 Fibonacci"
showFibRet_user = input.bool(true, "Show Fib", group=grpFibR)
// v15 P2-10: Fib anchor option
fibAnchorMode = input.string("CHoCH leg (frozen)", "Fib anchor", options=["CHoCH leg (frozen)", "Last swings (legacy)"], group=grpFibR, tooltip="v15: Frozen-PD anchor matches displayed PD zones. Legacy = v14 behavior.")

grpOB = "🟦 Order Block"
showOB_user = input.bool(true, "Show OBs", group=grpOB)
obMaxBoxes = input.int(4, "Max Active OBs", minval=1, maxval=10, group=grpOB)
obStrength = input.float(0.5, "OB Min Body/Range", minval=0.3, maxval=0.8, step=0.05, group=grpOB)
obImpulseATR = input.float(1.0, "OB Min Impulse (× ATR)", minval=0.2, maxval=5.0, step=0.1, group=grpOB)
obLookback = input.int(3, "OB lookback bars", minval=1, maxval=8, group=grpOB)
hideMitigatedLabels = input.bool(true, "Hide mitigated labels", group=grpOB)
obOpacity = input.int(75, "OB Opacity", minval=50, maxval=95, group=grpOB)
obMitigationMode = input.string("50% fill", "OB mit mode", options=["Touch", "50% fill", "Full fill"], group=grpOB)
obRequireBOS = input.bool(true, "Strict: require BOS/CHoCH", group=grpOB)
distinguishMB = input.bool(true, "Tag MB vs OB", group=grpOB)
// v15 P2-11: MB recency exposed
mbRecencyBars = input.int(10, "MB recency bars (post-CHoCH)", minval=3, maxval=30, group=grpOB, tooltip="OBs formed within N bars of CHoCH labeled MB.")

grpBreaker = "🟥 Breaker Blocks"
showBreaker = input.bool(true, "Show Breakers", group=grpBreaker)
breakerOpacity = input.int(70, "Breaker Opacity", minval=50, maxval=95, group=grpBreaker)
breakerMaxAge = input.int(150, "Breaker max age", minval=20, maxval=500, group=grpBreaker)
// v15 P2-11: Pending breaker age exposed
breakerPendingAge = input.int(30, "Pending breaker max age", minval=5, maxval=200, group=grpBreaker, tooltip="Bars OB has after mitigation to break and promote to Breaker, else dropped.")

grpFVG = "📐 FVG"
showFVG_user = input.bool(true, "Show FVG", group=grpFVG)
showBPR_user = input.bool(false, "Show BPR", group=grpFVG)
fvgMinSizeMode = input.string("ATR fraction", "Min FVG size mode", options=["ATR fraction", "Percent"], group=grpFVG)
fvgMinSizeAtr = input.float(0.10, "Min FVG size (× ATR)", minval=0.0, maxval=2.0, step=0.05, group=grpFVG)
fvgMinSize = input.float(0.05, "Min FVG Size % (legacy)", minval=0.0, step=0.05, group=grpFVG)
maxFVGs = input.int(4, "Max active FVGs", minval=1, maxval=10, group=grpFVG)
showFVGLabels = input.bool(true, "FVG labels", group=grpFVG)
trackFVGMitigation = input.bool(true, "Track mitigation", group=grpFVG)
fvgMitigationMode = input.string("50% fill", "Mit threshold", options=["Touch", "50% fill", "Full fill"], group=grpFVG)
fvgDisplacementATR = input.float(1.5, "Min displacement (× ATR)", minval=0.3, maxval=5.0, step=0.1, group=grpFVG)
showInversionFVG = input.bool(true, "iFVG", group=grpFVG)
// v15 P2-11: iFVG age, pending age exposed
ifvgMaxAge = input.int(60, "iFVG max age", minval=10, maxval=500, group=grpFVG)
fvgPendingAge = input.int(20, "FVG pending-inversion age", minval=5, maxval=100, group=grpFVG)

grpPD = "💎 Premium/Discount"
showPD_user = input.bool(true, "PD Zones", group=grpPD)

grpLiq = "💧 Liquidity"
showLiq_user = input.bool(true, "Liquidity Levels", group=grpLiq)
liqToleranceMode = input.string("ATR fraction", "Equal H/L mode", options=["ATR fraction", "Percent"], group=grpLiq)
liqTolerance = input.float(0.08, "Equal H/L %", minval=0.01, step=0.01, group=grpLiq)
liqToleranceAtr = input.float(0.3, "Equal H/L (× ATR)", minval=0.05, maxval=2.0, step=0.05, group=grpLiq)
detectSweeps = input.bool(true, "Detect sweeps", group=grpLiq)
detectLiqGrabs = input.bool(true, "Detect grabs", group=grpLiq)
sweepMinRange = input.float(0.5, "Sweep min sig (× ATR)", minval=0.1, maxval=5.0, step=0.1, group=grpLiq)

grpPattern = "🔷 Patterns"
showPatterns_user = input.bool(true, "Patterns", group=grpPattern)
showPinBar = input.bool(true, "Pin Bar", group=grpPattern)
showDoubleTB = input.bool(true, "Double T/B", group=grpPattern)
pinBarRatio = input.float(1.8, "Pin Ratio", minval=1.2, step=0.1, group=grpPattern)
// v15 P2-11: Pin min body exposed
pinMinBodyAtr = input.float(0.05, "Pin min body (× ATR)", minval=0.0, maxval=0.5, step=0.01, group=grpPattern, tooltip="v15: was hardcoded 0.10. Lowered default to 0.05 — pins typically small body.")
showTurtleSoup = input.bool(true, "Turtle Soup", group=grpPattern)
turtleSoupLookback = input.int(20, "TS lookback", minval=5, maxval=100, group=grpPattern)

grpHTFPOI = "🔭 HTF POI"
useHTFPOI = input.bool(true, "Detect HTF POI", group=grpHTFPOI)
htfPOITF = input.timeframe("240", "HTF for POI", group=grpHTFPOI)
htfPOIWeight = input.int(3, "HTF POI weight", minval=1, maxval=5, group=grpHTFPOI)
useHTFOB = input.bool(true, "Include HTF OBs", group=grpHTFPOI)

grpOpens = "🕛 Reference Opens"
showDailyOpen = input.bool(true, "Daily Open", group=grpOpens)
showWeeklyOpen = input.bool(true, "Weekly Open", group=grpOpens)
showMidnightOpen = input.bool(true, "NY Midnight Open", group=grpOpens)
openLineWidth = input.int(2, "Open line width", minval=1, maxval=4, group=grpOpens)
openLineExtend = input.bool(true, "Extend right", group=grpOpens)

grpPrev = "📍 Prev Day/Week"
showPDH = input.bool(true, "PDH/PDL", group=grpPrev)
showPWH = input.bool(true, "PWH/PWL", group=grpPrev)
prevLineWidth = input.int(1, "Line width", minval=1, maxval=3, group=grpPrev)
prevLineExtend = input.bool(true, "Extend right", group=grpPrev)

grpSessLevels = "🏷️ Session H/L"
showSessionLevels = input.bool(true, "Persist session H/L", group=grpSessLevels)
sessLevelWidth = input.int(1, "Line width", minval=1, maxval=3, group=grpSessLevels)

grpOTE = "📐 OTE"
showOTEZone = input.bool(true, "Shade OTE", group=grpOTE)
oteOpacity = input.int(90, "OTE opacity", minval=80, maxval=99, group=grpOTE)

grpAMD = "🌀 AMD / Power of 3"
detectAMD = input.bool(true, "Detect AMD", group=grpAMD)
amdMinRangeATR = input.float(0.5, "Min Asia range (× ATR)", minval=0.1, maxval=5.0, step=0.1, group=grpAMD)

grpVol = "📊 Volume"
useVolConfirm = input.bool(true, "Volume confluence", group=grpVol)
volMaLen = input.int(20, "Vol MA len", minval=5, maxval=100, group=grpVol)
volMult = input.float(1.5, "Vol multiplier", minval=1.0, maxval=5.0, step=0.1, group=grpVol)

grpSess = "🌍 Sessions"
showSessions_user = input.bool(true, "Session Boxes", group=grpSess)
asiaSession = input.session("2000-0000", "Asia", group=grpSess)
londonSession = input.session("0200-0500", "London", group=grpSess)
nySession = input.session("0700-1000", "NY", group=grpSess)
sessionOpacity = input.int(93, "Session Opacity", minval=85, maxval=99, group=grpSess)
sessionTimezone = input.string("America/New_York", "Timezone", options=["America/New_York", "Europe/London", "Asia/Tokyo", "UTC"], group=grpSess)

grpKZ = "⚡ Kill Zones"
showKillzones_user = input.bool(true, "KZ background", group=grpKZ)
londonKZ = input.session("0200-0500", "London KZ", group=grpKZ)
nyKZ = input.session("0830-1100", "NY AM KZ", group=grpKZ)
// v23 FIX-#7 honesty: this is the Silver Bullet KZ WINDOW only (background + "window opened" alert).
// No dedicated SB setup logic (1st presented FVG after the window opens) is implemented. inSilverBullet
// feeds the Timing confluence cap like any other KZ — it is not a standalone SB entry signal.
silverBulletKZ = input.session("1000-1100", "Silver Bullet", group=grpKZ)
nyPmKZ = input.session("1400-1600", "NY PM", group=grpKZ)  // v18 FIX-9: ICT canonical NY PM = 14:00-16:00, was 13:30
kzOpacity = input.int(92, "KZ Opacity", minval=85, maxval=98, group=grpKZ)

grpSig = "🕯️ Signals"
showEngulf = input.bool(true, "Show Signals", group=grpSig)
requireConfluence = input.bool(true, "Require Confluence", group=grpSig)
minConfluence = input.int(5, "Min Confluence", minval=1, maxval=25, group=grpSig, tooltip="v23 ISSUE-3: rescaled for the orthogonal score (attainable max ~9 on FX, ~12 with SMT+vol). 5 ≈ prior selectivity. Re-optimize per instrument.")
killzoneBoostConfluence = input.bool(true, "+1 in KZ", group=grpSig)
signalCooldownBars = input.int(12, "Cooldown bars", minval=0, maxval=100, group=grpSig)
waitForBarClose = input.bool(true, "Bar-close only", group=grpSig)
// v23 ISSUE-6: master non-repaint switch. When ON (default), entries are FORCED to confirmed bars
// regardless of "Bar-close only", removing the repaint footgun. Turn OFF only for experimental
// intrabar testing — results then repaint and are NOT trustworthy for live or prop evaluation.
institutionalMode = input.bool(true, "Institutional Mode (force confirmed bars — non-repaint)", group=grpSig, tooltip="v23 ISSUE-6: hard-forces barstate.isconfirmed on all entries. Disable only for experimental intrabar testing.")
useGlobalCooldown = input.bool(true, "Global cooldown", group=grpSig)
includePinBarSignals = input.bool(true, "Pin signals", group=grpSig)
includeSweepSignals = input.bool(true, "Sweep signals", group=grpSig)
signalLabelSize = input.string("Small", "Label size", options=["Tiny", "Small", "Normal", "Large"], group=grpSig)
signalLabelStyle = input.string("Compact", "Label style", options=["Compact", "Full text"], group=grpSig)

grpPos = "📈 Position"
enablePositions = input.bool(true, "Track Positions", group=grpPos)
showPositionLines = input.bool(true, "Trade Lines", group=grpPos)
showPnL = input.bool(true, "Live P&L", group=grpPos)
allowFlip = input.bool(true, "Allow Flip", group=grpPos)
minFlipDelta = input.int(2, "Min flip advantage", minval=1, maxval=5, group=grpPos)
killzoneOnly = input.bool(false, "Only enter in KZ", group=grpPos)
compactExitLabels = input.bool(true, "Compact exits", group=grpPos)
rightLabelOffset = input.int(30, "Right offset", minval=15, maxval=60, group=grpPos)
trackFlipPnL = input.bool(true, "P&L on flip", group=grpPos)
trackRealizedPnL = input.bool(true, "Include realized", group=grpPos)
// v15 P1-7: Fill mode default Next bar open — applies to BOTH initial entries AND flips
fillMode = input.string("Next bar open", "Backtest fill mode", options=["Next bar open", "Signal close (legacy)"], group=grpPos, tooltip="v15: Next-bar-open is realistic. Signal-close = legacy v14 default = optimistic.")

// v15 P0-3: Position sizing
grpSize = "💼 Position Sizing (v15)"
useSizing = input.bool(true, "Calculate position size", group=grpSize)
accountEquity = input.float(10000.0, "Account equity ($)", minval=100.0, step=100.0, group=grpSize)
riskPctEquity = input.float(1.0, "Risk per trade (%)", minval=0.1, maxval=10.0, step=0.1, group=grpSize)
sizingMode = input.string("Units", "Sizing output", options=["Units", "Lots (forex)", "Contracts"], group=grpSize, tooltip="Units = generic. Lots = forex (100k units = 1 lot). Contracts = futures.")
forexLotSize = input.float(100000.0, "Forex lot size", minval=1000.0, step=1000.0, group=grpSize)
// MED-fix: account base currency exposed (was hardcoded "USD" inside valuePerPoint conversion).
acctCurrency = input.string("USD", "Account currency", options=["USD","EUR","GBP","JPY","AUD","CAD","CHF","NZD"], group=grpSize, tooltip="Account base currency for the sizing / P&L → account-currency conversion (valuePerPoint). Was hardcoded USD; non-USD accounts previously mis-sized silently.")

// v16 H1 fix: trading-cost model (spread + commission). Indicator can't use strategy() costs,
// so round-trip cost (price units) is subtracted proportionally at each partial close.
grpCosts = "💸 Trading Costs (v16)"
useCosts      = input.bool(true, "Apply spread + commission to P&L", group=grpCosts, tooltip="Scalp targets are small — ignoring spread massively inflates results.")
costSpreadMode = input.string("Pips (forex)", "Spread unit", options=["Pips (forex)", "Ticks", "Price"], group=grpCosts)
costSpreadVal = input.float(1.0, "Spread (round-trip)", minval=0.0, step=0.1, group=grpCosts, tooltip="Typical entry spread; charged once per round trip.")
costCommPrice = input.float(0.0, "Extra commission (price/unit, round-trip)", minval=0.0, step=0.01, group=grpCosts, tooltip="Optional broker commission expressed in price per unit, round trip.")

grpRR = "💰 Risk"
slMode = input.string("Swing-based", "SL Method", options=["Swing-based", "Previous candle", "ATR-based"], group=grpRR)
atrLen = input.int(14, "ATR Length", minval=5, group=grpRR)
atrMult = input.float(1.5, "ATR SL Mult", minval=0.5, step=0.1, group=grpRR)
rrRatio = input.float(3.0, "Target R:R (TP3)", minval=1.0, step=0.5, group=grpRR)
rrTP1 = input.float(1.0, "TP1 R-ratio", minval=0.5, maxval=10.0, step=0.5, group=grpRR)
rrTP2 = input.float(2.0, "TP2 R-ratio", minval=0.5, maxval=10.0, step=0.5, group=grpRR)
useMultiTP = input.bool(true, "Multi-TP", group=grpRR)
partialTP1 = input.float(50.0, "TP1 close %", minval=0, maxval=100, step=5, group=grpRR)
partialTP2 = input.float(30.0, "TP2 close %", minval=0, maxval=100, step=5, group=grpRR)
// v16 C3 fix: clamp partial-close fractions so TP1+TP2 can never exceed 100%
// (was allowing 200% → posSizeRemaining went negative → final exit P&L flipped sign)
tp1Frac = math.min(1.0, partialTP1 / 100.0)
tp2Frac = math.min(1.0 - tp1Frac, partialTP2 / 100.0)
moveToBreakeven = input.bool(false, "BE after TP1", group=grpRR)
useStructTrail = input.bool(true, "Struct trail after TP2", group=grpRR)
shadeRRZones = input.bool(true, "Shade R:R", group=grpRR)
slBufferMode = input.string("ATR fraction", "SL Buffer mode", options=["ATR fraction", "Pips (forex)"], group=grpRR)
slBufferAtrFrac = input.float(0.1, "SL Buffer (× ATR)", minval=0.0, maxval=2.0, step=0.05, group=grpRR)
slBufferPips = input.float(2.0, "SL Buffer pips", minval=0.0, step=0.5, group=grpRR)
beBufferAtr = input.float(0.15, "BE buffer (× ATR)", minval=0.0, maxval=1.0, step=0.05, group=grpRR)

// v15 P1-4: Same-bar TP/SL resolution mode
grpAmbig = "⚖️ Same-bar SL/TP (v15)"
// v22 MED-5: default SL-first (pessimistic) — realistic/conservative for prop & backtest integrity.
ambigMode = input.string("SL-first (pessimistic)", "Resolution", options=["SL-first (pessimistic)", "Tick-approx by candle open", "TP-first (optimistic)"], group=grpAmbig, tooltip="When same bar touches both SL and TP, which counts first. SL-first = conservative default.")

// v19 SMT
grpSMT = "🔀 SMT Divergence (v19)"
useSMT         = input.bool(false, "SMT Divergence", group=grpSMT, tooltip="Smart Money Tool: detect when a correlated pair diverges at swing extremes — strong reversal signal.")
smtPair        = input.symbol("GBPUSD", "Correlated pair", group=grpSMT)
smtSwingLen    = input.int(5, "SMT pivot length", minval=2, maxval=20, group=grpSMT)
smtWeight      = input.int(2, "SMT confluence weight", minval=1, maxval=4, group=grpSMT)

// v19 Max Drawdown
grpDD = "🚨 Max Drawdown Circuit (v19)"
useMaxDrawdown = input.bool(true, "Max drawdown circuit breaker", group=grpDD, tooltip="Stop all new entries when equity draws down past threshold from peak.")
maxDrawdownPct = input.float(10.0, "Max drawdown % from peak", minval=1.0, maxval=50.0, step=1.0, group=grpDD)

// v19 Slippage
grpSlip = "🏃 Slippage (v19)"
costSlippageVal = input.float(0.5, "Slippage (same unit as spread, round-trip)", minval=0.0, step=0.1, group=grpSlip, tooltip="v19: Additional slippage beyond spread. In scalping, 0.5–1.5 pips typical.")

// v19 Max Lot Cap
grpLotCap = "🔒 Position Cap (v19)"
useLotCap   = input.bool(true, "Cap position size", group=grpLotCap)
maxLotsCap  = input.float(10.0, "Max units/lots per trade", minval=0.01, step=0.1, group=grpLotCap, tooltip="Hard ceiling on position size regardless of equity/risk calculation.")

// ⚖️ Margin Guard — v22: leverage feeds the MED-6 hard margin block below
grpMargin = "⚖️ Margin Guard"
accountLeverage = input.float(100.0, "Account leverage (1:N)", minval=1.0, maxval=500.0, step=10.0, group=grpMargin, tooltip="Broker leverage. Used by the hard margin block to estimate margin % per trade.")
// v22 MED-6: hard margin gate — reject entries whose estimated margin exceeds the cap.
useMarginBlock  = input.bool(true,  "Block entry if margin > cap", group=grpMargin, tooltip="Hard gate: an entry whose estimated margin (notional / (equity × leverage)) exceeds marginMaxPct is rejected. Catches lot-cap oversizing on tight stops.")
marginMaxPct    = input.float(50.0, "Max margin % per trade (block)", minval=1.0, maxval=100.0, step=1.0, group=grpMargin)

grpAlert = "🔔 Alerts"
alertOnlyConfluence = input.bool(true, "Confluence only", group=grpAlert)

grpRange = "🌊 Range Filter"
useRangeFilter = input.bool(true, "Suppress chop", group=grpRange)
adxLenRng = input.int(14, "ADX length", minval=5, maxval=50, group=grpRange)
adxMinRng = input.float(18.0, "Min ADX", minval=10.0, maxval=40.0, step=1.0, group=grpRange)
atrPctlLen = input.int(100, "ATR pctl lookback", minval=20, maxval=500, group=grpRange)
atrPctlMin = input.float(25.0, "Min ATR pctl %", minval=5.0, maxval=80.0, step=5.0, group=grpRange)
// v15 P2-8: AND vs OR mode
rangeFilterMode = input.string("AND (stricter)", "Combine ADX + ATR", options=["AND (stricter)", "OR (legacy)"], group=grpRange, tooltip="v15 default AND — only flag chop when BOTH ADX low AND ATR pctl low. Legacy = OR.")

grpHardGate = "🚦 Hard Gate"
useHardGate = input.bool(true, "Enforce hard filters", group=grpHardGate)
hgRequireHTF = input.bool(true, "HTF align ≥2/3", group=grpHardGate)
hgRequireZone = input.bool(true, "PD zone match", group=grpHardGate)
hgRequireKZ = input.bool(false, "Require KZ", group=grpHardGate)
hgRequireLiq = input.bool(true, "Recent liq event", group=grpHardGate)
hgLiqLookback = input.int(8, "Liq lookback", minval=1, maxval=50, group=grpHardGate)
hgRequireVol = input.bool(true, "Healthy vol", group=grpHardGate)

_isForexOrOTC = syminfo.type == "forex" or str.contains(str.lower(syminfo.ticker), "otc")
_isOTC        = str.contains(str.lower(syminfo.ticker), "otc")

grpDisp = "💥 Displacement"
useDisplacement = input.bool(true, "Require displacement", group=grpDisp)
dispBodyAtr = input.float(0.5, "Min body (× ATR)", minval=0.1, maxval=3.0, step=0.05, group=grpDisp)
// v15 P1-5: Decouple from pin signals
dispAppliesToPins = input.bool(false, "Apply displacement to pin signals", group=grpDisp, tooltip="v15: default OFF. Pins naturally have small bodies — displacement filter would kill them.")

// v23 ISSUE-5: honestly renamed. This is a STATIC CLOCK blackout (fixed NY HHMM windows), NOT a
// live economic-calendar feed. It cannot know actual release times, surprises, or holiday shifts.
// Identifiers kept (useNewsBlocker/newsWindows/newsBufferMin/f_inNewsWindow/newsBlocked) for
// internal compatibility; only the displayed labels changed.
// FUTURE: integrate a real event feed — e.g. request.economic("US","NFP")/("US","CPI") or an
//         external calendar via request.security on a custom symbol — and gate entries on it.
grpNews = "🕒 Time Blackout Filter"
useNewsBlocker = input.bool(true, "Enable time blackout", group=grpNews, tooltip="v23 ISSUE-5: STATIC clock blackout around fixed NY times — NOT a real economic-calendar feed. Set windows to your session's known high-impact release clock times.")
newsWindows = input.string("0830,1000,1400", "Blackout times — HHMM list (NY)", group=grpNews, tooltip="Comma-separated NY clock times to avoid (e.g. 0830 NFP/CPI, 1000 ISM, 1400 FOMC). Static — does not auto-detect actual releases.")
newsBufferMin = input.int(15, "Blackout buffer ± min", minval=1, maxval=60, group=grpNews)

grpGuard = "🛡️ Risk Guards"
useDailyLossCap = input.bool(true, "Daily loss cap (blocks new entries)", group=grpGuard)
dailyLossR = input.float(-2.0, "Daily entry-block (R)", maxval=-0.5, step=0.5, group=grpGuard, tooltip="MED-fix honesty: once the day's realized+open R reaches this, NEW entries are blocked for the rest of the trading day. It does NOT force-close an already-open trade — that exits on its own SL/TP. The companion smc_strategy.pine additionally force-closes at this cap.")
// FIX-3 (audit HIGH-4): FX prop day resets at 17:00 NY rollover, not chart-exchange midnight.
// Daily-loss + consecutive-loss counters reset on this anchor. Use Midnight for crypto/24-7.
dailyResetAnchor = input.string("17:00 New York (FX rollover)", "Daily reset anchor", options=["17:00 New York (FX rollover)", "Chart exchange midnight"], group=grpGuard, tooltip="FIX-3: FX/prop day boundary is 17:00 NY. Midnight option for crypto/indices on exchange clock.")
useMaxTradesKZ = input.bool(true, "Max trades per KZ", group=grpGuard)
maxTradesPerKZ = input.int(2, "Max trades per KZ", minval=1, maxval=10, group=grpGuard)
// AUDIT FIX-3 (KZ-cap inert outside KZ): the KZ cap short-circuited true when not inAnyKZ,
// leaving trades OUTSIDE kill zones uncapped (chop over-trading when killzoneOnly=false).
// maxTradesPerDay bounds entries on bars that are not in any KZ. Same useMaxTradesKZ toggle.
maxTradesPerDay = input.int(6, "Max trades per day (non-KZ bound)", minval=1, maxval=50, group=grpGuard, tooltip="AUDIT FIX: caps entries on bars not inside any kill zone, where the per-KZ cap does not apply. Reset on the daily anchor.")
// v15 NEW guard: max consecutive losses
useMaxConsecLosses = input.bool(true, "Max consecutive losses cutoff", group=grpGuard)
maxConsecLosses = input.int(3, "Max consec losses", minval=2, maxval=10, group=grpGuard)

// v15 P2-9: POI age decay
grpAge = "⏳ POI Age Decay (v15)"
usePOIAgeDecay = input.bool(true, "Age-decay POI weight", group=grpAge, tooltip="POIs older than threshold contribute less to confluence.")
poiFreshBars = input.int(30, "Fresh POI threshold", minval=5, maxval=200, group=grpAge)
poiStaleBars = input.int(80, "Stale POI threshold", minval=20, maxval=500, group=grpAge, tooltip="POI older than this scores 0 instead of +2.")

// PRESET OVERRIDES
showSwings     = showSwings_user and isFull
showBOS        = showBOS_user
showCHoCH      = showCHoCH_user
showTrendlines = showTrendlines_user and not isMinimal
breakTrendline = breakTrendline_user and not isMinimal
showFibRet     = showFibRet_user
showOB         = showOB_user and not isMinimal
showFVG        = showFVG_user and not isMinimal
showBPR        = showBPR_user and isFull
showPD         = showPD_user
showLiq        = showLiq_user and not isMinimal
showPatterns   = showPatterns_user and not isMinimal
showSessions   = showSessions_user
showKillzones  = showKillzones_user

C_TEXT_MAIN    = darkMode ? C_TEXT_LIGHT : C_TEXT_DARK
C_BG_TABLE     = darkMode ? #0D1117 : #FFFFFF
C_BG_TABLE_ALT = darkMode ? #161B22 : #F6F8FA
C_BG_HEADER    = darkMode ? #21262D : #1A1F2E
C_BORDER_TBL   = darkMode ? #30363D : #D1D5DB

// ═══════════════════════════════════════════════════════════════
// HOISTED HELPERS — must be defined before first use (sessions call f_pushMisc)
// ═══════════════════════════════════════════════════════════════
_clampBar(_b) => not na(_b) and (bar_index - _b) > 4900 ? bar_index - 4900 : _b

var label[] _miscLabels = array.new<label>()
f_pushMisc(lbl) =>
    array.push(_miscLabels, lbl)
    if array.size(_miscLabels) > 50
        label.delete(array.shift(_miscLabels))

var line[] _miscLines = array.new<line>()
f_pushMiscLine(ln) =>
    array.push(_miscLines, ln)
    if array.size(_miscLines) > 50
        line.delete(array.shift(_miscLines))

// v20 FIX-1: separate exit label pool (TP1/TP2/TP3/SL/flip labels)
var label[] _exitLabels = array.new<label>()
f_pushExit(lbl) =>
    array.push(_exitLabels, lbl)
    if array.size(_exitLabels) > 80
        label.delete(array.shift(_exitLabels))

// v15 P3-13: Generic price-in-boxes helper
f_priceInBoxes(_boxArr, _mitArr) =>
    inside = false
    _bSize = array.size(_boxArr)
    _hasMit = array.size(_mitArr) == _bSize and _bSize > 0
    if _bSize > 0
        for i = 0 to _bSize - 1
            _skip = false
            if _hasMit
                _skip := array.get(_mitArr, i)
            if not _skip
                b = array.get(_boxArr, i)
                _top = box.get_top(b)
                _bot = box.get_bottom(b)
                if low <= _top and high >= _bot
                    inside := true
                    break
    inside

// v15 P2-9: POI age-decay scoring
f_poiAgeWeight(_createdBar) =>
    _age = bar_index - _createdBar
    not usePOIAgeDecay or _age <= poiFreshBars ? 2 : _age <= poiStaleBars ? 1 : 0

// ═══════════════════════════════════════════════════════════════
// SESSIONS & KILL ZONES
// ═══════════════════════════════════════════════════════════════
f_inSession(_sess) => not na(time(timeframe.period, _sess, sessionTimezone))

inAsia         = f_inSession(asiaSession)
inLondon       = f_inSession(londonSession)
inNY           = f_inSession(nySession)
inLondonKZ     = f_inSession(londonKZ)
inNyKZ         = f_inSession(nyKZ)
inSilverBullet = f_inSession(silverBulletKZ)
inNyPmKZ       = f_inSession(nyPmKZ)
inAnyKZ        = inLondonKZ or inNyKZ or inSilverBullet or inNyPmKZ

var box asiaBox = na, var float asiaHi = na, var float asiaLo = na
var box londonBox = na, var float londonHi = na, var float londonLo = na
var box nyBox = na, var float nyHi = na, var float nyLo = na

// v16 H3 fix: track session H/L whenever boxes OR persistent levels are enabled.
// Box drawing stays gated by showSessions; H/L math no longer depends on it.
_trackSess = showSessions or showSessionLevels
if _trackSess
    if inAsia and not inAsia[1]
        asiaHi := high
        asiaLo := low
        if showSessions
            asiaBox := box.new(bar_index, asiaHi, bar_index, asiaLo, bgcolor=color.new(C_ASIA, sessionOpacity), border_color=color.new(C_ASIA, 70), border_width=1)
            f_pushMisc(label.new(bar_index, high, " 🌏 ASIA ", color=C_ASIA, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small))
    else if inAsia and not na(asiaHi)
        asiaHi := math.max(asiaHi, high)
        asiaLo := math.min(asiaLo, low)
        if showSessions and not na(asiaBox)
            box.set_right(asiaBox, bar_index)
            box.set_top(asiaBox, asiaHi)
            box.set_bottom(asiaBox, asiaLo)

    if inLondon and not inLondon[1]
        londonHi := high
        londonLo := low
        if showSessions
            londonBox := box.new(bar_index, londonHi, bar_index, londonLo, bgcolor=color.new(C_LONDON, sessionOpacity), border_color=color.new(C_LONDON, 70), border_width=1)
            f_pushMisc(label.new(bar_index, high, " 🇬🇧 LONDON ", color=C_LONDON, textcolor=C_TEXT_BLACK, style=label.style_label_down, size=sz_small))
    else if inLondon and not na(londonHi)
        londonHi := math.max(londonHi, high)
        londonLo := math.min(londonLo, low)
        if showSessions and not na(londonBox)
            box.set_right(londonBox, bar_index)
            box.set_top(londonBox, londonHi)
            box.set_bottom(londonBox, londonLo)

    if inNY and not inNY[1]
        nyHi := high
        nyLo := low
        if showSessions
            nyBox := box.new(bar_index, nyHi, bar_index, nyLo, bgcolor=color.new(C_NY, sessionOpacity), border_color=color.new(C_NY, 70), border_width=1)
            f_pushMisc(label.new(bar_index, high, " 🇺🇸 NY ", color=C_NY, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small))
    else if inNY and not na(nyHi)
        nyHi := math.max(nyHi, high)
        nyLo := math.min(nyLo, low)
        if showSessions and not na(nyBox)
            box.set_right(nyBox, bar_index)
            box.set_top(nyBox, nyHi)
            box.set_bottom(nyBox, nyLo)

bgcolor(showKillzones and inLondonKZ     ? color.new(C_LONDON, kzOpacity)      : na, title="London KZ BG")
bgcolor(showKillzones and inNyKZ         ? color.new(C_NY, kzOpacity)          : na, title="NY AM KZ BG")
bgcolor(showKillzones and inSilverBullet ? color.new(C_PURPLE, kzOpacity - 3)  : na, title="Silver Bullet BG")
bgcolor(showKillzones and inNyPmKZ       ? color.new(C_PINK, kzOpacity)        : na, title="NY PM KZ BG")

if showKillzones and inLondonKZ and not inLondonKZ[1]
    f_pushMisc(label.new(bar_index, high, " ⚡ LONDON KZ ", color=C_LONDON, textcolor=C_TEXT_BLACK, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar))
if showKillzones and inNyKZ and not inNyKZ[1]
    f_pushMisc(label.new(bar_index, high, " ⚡ NY KZ ", color=C_NY, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar))
if showKillzones and inSilverBullet and not inSilverBullet[1]
    f_pushMisc(label.new(bar_index, high, " 🥈 SILVER BULLET ", color=C_PURPLE, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar))

// SESSION H/L PERSISTENCE
var float asiaSessHi_final = na, var float asiaSessLo_final = na
var float londonSessHi_final = na, var float londonSessLo_final = na
var float nySessHi_final = na, var float nySessLo_final = na
var int   asiaSessEndBar = na, var int londonSessEndBar = na, var int nySessEndBar = na
var line  asiaHiLine = na, var line asiaLoLine = na
var line  londonHiLine = na, var line londonLoLine = na
var line  nyHiLine = na, var line nyLoLine = na
var label asiaHiLbl = na, var label asiaLoLbl = na
var label londonHiLbl = na, var label londonLoLbl = na
var label nyHiLbl = na, var label nyLoLbl = na

if showSessionLevels
    if not inAsia and inAsia[1] and not na(asiaHi) and not na(asiaLo)
        asiaSessHi_final := asiaHi
        asiaSessLo_final := asiaLo
        asiaSessEndBar := bar_index
    if not inLondon and inLondon[1] and not na(londonHi) and not na(londonLo)
        londonSessHi_final := londonHi
        londonSessLo_final := londonLo
        londonSessEndBar := bar_index
    if not inNY and inNY[1] and not na(nyHi) and not na(nyLo)
        nySessHi_final := nyHi
        nySessLo_final := nyLo
        nySessEndBar := bar_index

if showSessionLevels and barstate.islast
    rightSessX = bar_index + 30
    if not na(asiaSessHi_final)
        if not na(asiaHiLine)
            line.delete(asiaHiLine)
        if not na(asiaLoLine)
            line.delete(asiaLoLine)
        if not na(asiaHiLbl)
            label.delete(asiaHiLbl)
        if not na(asiaLoLbl)
            label.delete(asiaLoLbl)
        _ax = _clampBar(asiaSessEndBar)
        asiaHiLine := line.new(_ax, asiaSessHi_final, rightSessX, asiaSessHi_final, color=color.new(C_ASIA, 40), width=sessLevelWidth, style=line.style_dotted, extend=extend.right)
        asiaLoLine := line.new(_ax, asiaSessLo_final, rightSessX, asiaSessLo_final, color=color.new(C_ASIA, 40), width=sessLevelWidth, style=line.style_dotted, extend=extend.right)
        asiaHiLbl := label.new(rightSessX, asiaSessHi_final, " ASIA H ", color=color.new(C_ASIA, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
        asiaLoLbl := label.new(rightSessX, asiaSessLo_final, " ASIA L ", color=color.new(C_ASIA, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
    if not na(londonSessHi_final)
        if not na(londonHiLine)
            line.delete(londonHiLine)
        if not na(londonLoLine)
            line.delete(londonLoLine)
        if not na(londonHiLbl)
            label.delete(londonHiLbl)
        if not na(londonLoLbl)
            label.delete(londonLoLbl)
        _lx = _clampBar(londonSessEndBar)
        londonHiLine := line.new(_lx, londonSessHi_final, rightSessX, londonSessHi_final, color=color.new(C_LONDON, 40), width=sessLevelWidth, style=line.style_dotted, extend=extend.right)
        londonLoLine := line.new(_lx, londonSessLo_final, rightSessX, londonSessLo_final, color=color.new(C_LONDON, 40), width=sessLevelWidth, style=line.style_dotted, extend=extend.right)
        londonHiLbl := label.new(rightSessX, londonSessHi_final, " LON H ", color=color.new(C_LONDON, 30), textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_tiny)
        londonLoLbl := label.new(rightSessX, londonSessLo_final, " LON L ", color=color.new(C_LONDON, 30), textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_tiny)
    if not na(nySessHi_final)
        if not na(nyHiLine)
            line.delete(nyHiLine)
        if not na(nyLoLine)
            line.delete(nyLoLine)
        if not na(nyHiLbl)
            label.delete(nyHiLbl)
        if not na(nyLoLbl)
            label.delete(nyLoLbl)
        _nx = _clampBar(nySessEndBar)
        nyHiLine := line.new(_nx, nySessHi_final, rightSessX, nySessHi_final, color=color.new(C_NY, 40), width=sessLevelWidth, style=line.style_dotted, extend=extend.right)
        nyLoLine := line.new(_nx, nySessLo_final, rightSessX, nySessLo_final, color=color.new(C_NY, 40), width=sessLevelWidth, style=line.style_dotted, extend=extend.right)
        nyHiLbl := label.new(rightSessX, nySessHi_final, " NY H ", color=color.new(C_NY, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
        nyLoLbl := label.new(rightSessX, nySessLo_final, " NY L ", color=color.new(C_NY, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)

// ═══════════════════════════════════════════════════════════════
// PDH/PDL, PWH/PWL
// ═══════════════════════════════════════════════════════════════
[_pdh, _pdl] = request.security(syminfo.tickerid, "D", [high[1], low[1]], lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)
[_pwh, _pwl] = request.security(syminfo.tickerid, "W", [high[1], low[1]], lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)

var line  pdhLine = na, var label pdhLbl = na
var line  pdlLine = na, var label pdlLbl = na
var line  pwhLine = na, var label pwhLbl = na
var line  pwlLine = na, var label pwlLbl = na

isNewDayForPrev = ta.change(time("D")) != 0
var int prevDayStartBar = 0
if isNewDayForPrev
    prevDayStartBar := bar_index

isNewWeekForPrev = ta.change(time("W")) != 0
var int prevWeekStartBar = 0
if isNewWeekForPrev
    prevWeekStartBar := bar_index

if barstate.islast
    rightPrevX = prevLineExtend ? bar_index + 50 : bar_index
    startBar = _clampBar(prevDayStartBar)
    if showPDH and not na(_pdh)
        if not na(pdhLine)
            line.delete(pdhLine)
        if not na(pdhLbl)
            label.delete(pdhLbl)
        pdhLine := line.new(startBar, _pdh, rightPrevX, _pdh, color=color.new(C_BEAR, 30), width=prevLineWidth, style=line.style_solid, extend=prevLineExtend ? extend.right : extend.none)
        pdhLbl := label.new(rightPrevX, _pdh, " PDH " + str.tostring(_pdh, format.mintick) + " ", color=color.new(C_LBL_BEAR, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
    if showPDH and not na(_pdl)
        if not na(pdlLine)
            line.delete(pdlLine)
        if not na(pdlLbl)
            label.delete(pdlLbl)
        pdlLine := line.new(startBar, _pdl, rightPrevX, _pdl, color=color.new(C_BULL, 30), width=prevLineWidth, style=line.style_solid, extend=prevLineExtend ? extend.right : extend.none)
        pdlLbl := label.new(rightPrevX, _pdl, " PDL " + str.tostring(_pdl, format.mintick) + " ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
    weekStartBar = _clampBar(prevWeekStartBar)
    if showPWH and not na(_pwh)
        if not na(pwhLine)
            line.delete(pwhLine)
        if not na(pwhLbl)
            label.delete(pwhLbl)
        pwhLine := line.new(weekStartBar, _pwh, rightPrevX, _pwh, color=color.new(C_BEAR, 20), width=prevLineWidth + 1, style=line.style_dashed, extend=prevLineExtend ? extend.right : extend.none)
        pwhLbl := label.new(rightPrevX, _pwh, " PWH " + str.tostring(_pwh, format.mintick) + " ", color=color.new(C_LBL_BEAR, 20), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
    if showPWH and not na(_pwl)
        if not na(pwlLine)
            line.delete(pwlLine)
        if not na(pwlLbl)
            label.delete(pwlLbl)
        pwlLine := line.new(weekStartBar, _pwl, rightPrevX, _pwl, color=color.new(C_BULL, 20), width=prevLineWidth + 1, style=line.style_dashed, extend=prevLineExtend ? extend.right : extend.none)
        pwlLbl := label.new(rightPrevX, _pwl, " PWL " + str.tostring(_pwl, format.mintick) + " ", color=color.new(C_LBL_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)

// REFERENCE OPENS
var line  dailyOpenLine = na, var label dailyOpenLbl = na
var line  weeklyOpenLine = na, var label weeklyOpenLbl = na
var line  midnightOpenLine = na, var label midnightOpenLbl = na
var float dailyOpenPx = na, var int dailyOpenBar = na
var float weeklyOpenPx = na, var int weeklyOpenBar = na
var float midnightOpenPx = na, var int midnightOpenBar = na

isNewDaily = ta.change(time("D")) != 0
if showDailyOpen and isNewDaily
    dailyOpenPx := open
    dailyOpenBar := bar_index

isNewWeekly = ta.change(time("W")) != 0
if showWeeklyOpen and isNewWeekly
    weeklyOpenPx := open
    weeklyOpenBar := bar_index

nyHourNow = hour(time, "America/New_York")
nyHourPrev = hour(time[1], "America/New_York")
isNewNYDay = showMidnightOpen and nyHourNow == 0 and nyHourPrev != 0
if isNewNYDay
    midnightOpenPx := open
    midnightOpenBar := bar_index

if barstate.islast
    rightOpenX = openLineExtend ? bar_index + 50 : bar_index
    if showDailyOpen and not na(dailyOpenPx)
        if not na(dailyOpenLine)
            line.delete(dailyOpenLine)
        if not na(dailyOpenLbl)
            label.delete(dailyOpenLbl)
        _doBar = _clampBar(dailyOpenBar)
        dailyOpenLine := line.new(_doBar, dailyOpenPx, rightOpenX, dailyOpenPx, color=C_GOLD, width=openLineWidth, style=line.style_solid, extend=openLineExtend ? extend.right : extend.none)
        dailyOpenLbl := label.new(rightOpenX, dailyOpenPx, " 📅 DO " + str.tostring(dailyOpenPx, format.mintick) + " ", color=C_GOLD, textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_small)
    if showWeeklyOpen and not na(weeklyOpenPx)
        if not na(weeklyOpenLine)
            line.delete(weeklyOpenLine)
        if not na(weeklyOpenLbl)
            label.delete(weeklyOpenLbl)
        _woBar = _clampBar(weeklyOpenBar)
        weeklyOpenLine := line.new(_woBar, weeklyOpenPx, rightOpenX, weeklyOpenPx, color=C_PURPLE, width=openLineWidth + 1, style=line.style_solid, extend=openLineExtend ? extend.right : extend.none)
        weeklyOpenLbl := label.new(rightOpenX, weeklyOpenPx, " 📆 WO " + str.tostring(weeklyOpenPx, format.mintick) + " ", color=C_PURPLE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)
    if showMidnightOpen and not na(midnightOpenPx)
        if not na(midnightOpenLine)
            line.delete(midnightOpenLine)
        if not na(midnightOpenLbl)
            label.delete(midnightOpenLbl)
        _moBar = _clampBar(midnightOpenBar)
        midnightOpenLine := line.new(_moBar, midnightOpenPx, rightOpenX, midnightOpenPx, color=C_CYAN, width=openLineWidth, style=line.style_dashed, extend=openLineExtend ? extend.right : extend.none)
        midnightOpenLbl := label.new(rightOpenX, midnightOpenPx, " 🕛 MO " + str.tostring(midnightOpenPx, format.mintick) + " ", color=C_CYAN, textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_small)

// ═══════════════════════════════════════════════════════════════
// MTF TREND (v14 B1 preserved)
// ═══════════════════════════════════════════════════════════════
// v19 TREND-1: EMA200 vs price — more stable institutional HTF filter than EMA20/50 cross
f_getTrend(_tf) =>
    [_htfClose, _htfEMA200] = request.security(syminfo.tickerid, _tf, [close[1], ta.ema(close, 200)[1]], lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)
    na(_htfClose) or na(_htfEMA200) ? 0 : _htfClose > _htfEMA200 ? 1 : _htfClose < _htfEMA200 ? -1 : 0

trendHTF1   = f_getTrend(htf1)
trendHTF2   = f_getTrend(htf2)
trendHTF3   = f_getTrend(htf3)
mtfBullBias = trendHTF1 == 1 and trendHTF2 == 1 and trendHTF3 == 1
mtfBearBias = trendHTF1 == -1 and trendHTF2 == -1 and trendHTF3 == -1

// v19 SMT-1: security call and correlated pair pivot tracking (placed here for request.security ordering)
// smtBull/smtBear booleans are computed after the primary swing track section (requires lastSL/prevSL)
var float smtLastHigh = na, var float smtLastLow = na
var float smtPrevHigh = na, var float smtPrevLow = na
// v21 FIX-8: track SMT pivot bar indices for temporal alignment guard
var int smtLastHighIdx = na, var int smtLastLowIdx = na
// Pine v5: request.security cannot be inside a ternary — call unconditionally, gate usage with useSMT below
[_smtPH, _smtPL] = request.security(smtPair, timeframe.period, [ta.pivothigh(high, smtSwingLen, smtSwingLen), ta.pivotlow(low, smtSwingLen, smtSwingLen)],lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)

if useSMT and not na(_smtPH) and barstate.isconfirmed
    smtPrevHigh    := smtLastHigh
    smtLastHigh    := _smtPH
    smtLastHighIdx := bar_index
if useSMT and not na(_smtPL) and barstate.isconfirmed
    smtPrevLow    := smtLastLow
    smtLastLow    := _smtPL
    smtLastLowIdx := bar_index

atrVal = ta.atr(atrLen)

// v13 F1 + v15 P2-8: ADX + ATR pctl, configurable AND/OR
[_diPlus, _diMinus, _adxVal] = ta.dmi(adxLenRng, adxLenRng)
_atrPctlThresh = ta.percentile_linear_interpolation(atrVal, atrPctlLen, atrPctlMin)
_adxLowChop = not na(_adxVal) and _adxVal < adxMinRng
_atrLowVol  = not na(_atrPctlThresh) and atrVal < _atrPctlThresh
isChopMarket = useRangeFilter and (rangeFilterMode == "AND (stricter)" ? (_adxLowChop and _atrLowVol) : (_adxLowChop or _atrLowVol))
volatilityHealthy = not isChopMarket

// v15 P1-6: volBoost uses volume[1] on confirmed bar to avoid intra-bar repaint
volMA = ta.sma(volume, volMaLen)
_volUsable = useVolConfirm and not _isForexOrOTC
_volBarOk = barstate.isconfirmed
volBoost = _volUsable and _volBarOk and not na(volMA) and volMA > 0 and volume[1] >= volMA * volMult

var label[] structLabels = array.new<label>()
var line[]  structLines  = array.new<line>()
f_pushStructLabel(lbl, ln) =>
    array.push(structLabels, lbl)
    array.push(structLines, ln)
    if array.size(structLabels) > maxStructLabels
        label.delete(array.shift(structLabels))
        line.delete(array.shift(structLines))

// ═══════════════════════════════════════════════════════════════
// STRUCTURE — v15 P0-1: TWO pivot tracks
//   PRIMARY (intSwingLen) drives internalTrend, BOS/CHoCH labels, entry MSS
//   HTF CONTEXT (swingLen) drives trendlines, PD freeze, Fib anchor
// ═══════════════════════════════════════════════════════════════

// ---- HTF CONTEXT track (swingLen) ----
htfSwingHigh = ta.pivothigh(high, swingLen, swingLen)
htfSwingLow  = ta.pivotlow(low, swingLen, swingLen)

var float htfLastSH = na, var float htfLastSL = na
var float htfPrevSH = na, var float htfPrevSL = na
var int   htfLastSHIdx = na, var int htfLastSLIdx = na
var int   htfPrevSHIdx = na, var int htfPrevSLIdx = na

if not na(htfSwingHigh)
    htfPrevSH := htfLastSH
    htfPrevSHIdx := htfLastSHIdx
    htfLastSH := htfSwingHigh
    htfLastSHIdx := bar_index - swingLen
    if showSwings
        label.new(bar_index - swingLen, htfSwingHigh, " SH ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny)
if not na(htfSwingLow)
    htfPrevSL := htfLastSL
    htfPrevSLIdx := htfLastSLIdx
    htfLastSL := htfSwingLow
    htfLastSLIdx := bar_index - swingLen
    if showSwings
        label.new(bar_index - swingLen, htfSwingLow, " SL ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny)

// ---- PRIMARY track (intSwingLen) — drives all trend logic ----
swingHigh = ta.pivothigh(high, intSwingLen, intSwingLen)
swingLow  = ta.pivotlow(low, intSwingLen, intSwingLen)

var float lastSH = na, var float lastSL = na
var float prevSH = na, var float prevSL = na
var int   lastSHIdx = na, var int lastSLIdx = na
var int   prevSHIdx = na, var int prevSLIdx = na
var bool  lastSHBroken = false
var bool  lastSLBroken = false
var int   lastSHResetBar = na
var int   lastSLResetBar = na
var int   internalTrend = 0

if not na(swingHigh)
    prevSH := lastSH
    prevSHIdx := lastSHIdx
    lastSH := swingHigh
    lastSHIdx := bar_index - intSwingLen
    lastSHBroken := false
    lastSHResetBar := bar_index
    _retroBroken = false
    if intSwingLen > 1
        for _i = 1 to intSwingLen - 1
            _checkLvl = useWickForBOS ? high[_i] : close[_i]
            if _checkLvl > lastSH
                _retroBroken := true
                break
    if _retroBroken
        lastSHBroken := true
        if showBOS or showCHoCH
            _retroLn = line.new(lastSHIdx, lastSH, bar_index, lastSH, color=C_BEAR, style=line.style_dotted, width=1)
            _retroLbl = label.new(bar_index, lastSH, " ⤴ retro ", color=color.new(C_LBL_BEAR, 40), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny)
            f_pushStructLabel(_retroLbl, _retroLn)
        if internalTrend != 1
            internalTrend := 1

if not na(swingLow)
    prevSL := lastSL
    prevSLIdx := lastSLIdx
    lastSL := swingLow
    lastSLIdx := bar_index - intSwingLen
    lastSLBroken := false
    lastSLResetBar := bar_index
    _retroBrokenL = false
    if intSwingLen > 1
        for _i = 1 to intSwingLen - 1
            _checkLvl = useWickForBOS ? low[_i] : close[_i]
            if _checkLvl < lastSL
                _retroBrokenL := true
                break
    if _retroBrokenL
        lastSLBroken := true
        if showBOS or showCHoCH
            _retroLnL = line.new(lastSLIdx, lastSL, bar_index, lastSL, color=C_BULL, style=line.style_dotted, width=1)
            _retroLblL = label.new(bar_index, lastSL, " ⤵ retro ", color=color.new(C_LBL_BULL, 40), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny)
            f_pushStructLabel(_retroLblL, _retroLnL)
        if internalTrend != -1
            internalTrend := -1

breakLevelHigh = useWickForBOS ? high : close
breakLevelLow  = useWickForBOS ? low  : close

sameBarBlockSH = not na(lastSHResetBar) and lastSHResetBar == bar_index
sameBarBlockSL = not na(lastSLResetBar) and lastSLResetBar == bar_index

_structConfirmed = barstate.isconfirmed
_rawBullBreak = _structConfirmed and not na(lastSH) and not lastSHBroken and breakLevelHigh > lastSH and not sameBarBlockSH
_rawBearBreak = _structConfirmed and not na(lastSL) and not lastSLBroken and breakLevelLow  < lastSL and not sameBarBlockSL

breakAboveSH = _rawBullBreak
breakBelowSL = _rawBearBreak

if _rawBullBreak and _rawBearBreak
    _atrSafe = atrVal > 0 ? atrVal : syminfo.mintick
    bullDominance = (high - lastSH) / _atrSafe
    bearDominance = (lastSL - low)  / _atrSafe
    if bullDominance > bearDominance
        breakBelowSL := false
    else if bearDominance > bullDominance
        breakAboveSH := false
    else if internalTrend == 1
        breakBelowSL := false
    else
        breakAboveSH := false

bosBull   = breakAboveSH and internalTrend ==  1
bosBear   = breakBelowSL and internalTrend == -1
chochBull = breakAboveSH and (internalTrend == -1 or (firstShiftAsCHoCH and internalTrend == 0))
chochBear = breakBelowSL and (internalTrend ==  1 or (firstShiftAsCHoCH and internalTrend == 0))
initBull  = breakAboveSH and not firstShiftAsCHoCH and internalTrend == 0
initBear  = breakBelowSL and not firstShiftAsCHoCH and internalTrend == 0

if breakAboveSH
    lastSHBroken := true
    internalTrend := 1
if breakBelowSL
    lastSLBroken := true
    internalTrend := -1

if showBOS and bosBull
    ln = line.new(lastSHIdx, lastSH, bar_index, lastSH, color=C_BULL, style=line.style_dashed, width=2)
    lbl = label.new(bar_index, lastSH, " BOS ▲ ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_normal)
    f_pushStructLabel(lbl, ln)
if showBOS and bosBear
    ln = line.new(lastSLIdx, lastSL, bar_index, lastSL, color=C_BEAR, style=line.style_dashed, width=2)
    lbl = label.new(bar_index, lastSL, " BOS ▼ ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_normal)
    f_pushStructLabel(lbl, ln)
if showCHoCH and (chochBull or initBull)
    ln = line.new(lastSHIdx, lastSH, bar_index, lastSH, color=C_BULL, width=3)
    txt = chochBull ? " ⚡ CHoCH ▲ " : " ◆ INIT ▲ "
    lbl = label.new(bar_index, lastSH, txt, color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_large)
    f_pushStructLabel(lbl, ln)
if showCHoCH and (chochBear or initBear)
    ln = line.new(lastSLIdx, lastSL, bar_index, lastSL, color=C_BEAR, width=3)
    txt = chochBear ? " ⚡ CHoCH ▼ " : " ◆ INIT ▼ "
    lbl = label.new(bar_index, lastSL, txt, color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_large)
    f_pushStructLabel(lbl, ln)

// v15: intTrend = same as internalTrend now (primary = intSwingLen). Kept as alias for confluence reuse.
intTrend = internalTrend
intMssBull = bosBull or chochBull or initBull
intMssBear = bosBear or chochBear or initBear
intLastHi = lastSH
intLastLo = lastSL

// v19 SMT-1: smtBull/smtBear now computed here — after lastSL/prevSL/lastSH/prevSH are updated
// SMT Bull: primary makes lower low, correlated pair makes higher low (divergence = reversal up)
// v21 FIX-8: require pivot index proximity so both instruments reference the same swing period.
// Without this, pivots from completely different market phases are falsely compared.
_smtProxBars = smtSwingLen * 3
smtBull = useSMT and barstate.isconfirmed and not na(lastSL) and not na(prevSL) and lastSL < prevSL and not na(smtLastLow) and not na(smtPrevLow) and smtLastLow >= smtPrevLow and not na(smtLastLowIdx) and not na(lastSLIdx) and math.abs(smtLastLowIdx - lastSLIdx) <= _smtProxBars

// SMT Bear: primary makes higher high, correlated pair makes lower high (divergence = reversal down)
smtBear = useSMT and barstate.isconfirmed and not na(lastSH) and not na(prevSH) and lastSH > prevSH and not na(smtLastHigh) and not na(smtPrevHigh) and smtLastHigh <= smtPrevHigh and not na(smtLastHighIdx) and not na(lastSHIdx) and math.abs(smtLastHighIdx - lastSHIdx) <= _smtProxBars

if smtBull
    _smtL = label.new(bar_index, low, " 🔀 SMT ▲ ", color=color.new(C_CYAN, 20), textcolor=C_TEXT_BLACK, style=label.style_label_up, size=sz_small, yloc=yloc.belowbar)
    f_pushMisc(_smtL)
if smtBear
    _smtS = label.new(bar_index, high, " 🔀 SMT ▼ ", color=color.new(C_CYAN, 20), textcolor=C_TEXT_BLACK, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
    f_pushMisc(_smtS)

// ═══════════════════════════════════════════════════════════════
// ENTRY STRUCTURE TRACK — v23 ISSUE-2
//   Separate, higher-quality pivot track (entrySwingLen = 5/8/12) used ONLY to qualify entries.
//   Logic-only mirror of the primary track (no drawing). Display structure is unaffected.
//   entryMssBull/Bear + entryTrend feed mssOkBull/Bear at the entry gate.
// ═══════════════════════════════════════════════════════════════
entrySwingHigh = ta.pivothigh(high, entrySwingLen, entrySwingLen)
entrySwingLow  = ta.pivotlow(low,  entrySwingLen, entrySwingLen)

var float eLastSH = na, var float eLastSL = na
var int   eLastSHIdx = na, var int eLastSLIdx = na
var bool  eLastSHBroken = false
var bool  eLastSLBroken = false
var int   eLastSHResetBar = na
var int   eLastSLResetBar = na
var int   entryTrend = 0

if not na(entrySwingHigh)
    eLastSH := entrySwingHigh
    eLastSHIdx := bar_index - entrySwingLen
    eLastSHBroken := false
    eLastSHResetBar := bar_index
    _eRetroBroken = false
    if entrySwingLen > 1
        for _i = 1 to entrySwingLen - 1
            _eChk = useWickForBOS ? high[_i] : close[_i]
            if _eChk > eLastSH
                _eRetroBroken := true
                break
    if _eRetroBroken
        eLastSHBroken := true
        if entryTrend != 1
            entryTrend := 1

if not na(entrySwingLow)
    eLastSL := entrySwingLow
    eLastSLIdx := bar_index - entrySwingLen
    eLastSLBroken := false
    eLastSLResetBar := bar_index
    _eRetroBrokenL = false
    if entrySwingLen > 1
        for _i = 1 to entrySwingLen - 1
            _eChkL = useWickForBOS ? low[_i] : close[_i]
            if _eChkL < eLastSL
                _eRetroBrokenL := true
                break
    if _eRetroBrokenL
        eLastSLBroken := true
        if entryTrend != -1
            entryTrend := -1

_eBreakHigh = useWickForBOS ? high : close
_eBreakLow  = useWickForBOS ? low  : close
_eSameBarSH = not na(eLastSHResetBar) and eLastSHResetBar == bar_index
_eSameBarSL = not na(eLastSLResetBar) and eLastSLResetBar == bar_index
_eConfirmed = barstate.isconfirmed
_eBullBreak = _eConfirmed and not na(eLastSH) and not eLastSHBroken and _eBreakHigh > eLastSH and not _eSameBarSH
_eBearBreak = _eConfirmed and not na(eLastSL) and not eLastSLBroken and _eBreakLow  < eLastSL and not _eSameBarSL

eBreakAboveSH = _eBullBreak
eBreakBelowSL = _eBearBreak
if _eBullBreak and _eBearBreak
    _eAtrSafe = atrVal > 0 ? atrVal : syminfo.mintick
    _eBullDom = (high - eLastSH) / _eAtrSafe
    _eBearDom = (eLastSL - low)  / _eAtrSafe
    if _eBullDom > _eBearDom
        eBreakBelowSL := false
    else if _eBearDom > _eBullDom
        eBreakAboveSH := false
    else if entryTrend == 1
        eBreakBelowSL := false
    else
        eBreakAboveSH := false

// entry-track MSS classification (BOS = continuation, CHoCH/init = shift)
entryBosBull   = eBreakAboveSH and entryTrend ==  1
entryBosBear   = eBreakBelowSL and entryTrend == -1
entryChochBull = eBreakAboveSH and (entryTrend == -1 or entryTrend == 0)
entryChochBear = eBreakBelowSL and (entryTrend ==  1 or entryTrend == 0)
if eBreakAboveSH
    eLastSHBroken := true
    entryTrend := 1
if eBreakBelowSL
    eLastSLBroken := true
    entryTrend := -1
entryMssBull = entryBosBull or entryChochBull
entryMssBear = entryBosBear or entryChochBear

// ═══════════════════════════════════════════════════════════════
// TRENDLINES — anchored on HTF-context pivots (swingLen)
// ═══════════════════════════════════════════════════════════════
var line[] bullTrendlines      = array.new<line>()
var line[] bullTrendlineGlows  = array.new<line>()
var line[] bearTrendlines      = array.new<line>()
var line[] bearTrendlineGlows  = array.new<line>()
var bool[] bullTLBrokenFlags   = array.new<bool>()
var bool[] bearTLBrokenFlags   = array.new<bool>()
var int[]  bullTLCreatedBars   = array.new<int>()
var int[]  bearTLCreatedBars   = array.new<int>()
var bool[] bullTLExtended      = array.new<bool>()
var bool[] bearTLExtended      = array.new<bool>()

f_tlStyle() =>
    trendlineStyle == "Dashed" ? line.style_dashed : trendlineStyle == "Dotted" ? line.style_dotted : line.style_solid

if showTrendlines and not na(htfLastSL) and not na(htfPrevSL) and not na(htfSwingLow) and htfLastSL > htfPrevSL
    extendStyle = trendlineExtend ? extend.right : extend.none
    glow = trendlineGlow ? line.new(htfPrevSLIdx, htfPrevSL, htfLastSLIdx, htfLastSL, color=color.new(C_BULL, 70), width=trendlineWidth + 3, extend=extendStyle, style=line.style_solid) : na
    tl = line.new(htfPrevSLIdx, htfPrevSL, htfLastSLIdx, htfLastSL, color=C_BULL, width=trendlineWidth, extend=extendStyle, style=f_tlStyle())
    array.push(bullTrendlines, tl)
    array.push(bullTrendlineGlows, glow)
    array.push(bullTLBrokenFlags, false)
    array.push(bullTLCreatedBars, bar_index)
    array.push(bullTLExtended, trendlineExtend)
    if array.size(bullTrendlines) > maxTrendlines
        line.delete(array.shift(bullTrendlines))
        oldGlow = array.shift(bullTrendlineGlows)
        if not na(oldGlow)
            line.delete(oldGlow)
        array.shift(bullTLBrokenFlags)
        array.shift(bullTLCreatedBars)
        array.shift(bullTLExtended)

if showTrendlines and not na(htfLastSH) and not na(htfPrevSH) and not na(htfSwingHigh) and htfLastSH < htfPrevSH
    extendStyle = trendlineExtend ? extend.right : extend.none
    glow = trendlineGlow ? line.new(htfPrevSHIdx, htfPrevSH, htfLastSHIdx, htfLastSH, color=color.new(C_BEAR, 70), width=trendlineWidth + 3, extend=extendStyle, style=line.style_solid) : na
    tl = line.new(htfPrevSHIdx, htfPrevSH, htfLastSHIdx, htfLastSH, color=C_BEAR, width=trendlineWidth, extend=extendStyle, style=f_tlStyle())
    array.push(bearTrendlines, tl)
    array.push(bearTrendlineGlows, glow)
    array.push(bearTLBrokenFlags, false)
    array.push(bearTLCreatedBars, bar_index)
    array.push(bearTLExtended, trendlineExtend)
    if array.size(bearTrendlines) > maxTrendlines
        line.delete(array.shift(bearTrendlines))
        oldGlow = array.shift(bearTrendlineGlows)
        if not na(oldGlow)
            line.delete(oldGlow)
        array.shift(bearTLBrokenFlags)
        array.shift(bearTLCreatedBars)
        array.shift(bearTLExtended)

f_drawTLBreak(_yPrice, _isBull) =>
    if tlBreakMarker == "Full label"
        label.new(bar_index, _yPrice, " ⚠ TL ", color=_isBull ? C_LBL_BULL : C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
    else if tlBreakMarker == "Tick mark"
        label.new(bar_index, _yPrice, "×", color=color.new(_isBull ? C_BULL : C_BEAR, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)

if breakTrendline and barstate.isconfirmed and array.size(bullTrendlines) > 0
    for i = 0 to array.size(bullTrendlines) - 1
        if not array.get(bullTLBrokenFlags, i) and (bar_index - array.get(bullTLCreatedBars, i)) <= trendlineMaxAgeBars
            tl = array.get(bullTrendlines, i)
            tlExtends = array.get(bullTLExtended, i)
            x1 = line.get_x1(tl)
            x2 = line.get_x2(tl)
            y1 = line.get_y1(tl)
            y2 = line.get_y2(tl)
            inRange = tlExtends or bar_index <= x2
            if x2 > x1 and bar_index > x2 and inRange
                slope = (y2 - y1) / (x2 - x1)
                projectedPrice = y2 + slope * (bar_index - x2)
                projectedPrev  = y2 + slope * (bar_index - 1 - x2)
                if (close < projectedPrice and close[1] >= projectedPrev) or (low < projectedPrice and high[1] >= projectedPrev)
                    f_drawTLBreak(projectedPrice, false)
                    array.set(bullTLBrokenFlags, i, true)
                    line.set_color(tl, color.new(C_BULL, 60))
                    glow = array.get(bullTrendlineGlows, i)
                    if not na(glow)
                        line.set_color(glow, color.new(C_BULL, 90))

if breakTrendline and barstate.isconfirmed and array.size(bearTrendlines) > 0
    for i = 0 to array.size(bearTrendlines) - 1
        if not array.get(bearTLBrokenFlags, i) and (bar_index - array.get(bearTLCreatedBars, i)) <= trendlineMaxAgeBars
            tl = array.get(bearTrendlines, i)
            tlExtends = array.get(bearTLExtended, i)
            x1 = line.get_x1(tl)
            x2 = line.get_x2(tl)
            y1 = line.get_y1(tl)
            y2 = line.get_y2(tl)
            inRange = tlExtends or bar_index <= x2
            if x2 > x1 and bar_index > x2 and inRange
                slope = (y2 - y1) / (x2 - x1)
                projectedPrice = y2 + slope * (bar_index - x2)
                projectedPrev  = y2 + slope * (bar_index - 1 - x2)
                if (close > projectedPrice and close[1] <= projectedPrev) or (high > projectedPrice and low[1] <= projectedPrev)
                    f_drawTLBreak(projectedPrice, true)
                    array.set(bearTLBrokenFlags, i, true)
                    line.set_color(tl, color.new(C_BEAR, 60))
                    glow = array.get(bearTrendlineGlows, i)
                    if not na(glow)
                        line.set_color(glow, color.new(C_BEAR, 90))

// ═══════════════════════════════════════════════════════════════
// ORDER BLOCKS — now with createdBar for age-decay
// ═══════════════════════════════════════════════════════════════
isBullC    = close > open
isBearC    = close < open
candleRng_ = high - low
strongBull = isBullC and (close - open) > candleRng_ * obStrength and candleRng_ >= atrVal * obImpulseATR
strongBear = isBearC and (open - close) > candleRng_ * obStrength and candleRng_ >= atrVal * obImpulseATR

f_findBullOB() =>
    found_idx = -1
    if strongBull
        for i = 1 to obLookback
            if isBearC[i]
                found_idx := i
                break
    found_idx

f_findBearOB() =>
    found_idx = -1
    if strongBear
        for i = 1 to obLookback
            if isBullC[i]
                found_idx := i
                break
    found_idx

bullOBOffset = f_findBullOB()
bearOBOffset = f_findBearOB()
_bullStructEvent = bosBull or chochBull or initBull
_bearStructEvent = bosBear or chochBear or initBear
// v16 M1 fix: gate OB creation on confirmed bar — strongBull/Bear use live OHLC and would
// repaint the box intrabar until close. Structure/sweeps already confirm-gated; OBs now match.
_obConfirmed = barstate.isconfirmed
bullOBCond   = _obConfirmed and bullOBOffset > 0 and (not obRequireBOS or _bullStructEvent)
bearOBCond   = _obConfirmed and bearOBOffset > 0 and (not obRequireBOS or _bearStructEvent)

var box[]   bullOBs         = array.new<box>()
var label[] bullOBLabels    = array.new<label>()
var bool[]  bullOBMitigated = array.new<bool>()
var int[]   bullOBCreated   = array.new<int>()    // v15 P2-9: age tracking
var box[]   bearOBs         = array.new<box>()
var label[] bearOBLabels    = array.new<label>()
var bool[]  bearOBMitigated = array.new<bool>()
var int[]   bearOBCreated   = array.new<int>()

var int lastBullCHoCHBar = -1000
var int lastBearCHoCHBar = -1000
if chochBull or initBull
    lastBullCHoCHBar := bar_index
if chochBear or initBear
    lastBearCHoCHBar := bar_index

var box[]   bullBreakers      = array.new<box>()
var label[] bullBreakerLabels = array.new<label>()
var int[]   bullBreakerBars   = array.new<int>()
var box[]   bearBreakers      = array.new<box>()
var label[] bearBreakerLabels = array.new<label>()
var int[]   bearBreakerBars   = array.new<int>()

if showOB and bullOBCond
    obHigh = high[bullOBOffset]
    obLow  = low[bullOBOffset]
    isMB = distinguishMB and (bar_index - lastBullCHoCHBar) <= mbRecencyBars
    obColor = isMB ? C_PURPLE : C_BULL
    obLabelColor = isMB ? C_PURPLE : C_LBL_BULL
    obLabelTxt = isMB ? " 💎 BULL MB " : " 🟢 BULL OB "
    obBox  = box.new(bar_index - bullOBOffset, obHigh, bar_index + 40, obLow, bgcolor=color.new(obColor, obOpacity), border_color=obColor, border_width=2)
    obLabel = label.new(bar_index + 40, (obHigh + obLow) / 2, obLabelTxt, color=obLabelColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
    array.push(bullOBs, obBox)
    array.push(bullOBLabels, obLabel)
    array.push(bullOBMitigated, false)
    array.push(bullOBCreated, bar_index)
    if array.size(bullOBs) > obMaxBoxes
        box.delete(array.shift(bullOBs))
        label.delete(array.shift(bullOBLabels))
        array.shift(bullOBMitigated)
        array.shift(bullOBCreated)

if showOB and bearOBCond
    obHigh = high[bearOBOffset]
    obLow  = low[bearOBOffset]
    isMB = distinguishMB and (bar_index - lastBearCHoCHBar) <= mbRecencyBars
    obColor = isMB ? C_PURPLE : C_BEAR
    obLabelColor = isMB ? C_PURPLE : C_LBL_BEAR
    obLabelTxt = isMB ? " 💎 BEAR MB " : " 🔴 BEAR OB "
    obBox  = box.new(bar_index - bearOBOffset, obHigh, bar_index + 40, obLow, bgcolor=color.new(obColor, obOpacity), border_color=obColor, border_width=2)
    obLabel = label.new(bar_index + 40, (obHigh + obLow) / 2, obLabelTxt, color=obLabelColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
    array.push(bearOBs, obBox)
    array.push(bearOBLabels, obLabel)
    array.push(bearOBMitigated, false)
    array.push(bearOBCreated, bar_index)
    if array.size(bearOBs) > obMaxBoxes
        box.delete(array.shift(bearOBs))
        label.delete(array.shift(bearOBLabels))
        array.shift(bearOBMitigated)
        array.shift(bearOBCreated)

var float[] bullPendingTops = array.new<float>()
var float[] bullPendingBots = array.new<float>()
var int[]   bullPendingBars = array.new<int>()
var float[] bearPendingTops = array.new<float>()
var float[] bearPendingBots = array.new<float>()
var int[]   bearPendingBars = array.new<int>()

f_obMitTrigger(_top, _bot, _isBull) =>
    if obMitigationMode == "Touch"
        _isBull ? low <= _top : high >= _bot
    else if obMitigationMode == "50% fill"
        _mid = (_top + _bot) / 2
        _isBull ? low <= _mid : high >= _mid
    else
        _isBull ? low <= _bot : high >= _top

f_mitigateOBs() =>
    if showOB and array.size(bullOBs) > 0
        for i = array.size(bullOBs) - 1 to 0
            if not array.get(bullOBMitigated, i)
                b = array.get(bullOBs, i)
                l = array.get(bullOBLabels, i)
                obTop_i = box.get_top(b)
                obBot_i = box.get_bottom(b)
                if f_obMitTrigger(obTop_i, obBot_i, true)
                    box.set_right(b, bar_index)
                    box.set_bgcolor(b, color.new(C_NEUTRAL, 93))
                    box.set_border_color(b, color.new(C_NEUTRAL, 70))
                    array.set(bullOBMitigated, i, true)
                    if hideMitigatedLabels
                        label.delete(l)
                    if showBreaker
                        array.push(bullPendingTops, obTop_i)
                        array.push(bullPendingBots, obBot_i)
                        array.push(bullPendingBars, bar_index)
    if showOB and array.size(bearOBs) > 0
        for i = array.size(bearOBs) - 1 to 0
            if not array.get(bearOBMitigated, i)
                b = array.get(bearOBs, i)
                l = array.get(bearOBLabels, i)
                obTop_i = box.get_top(b)
                obBot_i = box.get_bottom(b)
                if f_obMitTrigger(obTop_i, obBot_i, false)
                    box.set_right(b, bar_index)
                    box.set_bgcolor(b, color.new(C_NEUTRAL, 93))
                    box.set_border_color(b, color.new(C_NEUTRAL, 70))
                    array.set(bearOBMitigated, i, true)
                    if hideMitigatedLabels
                        label.delete(l)
                    if showBreaker
                        array.push(bearPendingTops, obTop_i)
                        array.push(bearPendingBots, obBot_i)
                        array.push(bearPendingBars, bar_index)
f_mitigateOBs()

f_manageBreakers() =>
    _breakerConfirmed = barstate.isconfirmed
    if showBreaker and array.size(bullPendingTops) > 0
        for i = array.size(bullPendingTops) - 1 to 0
            topL = array.get(bullPendingTops, i)
            botL = array.get(bullPendingBots, i)
            ageL = bar_index - array.get(bullPendingBars, i)
            if _breakerConfirmed and close < botL
                brBox = box.new(bar_index, topL, bar_index + 40, botL, bgcolor=color.new(C_BEAR, breakerOpacity), border_color=C_BEAR, border_width=1, border_style=line.style_dashed)
                brLbl = label.new(bar_index + 40, (topL + botL) / 2, " ⚡ BREAKER ▼ ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
                array.push(bearBreakers, brBox)
                array.push(bearBreakerLabels, brLbl)
                array.push(bearBreakerBars, bar_index)
                array.remove(bullPendingTops, i)
                array.remove(bullPendingBots, i)
                array.remove(bullPendingBars, i)
            else if ageL > breakerPendingAge
                array.remove(bullPendingTops, i)
                array.remove(bullPendingBots, i)
                array.remove(bullPendingBars, i)
    if showBreaker and array.size(bearPendingTops) > 0
        for i = array.size(bearPendingTops) - 1 to 0
            topL = array.get(bearPendingTops, i)
            botL = array.get(bearPendingBots, i)
            ageL = bar_index - array.get(bearPendingBars, i)
            if _breakerConfirmed and close > topL
                brBox = box.new(bar_index, topL, bar_index + 40, botL, bgcolor=color.new(C_BULL, breakerOpacity), border_color=C_BULL, border_width=1, border_style=line.style_dashed)
                brLbl = label.new(bar_index + 40, (topL + botL) / 2, " ⚡ BREAKER ▲ ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
                array.push(bullBreakers, brBox)
                array.push(bullBreakerLabels, brLbl)
                array.push(bullBreakerBars, bar_index)
                array.remove(bearPendingTops, i)
                array.remove(bearPendingBots, i)
                array.remove(bearPendingBars, i)
            else if ageL > breakerPendingAge
                array.remove(bearPendingTops, i)
                array.remove(bearPendingBots, i)
                array.remove(bearPendingBars, i)
    if showBreaker
        if array.size(bullBreakers) > 0
            for i = array.size(bullBreakers) - 1 to 0
                if (bar_index - array.get(bullBreakerBars, i)) > breakerMaxAge
                    box.delete(array.get(bullBreakers, i))
                    label.delete(array.get(bullBreakerLabels, i))
                    array.remove(bullBreakers, i)
                    array.remove(bullBreakerLabels, i)
                    array.remove(bullBreakerBars, i)
        if array.size(bearBreakers) > 0
            for i = array.size(bearBreakers) - 1 to 0
                if (bar_index - array.get(bearBreakerBars, i)) > breakerMaxAge
                    box.delete(array.get(bearBreakers, i))
                    label.delete(array.get(bearBreakerLabels, i))
                    array.remove(bearBreakers, i)
                    array.remove(bearBreakerLabels, i)
                    array.remove(bearBreakerBars, i)
f_manageBreakers()

// v15 P3-13: Replace 5 mirror loops with f_priceInBoxes helper
var bool[] _emptyMit = array.new<bool>()
priceInBullOB = f_priceInBoxes(bullOBs, bullOBMitigated)
priceInBearOB = f_priceInBoxes(bearOBs, bearOBMitigated)
priceInBullBreaker = f_priceInBoxes(bullBreakers, _emptyMit)
priceInBearBreaker = f_priceInBoxes(bearBreakers, _emptyMit)

// v15 P2-9: Find freshest active OB age for decay weighting
f_freshestPOIBar(_obArr, _mitArr, _createdArr) =>
    _fresh = -10000
    if array.size(_obArr) > 0
        for i = 0 to array.size(_obArr) - 1
            if not array.get(_mitArr, i)
                b = array.get(_obArr, i)
                if low <= box.get_top(b) and high >= box.get_bottom(b)
                    _bar = array.get(_createdArr, i)
                    if _bar > _fresh
                        _fresh := _bar
    _fresh

bullOBFreshBar = f_freshestPOIBar(bullOBs, bullOBMitigated, bullOBCreated)
bearOBFreshBar = f_freshestPOIBar(bearOBs, bearOBMitigated, bearOBCreated)

// ═══════════════════════════════════════════════════════════════
// FVG
// ═══════════════════════════════════════════════════════════════
fvgBullGap = math.abs(low - high[2])
fvgBearGap = math.abs(low[2] - high)
fvgBullSize = fvgBullGap / close * 100
fvgBearSize = fvgBearGap / close * 100
fvgDisplacementOK = not na(atrVal) and atrVal > 0 and (high[1] - low[1]) >= atrVal * fvgDisplacementATR
_fvgAtrFloor = atrVal * fvgMinSizeAtr
fvgBullSizeOK = fvgMinSizeMode == "ATR fraction" ? (not na(atrVal) and fvgBullGap >= _fvgAtrFloor) : fvgBullSize >= fvgMinSize
fvgBearSizeOK = fvgMinSizeMode == "ATR fraction" ? (not na(atrVal) and fvgBearGap >= _fvgAtrFloor) : fvgBearSize >= fvgMinSize
bullFVG = low > high[2]  and close[1] > open[1] and fvgBullSizeOK and fvgDisplacementOK
bearFVG = high < low[2]  and close[1] < open[1] and fvgBearSizeOK and fvgDisplacementOK

var box[]   bullFVGs         = array.new<box>()
var label[] bullFVGLabels    = array.new<label>()
var bool[]  bullFVGMitigated = array.new<bool>()
var int[]   bullFVGCreated   = array.new<int>()    // v15 P2-9
var box[]   bearFVGs         = array.new<box>()
var label[] bearFVGLabels    = array.new<label>()
var bool[]  bearFVGMitigated = array.new<bool>()
var int[]   bearFVGCreated   = array.new<int>()

var box[]   bullInverted = array.new<box>()
var label[] bullInvertedLabels = array.new<label>()
var int[]   bullInvertedBars = array.new<int>()
var box[]   bearInverted = array.new<box>()
var label[] bearInvertedLabels = array.new<label>()
var int[]   bearInvertedBars = array.new<int>()

if showFVG and bullFVG and barstate.isconfirmed  // v19 REPAINT-1: confirmed bar only
    fvgBox = box.new(bar_index - 2, low, bar_index + 25, high[2], bgcolor=color.new(C_BLUE, 78), border_color=C_BLUE, border_width=1)
    fvgLbl = showFVGLabels ? label.new(bar_index + 25, (low + high[2]) / 2, " 🔵 FVG ", color=C_BLUE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small) : na
    array.push(bullFVGs, fvgBox)
    array.push(bullFVGLabels, fvgLbl)
    array.push(bullFVGMitigated, false)
    array.push(bullFVGCreated, bar_index)
    if array.size(bullFVGs) > maxFVGs
        box.delete(array.shift(bullFVGs))
        label.delete(array.shift(bullFVGLabels))
        array.shift(bullFVGMitigated)
        array.shift(bullFVGCreated)

if showFVG and bearFVG and barstate.isconfirmed  // v19 REPAINT-1: confirmed bar only
    fvgBox = box.new(bar_index - 2, high, bar_index + 25, low[2], bgcolor=color.new(C_ORANGE, 78), border_color=C_ORANGE, border_width=1)
    fvgLbl = showFVGLabels ? label.new(bar_index + 25, (high + low[2]) / 2, " 🟠 FVG ", color=C_ORANGE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small) : na
    array.push(bearFVGs, fvgBox)
    array.push(bearFVGLabels, fvgLbl)
    array.push(bearFVGMitigated, false)
    array.push(bearFVGCreated, bar_index)
    if array.size(bearFVGs) > maxFVGs
        box.delete(array.shift(bearFVGs))
        label.delete(array.shift(bearFVGLabels))
        array.shift(bearFVGMitigated)
        array.shift(bearFVGCreated)

f_mitigateLevel(_top, _bot, _isBull) =>
    mid = (_top + _bot) / 2
    if fvgMitigationMode == "Touch"
        _isBull ? _top : _bot
    else if fvgMitigationMode == "50% fill"
        mid
    else
        _isBull ? _bot : _top

var float[] bullFVGPendingTops = array.new<float>()
var float[] bullFVGPendingBots = array.new<float>()
var int[]   bullFVGPendingBars = array.new<int>()
var float[] bearFVGPendingTops = array.new<float>()
var float[] bearFVGPendingBots = array.new<float>()
var int[]   bearFVGPendingBars = array.new<int>()

f_mitigateFVGs() =>
    if trackFVGMitigation and showFVG and array.size(bullFVGs) > 0
        for i = array.size(bullFVGs) - 1 to 0
            if not array.get(bullFVGMitigated, i)
                b = array.get(bullFVGs, i)
                threshold = f_mitigateLevel(box.get_top(b), box.get_bottom(b), true)
                if low <= threshold
                    box.set_bgcolor(b, color.new(C_NEUTRAL, 90))
                    box.set_border_color(b, color.new(C_NEUTRAL, 60))
                    array.set(bullFVGMitigated, i, true)
                    if hideMitigatedLabels
                        label.delete(array.get(bullFVGLabels, i))
                    if showInversionFVG
                        array.push(bullFVGPendingTops, box.get_top(b))
                        array.push(bullFVGPendingBots, box.get_bottom(b))
                        array.push(bullFVGPendingBars, bar_index)
    if trackFVGMitigation and showFVG and array.size(bearFVGs) > 0
        for i = array.size(bearFVGs) - 1 to 0
            if not array.get(bearFVGMitigated, i)
                b = array.get(bearFVGs, i)
                threshold = f_mitigateLevel(box.get_top(b), box.get_bottom(b), false)
                if high >= threshold
                    box.set_bgcolor(b, color.new(C_NEUTRAL, 90))
                    box.set_border_color(b, color.new(C_NEUTRAL, 60))
                    array.set(bearFVGMitigated, i, true)
                    if hideMitigatedLabels
                        label.delete(array.get(bearFVGLabels, i))
                    if showInversionFVG
                        array.push(bearFVGPendingTops, box.get_top(b))
                        array.push(bearFVGPendingBots, box.get_bottom(b))
                        array.push(bearFVGPendingBars, bar_index)
f_mitigateFVGs()

f_manageIFVGs() =>
    _ifvgConfirmed = barstate.isconfirmed
    if showInversionFVG and array.size(bullFVGPendingTops) > 0
        for i = array.size(bullFVGPendingTops) - 1 to 0
            topL = array.get(bullFVGPendingTops, i)
            botL = array.get(bullFVGPendingBots, i)
            ageL = bar_index - array.get(bullFVGPendingBars, i)
            if _ifvgConfirmed and close < botL
                invBox = box.new(bar_index, topL, bar_index + 30, botL, bgcolor=color.new(C_ORANGE, 85), border_color=C_ORANGE, border_width=1, border_style=line.style_dashed)
                invLbl = label.new(bar_index + 30, (topL + botL) / 2, " ↯ iFVG ▼ ", color=C_ORANGE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
                array.push(bearInverted, invBox)
                array.push(bearInvertedLabels, invLbl)
                array.push(bearInvertedBars, bar_index)
                array.remove(bullFVGPendingTops, i)
                array.remove(bullFVGPendingBots, i)
                array.remove(bullFVGPendingBars, i)
            else if ageL > fvgPendingAge
                array.remove(bullFVGPendingTops, i)
                array.remove(bullFVGPendingBots, i)
                array.remove(bullFVGPendingBars, i)
    if showInversionFVG and array.size(bearFVGPendingTops) > 0
        for i = array.size(bearFVGPendingTops) - 1 to 0
            topL = array.get(bearFVGPendingTops, i)
            botL = array.get(bearFVGPendingBots, i)
            ageL = bar_index - array.get(bearFVGPendingBars, i)
            if _ifvgConfirmed and close > topL
                invBox = box.new(bar_index, topL, bar_index + 30, botL, bgcolor=color.new(C_BLUE, 85), border_color=C_BLUE, border_width=1, border_style=line.style_dashed)
                invLbl = label.new(bar_index + 30, (topL + botL) / 2, " ↯ iFVG ▲ ", color=C_BLUE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
                array.push(bullInverted, invBox)
                array.push(bullInvertedLabels, invLbl)
                array.push(bullInvertedBars, bar_index)
                array.remove(bearFVGPendingTops, i)
                array.remove(bearFVGPendingBots, i)
                array.remove(bearFVGPendingBars, i)
            else if ageL > fvgPendingAge
                array.remove(bearFVGPendingTops, i)
                array.remove(bearFVGPendingBots, i)
                array.remove(bearFVGPendingBars, i)
    if showInversionFVG
        if array.size(bullInverted) > 0
            for i = array.size(bullInverted) - 1 to 0
                if (bar_index - array.get(bullInvertedBars, i)) > ifvgMaxAge
                    box.delete(array.get(bullInverted, i))
                    label.delete(array.get(bullInvertedLabels, i))
                    array.remove(bullInverted, i)
                    array.remove(bullInvertedLabels, i)
                    array.remove(bullInvertedBars, i)
        if array.size(bearInverted) > 0
            for i = array.size(bearInverted) - 1 to 0
                if (bar_index - array.get(bearInvertedBars, i)) > ifvgMaxAge
                    box.delete(array.get(bearInverted, i))
                    label.delete(array.get(bearInvertedLabels, i))
                    array.remove(bearInverted, i)
                    array.remove(bearInvertedLabels, i)
                    array.remove(bearInvertedBars, i)
f_manageIFVGs()

// v18 BUG-1 fix: BPR was unbounded — new box+label every bar → hit 500-object ceiling in minutes.
// Single persistent handles; delete-before-redraw only on barstate.islast (one draw per closed bar).
var box   bprBox = na
var label bprLbl = na

// v20 FIX-5: BPR now requires temporal proximity (≤25 bars) between bull and bear FVG.
// Prior implementation compared last bull FVG vs last bear FVG regardless of age gap —
// produced false BPR between FVGs on completely different market phases.
// MED-fix (audit): BPR is VISUAL-ONLY. It is computed on the last bar for display and is NOT fed
// into bullScore/bearScore (no priceInBPR term exists). Kept as a chart aid — not advertised as
// confluence. To score it, add a per-bar overlap test into _ofBull/_ofBear (watch the compile-token
// ceiling — see HIGH-2).
if showBPR and barstate.islast
    _bprFound      = false
    _bprOverlapTop = float(na)
    _bprOverlapBot = float(na)
    _bprMaxProx    = 25  // same structural move = within 25 bars of each other
    if array.size(bullFVGs) > 0 and array.size(bearFVGs) > 0
        for bi = array.size(bullFVGs) - 1 to 0
            if _bprFound
                break
            bBox     = array.get(bullFVGs, bi)
            bCreated = array.get(bullFVGCreated, bi)
            for bri = array.size(bearFVGs) - 1 to 0
                brBox     = array.get(bearFVGs, bri)
                brCreated = array.get(bearFVGCreated, bri)
                if math.abs(bCreated - brCreated) <= _bprMaxProx
                    oTop = math.min(box.get_top(bBox), box.get_top(brBox))
                    oBot = math.max(box.get_bottom(bBox), box.get_bottom(brBox))
                    if oTop > oBot
                        _bprOverlapTop := oTop
                        _bprOverlapBot := oBot
                        _bprFound      := true
                        break
    if _bprFound
        if not na(bprBox)
            box.delete(bprBox)
        if not na(bprLbl)
            label.delete(bprLbl)
        bprBox := box.new(bar_index - 5, _bprOverlapTop, bar_index + 15, _bprOverlapBot, bgcolor=color.new(C_PURPLE, 55), border_color=C_PURPLE, border_width=2)
        bprLbl := label.new(bar_index + 15, (_bprOverlapTop + _bprOverlapBot) / 2, " ⚡ BPR ", color=C_PURPLE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)
    else
        if not na(bprBox)
            box.delete(bprBox)
            bprBox := na
        if not na(bprLbl)
            label.delete(bprLbl)
            bprLbl := na

priceInBullFVG = f_priceInBoxes(bullFVGs, bullFVGMitigated)
priceInBearFVG = f_priceInBoxes(bearFVGs, bearFVGMitigated)
priceInBullInverted = f_priceInBoxes(bullInverted, _emptyMit)
priceInBearInverted = f_priceInBoxes(bearInverted, _emptyMit)

bullFVGFreshBar = f_freshestPOIBar(bullFVGs, bullFVGMitigated, bullFVGCreated)
bearFVGFreshBar = f_freshestPOIBar(bearFVGs, bearFVGMitigated, bearFVGCreated)

// ═══════════════════════════════════════════════════════════════
// HTF POI — v15 P3-12: single merged security call
// ═══════════════════════════════════════════════════════════════
[htfHigh1, htfLow1, htfHigh2, htfLow2, htfHigh3, htfLow3, htfClose1, htfOpen1, htfClose2, htfOpen2, htfATR_v] = request.security(
     syminfo.tickerid, htfPOITF,
     [high[1], low[1], high[2], low[2], high[3], low[3], close[1], open[1], close[2], open[2], ta.atr(14)[1]],
     lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)

// HTF bull FVG: gap between [3] and [1] with bullish middle [2]
htfBullFVGTop    = na(htfLow1) ? na : htfLow1
htfBullFVGBot    = na(htfHigh3) ? na : htfHigh3
htfBullFVGExists = useHTFPOI and not na(htfBullFVGTop) and not na(htfBullFVGBot) and htfBullFVGTop > htfBullFVGBot and not na(htfClose2) and not na(htfOpen2) and htfClose2 > htfOpen2

htfBearFVGTop    = na(htfLow3) ? na : htfLow3
htfBearFVGBot    = na(htfHigh1) ? na : htfHigh1
htfBearFVGExists = useHTFPOI and not na(htfBearFVGTop) and not na(htfBearFVGBot) and htfBearFVGTop > htfBearFVGBot and not na(htfClose2) and not na(htfOpen2) and htfClose2 < htfOpen2

priceInHTFBullFVG = htfBullFVGExists and low <= htfBullFVGTop and high >= htfBullFVGBot
priceInHTFBearFVG = htfBearFVGExists and low <= htfBearFVGTop and high >= htfBearFVGBot

// HTF OB — impulse candle ([1]) + prior candle ([2])
_htfImpRange = na(htfHigh1) or na(htfLow1) ? na : htfHigh1 - htfLow1
_htfImpStrong = not na(_htfImpRange) and not na(htfATR_v) and htfATR_v > 0 and _htfImpRange >= htfATR_v
_htfImpIsBull = not na(htfClose1) and not na(htfOpen1) and htfClose1 > htfOpen1
_htfImpIsBear = not na(htfClose1) and not na(htfOpen1) and htfClose1 < htfOpen1
_htfPreIsBull = not na(htfClose2) and not na(htfOpen2) and htfClose2 > htfOpen2
_htfPreIsBear = not na(htfClose2) and not na(htfOpen2) and htfClose2 < htfOpen2

htfBullOBExists = useHTFOB and _htfImpStrong and _htfImpIsBull and _htfPreIsBear
htfBullOBTop = htfBullOBExists ? htfHigh2 : na
htfBullOBBot = htfBullOBExists ? htfLow2  : na

htfBearOBExists = useHTFOB and _htfImpStrong and _htfImpIsBear and _htfPreIsBull
htfBearOBTop = htfBearOBExists ? htfHigh2 : na
htfBearOBBot = htfBearOBExists ? htfLow2  : na

priceInHTFBullOB = htfBullOBExists and low <= htfBullOBTop and high >= htfBullOBBot
priceInHTFBearOB = htfBearOBExists and low <= htfBearOBTop and high >= htfBearOBBot

// v22 TOKEN-TRIM: HTF POI box DRAWING removed to fit Pine's 80k compile-token limit.
// Detection (priceInHTFBullFVG/priceInHTFBearFVG/priceInHTFBullOB/priceInHTFBearOB above)
// is intact and still feeds confluence + the HTF POI Tap alerts. Only the on-chart boxes are gone.

// ═══════════════════════════════════════════════════════════════
// PD ZONES — frozen at CHoCH (uses HTF-context swings)
// ═══════════════════════════════════════════════════════════════
var box   premiumBox     = na
var box   discountBox    = na
var line  equilibriumLine = na
var label premiumLabel   = na
// AUDIT: removed dead discountLabel/eqLabel (declared+deleted but never assigned) to reclaim compile tokens.

var float pdRefHigh = na
var float pdRefLow  = na
var int   pdRefBar  = na

// PD freeze on PRIMARY-track CHoCH/INIT (uses lastSH/lastSL of intSwingLen)
if (chochBull or chochBear or initBull or initBear) and not na(lastSH) and not na(lastSL)
    pdRefHigh := lastSH
    pdRefLow  := lastSL
    pdRefBar  := bar_index

// Fallback uses HTF-context swings if available; else primary
pdHi = not na(pdRefHigh) ? pdRefHigh : (not na(htfLastSH) ? htfLastSH : lastSH)
pdLo = not na(pdRefLow)  ? pdRefLow  : (not na(htfLastSL) ? htfLastSL : lastSL)
pdAnchorBar = not na(pdRefBar) ? pdRefBar : bar_index - 40

if showPD and not na(pdHi) and not na(pdLo) and barstate.islast
    mid = (pdHi + pdLo) / 2
    if not na(premiumBox)
        box.delete(premiumBox)
    if not na(discountBox)
        box.delete(discountBox)
    if not na(equilibriumLine)
        line.delete(equilibriumLine)
    if not na(premiumLabel)
        label.delete(premiumLabel)
    pdRightX = bar_index + 8
    premiumBox      := box.new(pdAnchorBar, pdHi, pdRightX, mid, bgcolor=color.new(C_BEAR, 93), border_color=color.new(C_BEAR, 50), border_width=1)
    discountBox     := box.new(pdAnchorBar, mid, pdRightX, pdLo, bgcolor=color.new(C_BULL, 93), border_color=color.new(C_BULL, 50), border_width=1)
    equilibriumLine := line.new(pdAnchorBar, mid, pdRightX, mid, color=color.new(C_NEUTRAL, 30), style=line.style_dashed, width=1)
    // v22 TOKEN-TRIM: premium/discount/EQ text labels removed to fit the 80k compile limit.
    // The red (premium) / green (discount) zone boxes + EQ line remain; _zoneMid gate unchanged.
    premiumLabel  := label.new(pdAnchorBar, mid, cleanMode ? " EQ " : " EQ 50% ", color=color.new(C_LBL_DARK, 30), textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_tiny)

// ═══════════════════════════════════════════════════════════════
// FIBONACCI — v15 P2-10: anchored at frozen PD ref when available
// ═══════════════════════════════════════════════════════════════
var line  fib50Line = na, var line fib618Line = na, var line fib786Line = na
var label fib50Lbl = na, var label fib618Lbl = na, var label fib786Lbl = na
var box   oteBox = na
var label oteLbl = na
// v21 FIX-7: persist OTE levels so priceInOTE is available on every bar for confluence
var float _fibOteTop = na
var float _fibOteBot = na
// v22 CRIT-1 fix: persist the three fib levels too
var float _fib50 = na, var float _fib618 = na, var float _fib786 = na

_fibUseFrozen = fibAnchorMode == "CHoCH leg (frozen)" and not na(pdRefHigh) and not na(pdRefLow)
fibSH = _fibUseFrozen ? pdRefHigh : lastSH
fibSL = _fibUseFrozen ? pdRefLow  : lastSL
fibSHIdx = _fibUseFrozen ? pdRefBar : lastSHIdx
fibSLIdx = _fibUseFrozen ? pdRefBar : lastSLIdx

// v22 CRIT-1 fix: compute fib/OTE levels on EVERY bar (was barstate.islast-only →
// _fibOteTop/_fibOteBot were na on all history → priceInOTE dead historically and live-only on
// the last bar = backtest/live divergence). Drawing still occurs only on the last bar below.
if showFibRet and not na(fibSH) and not na(fibSL)
    _isUp = internalTrend == 1 ? true : internalTrend == -1 ? false : (fibSLIdx < fibSHIdx)
    _rng = fibSH - fibSL
    _fib50  := _isUp ? fibSH - _rng * 0.50  : fibSL + _rng * 0.50
    _fib618 := _isUp ? fibSH - _rng * 0.618 : fibSL + _rng * 0.618
    _fib786 := _isUp ? fibSH - _rng * 0.786 : fibSL + _rng * 0.786
    _fibOteTop := math.max(_fib618, _fib786)
    _fibOteBot := math.min(_fib618, _fib786)

if showFibRet and not na(fibSH) and not na(fibSL) and barstate.islast
    leftX = _fibUseFrozen ? fibSHIdx : math.min(fibSHIdx, fibSLIdx)
    rightX = bar_index + 25
    fib_50  = _fib50
    fib_618 = _fib618
    fib_786 = _fib786

    if not na(fib50Line)
        line.delete(fib50Line)
    if not na(fib618Line)
        line.delete(fib618Line)
    if not na(fib786Line)
        line.delete(fib786Line)
    if not na(fib50Lbl)
        label.delete(fib50Lbl)
    if not na(fib618Lbl)
        label.delete(fib618Lbl)
    if not na(fib786Lbl)
        label.delete(fib786Lbl)

    fib50Line  := line.new(leftX, fib_50,  rightX, fib_50,  color=C_FIB_50,  width=1, style=line.style_dashed)
    fib50Lbl   := label.new(rightX, fib_50,  " 50% "    + str.tostring(fib_50,  format.mintick) + " ", color=C_FIB_50,  textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_small)
    fib618Line := line.new(leftX, fib_618, rightX, fib_618, color=C_FIB_618, width=2, style=line.style_solid)
    fib618Lbl  := label.new(rightX, fib_618, " ★ 61.8% " + str.tostring(fib_618, format.mintick) + " ", color=C_FIB_618, textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_normal)
    fib786Line := line.new(leftX, fib_786, rightX, fib_786, color=C_FIB_786, width=1, style=line.style_dotted)
    fib786Lbl  := label.new(rightX, fib_786, " 78.6% "  + str.tostring(fib_786, format.mintick) + " ", color=C_FIB_786, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
    // v22 CRIT-1: OTE bounds now computed every bar above — draw only here

    if showOTEZone
        if not na(oteBox)
            box.delete(oteBox)
        if not na(oteLbl)
            label.delete(oteLbl)
        oteTop = math.max(fib_618, fib_786)
        oteBot = math.min(fib_618, fib_786)
        oteBox := box.new(leftX, oteTop, rightX, oteBot, bgcolor=color.new(C_GOLD, oteOpacity), border_color=color.new(C_GOLD, 50), border_width=1)
        oteLbl := label.new(leftX, (oteTop + oteBot) / 2, " ⭐ OTE ", color=C_GOLD, textcolor=C_TEXT_BLACK, style=label.style_label_right, size=sz_small)


// ═══════════════════════════════════════════════════════════════
// LIQUIDITY + SWEEPS — v15 P0-2: not-broken guard added
// ═══════════════════════════════════════════════════════════════
// v17 C-BUG-1 fix: recompute each bar (were `var` → latched true forever after the first
// equal H/L, permanently inflating BOTH scores by +2 and lowering the real threshold).
// Now reflects the CURRENT last/prev swing equal-level state only.
bool hasBSL = false
bool hasSSL = false
var float lastBSLLabeled = na   // dedup memory for labels — stays var (intentional)
var float lastSSLLabeled = na

extLen = cleanMode ? math.max(2, shortExtensionLines - 2) : shortExtensionLines

f_isEqualLevel(_a, _b) =>
    if liqToleranceMode == "ATR fraction"
        math.abs(_a - _b) <= atrVal * liqToleranceAtr
    else
        math.abs(_a - _b) / _a * 100 < liqTolerance

if showLiq and not na(lastSH) and not na(prevSH)
    if f_isEqualLevel(lastSH, prevSH)
        if na(lastBSLLabeled) or not f_isEqualLevel(lastSH, lastBSLLabeled)
            // v16 M3 fix: pool BSL line + label (capped) — were unbounded line.new, leaked toward the 500-line ceiling
            _bslLn = line.new(lastSHIdx, lastSH, bar_index + extLen, lastSH, color=color.new(C_BEAR, 30), style=line.style_dotted, width=1)
            f_pushMiscLine(_bslLn)
            _bslLbl = label.new(bar_index + extLen, lastSH, " 💧 BSL ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
            f_pushMisc(_bslLbl)
            lastBSLLabeled := lastSH
        hasBSL := true

if showLiq and not na(lastSL) and not na(prevSL)
    if f_isEqualLevel(lastSL, prevSL)
        if na(lastSSLLabeled) or not f_isEqualLevel(lastSL, lastSSLLabeled)
            // v16 M3 fix: pool SSL line + label (capped)
            _sslLn = line.new(lastSLIdx, lastSL, bar_index + extLen, lastSL, color=color.new(C_BULL, 30), style=line.style_dotted, width=1)
            f_pushMiscLine(_sslLn)
            _sslLbl = label.new(bar_index + extLen, lastSL, " 💧 SSL ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
            f_pushMisc(_sslLbl)
            lastSSLLabeled := lastSL
        hasSSL := true

swingRangeSL = not na(lastSL) and not na(lastSH) ? lastSH - lastSL : 0
swingSignificant = swingRangeSL >= atrVal * sweepMinRange

_sweepConfirmed = barstate.isconfirmed
// v23 P2: SINGLE liquidity-event engine. Audit flagged sweep and grab as near-duplicate conditions.
// One base geometry per side (wick beyond the swing + close back inside), then SWEEP and GRAB are
// derived as classifications of the same event — no duplicated geometry. v15 P0-2 not-broken guard kept.
//   base  = stops run beyond SSL/BSL and price closes back inside the range
//   GRAB  = base + strong reversal close (close beyond open) → cleaner reversal signal
//   SWEEP = base + reversal-ish close (close>open OR close>close[1]) → broader
bullLiqEvent = _sweepConfirmed and swingSignificant and not na(lastSL) and not lastSLBroken and low < lastSL and close > lastSL
bearLiqEvent = _sweepConfirmed and swingSignificant and not na(lastSH) and not lastSHBroken and high > lastSH and close < lastSH
bullSweep_raw = detectSweeps and bullLiqEvent and (close > open or close > close[1])
bearSweep_raw = detectSweeps and bearLiqEvent and (close < open or close < close[1])

var int lastBullSweepSwingIdx = na
var int lastBearSweepSwingIdx = na

bullSweep = bullSweep_raw and (not dedupeSweepLabels or na(lastBullSweepSwingIdx) or lastBullSweepSwingIdx != lastSLIdx)
bearSweep = bearSweep_raw and (not dedupeSweepLabels or na(lastBearSweepSwingIdx) or lastBearSweepSwingIdx != lastSHIdx)

// v18 BUG-6 fix: sweep labels were direct label.new (bypassed _miscLabels pool, leaked toward 500-label cap).
// All 6 sweep label.new calls now routed through f_pushMisc (cap 50, oldest auto-deleted).
if bullSweep
    lastBullSweepSwingIdx := lastSLIdx
    _swLbl = sweepMarkerStyle == "Full label" ? label.new(bar_index, low, " 💎 SWEEP ▲ ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small, yloc=yloc.belowbar) : sweepMarkerStyle == "Compact triangle" ? label.new(bar_index, low, "▲", color=C_BULL, textcolor=C_TEXT_WHITE, style=label.style_triangleup, size=sz_tiny, yloc=yloc.belowbar) : label.new(bar_index, low, "◆", color=color.new(C_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_diamond, size=sz_tiny, yloc=yloc.belowbar)
    f_pushMisc(_swLbl)

if bearSweep
    lastBearSweepSwingIdx := lastSHIdx
    _swLbl2 = sweepMarkerStyle == "Full label" ? label.new(bar_index, high, " 💎 SWEEP ▼ ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar) : sweepMarkerStyle == "Compact triangle" ? label.new(bar_index, high, "▼", color=C_BEAR, textcolor=C_TEXT_WHITE, style=label.style_triangledown, size=sz_tiny, yloc=yloc.abovebar) : label.new(bar_index, high, "◆", color=color.new(C_BEAR, 20), textcolor=C_TEXT_WHITE, style=label.style_diamond, size=sz_tiny, yloc=yloc.abovebar)
    f_pushMisc(_swLbl2)

// v18 BUG-2 fix: grab logic was inverted vs ICT definition.
// ICT bull liq grab = wick BELOW SSL + close BACK ABOVE (stops run, reversal up).
// ICT bear liq grab = wick ABOVE BSL + close BACK BELOW (stops run, reversal down).
// Prior code had close > lastSH (bullish continuation) for "bearLiqGrab" and
// close < lastSL (bearish continuation) for "bullLiqGrab" — semantically and directionally wrong.
// Label arrows and liqOk gate assignments below are now logically consistent after this fix.
// v23 P2: GRAB = strong-reversal classification of the same base liquidity event (no dup geometry).
bullLiqGrab = detectLiqGrabs and bullLiqEvent and close > open
bearLiqGrab = detectLiqGrabs and bearLiqEvent and close < open
// classification string for the quant trade log (sweep vs grab vs none)
bullLiqClass = not bullLiqEvent ? "none" : (close > open ? "grab" : "sweep")
bearLiqClass = not bearLiqEvent ? "none" : (close < open ? "grab" : "sweep")

var int lastBullGrabSwingIdx = na
var int lastBearGrabSwingIdx = na

if bullLiqGrab and (na(lastBullGrabSwingIdx) or lastBullGrabSwingIdx != lastSLIdx)
    lastBullGrabSwingIdx := lastSLIdx
    _lg1 = label.new(bar_index, low, "⬆", color=color.new(C_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny, yloc=yloc.belowbar)
    f_pushMisc(_lg1)
if bearLiqGrab and (na(lastBearGrabSwingIdx) or lastBearGrabSwingIdx != lastSHIdx)
    lastBearGrabSwingIdx := lastSHIdx
    _lg2 = label.new(bar_index, high, "⬇", color=color.new(C_BEAR, 20), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny, yloc=yloc.abovebar)
    f_pushMisc(_lg2)

// AMD / POWER OF 3
var float amdAsiaHi = na, var float amdAsiaLo = na
var float amdAsiaHiBuilding = na, var float amdAsiaLoBuilding = na
var bool  amdAsiaBuilt = false
var bool  amdSweptToday = false

if inAsia
    if not inAsia[1]
        amdAsiaHiBuilding := high
        amdAsiaLoBuilding := low
        amdSweptToday := false
        // v23 FIX-H3: re-qualify Asia each session. amdAsiaBuilt previously latched true forever,
        // so on a low-range Asia day London compared price to a STALE prior-day level → false AMD
        // sweep that polluted confluence + satisfied the hard liq-gate. Clear state at each Asia open;
        // amdAsiaHi/Lo repopulate at Asia close only if range >= amdMinRangeATR (gate at not-inAsia block).
        amdAsiaBuilt := false
        amdAsiaHi := na
        amdAsiaLo := na
    else
        amdAsiaHiBuilding := math.max(amdAsiaHiBuilding, high)
        amdAsiaLoBuilding := math.min(amdAsiaLoBuilding, low)

if not inAsia and inAsia[1] and not na(amdAsiaHiBuilding) and not na(amdAsiaLoBuilding)
    asiaRng = amdAsiaHiBuilding - amdAsiaLoBuilding
    if not na(atrVal) and asiaRng >= atrVal * amdMinRangeATR
        amdAsiaHi := amdAsiaHiBuilding
        amdAsiaLo := amdAsiaLoBuilding
        amdAsiaBuilt := true

// v18 BUG-4 fix: `amdSweptToday` was written without barstate.isconfirmed.
// During the live bar, close fluctuates — if price wicked above amdAsiaHi and close was
// temporarily below it mid-candle, amdSweptToday was permanently set TRUE for the whole day
// even if the bar closed above (no real sweep). Now gated on barstate.isconfirmed so the
// state only locks when the bar is fully closed.
_amdConfirmed = barstate.isconfirmed
amdLondonSweepHi = _amdConfirmed and detectAMD and amdAsiaBuilt and inLondon and not amdSweptToday and not na(amdAsiaHi) and high > amdAsiaHi and close < amdAsiaHi
amdLondonSweepLo = _amdConfirmed and detectAMD and amdAsiaBuilt and inLondon and not amdSweptToday and not na(amdAsiaLo) and low < amdAsiaLo and close > amdAsiaLo

if amdLondonSweepHi or amdLondonSweepLo
    amdSweptToday := true

if amdLondonSweepHi
    _aml1 = label.new(bar_index, high, " 🌀 AMD ▼ ", color=color.new(C_LBL_BEAR, 20), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
    f_pushMisc(_aml1)
if amdLondonSweepLo
    _aml2 = label.new(bar_index, low, " 🌀 AMD ▲ ", color=color.new(C_LBL_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small, yloc=yloc.belowbar)
    f_pushMisc(_aml2)

// TURTLE SOUP
nBarHi = ta.highest(high[1], turtleSoupLookback)
nBarLo = ta.lowest(low[1], turtleSoupLookback)
// v19 REPAINT-2: confirmed bar only — prevents intrabar var-state write to lastBullLiqBar
turtleSoupBull = showTurtleSoup and barstate.isconfirmed and not na(nBarLo) and low < nBarLo and close > nBarLo and close > open
turtleSoupBear = showTurtleSoup and barstate.isconfirmed and not na(nBarHi) and high > nBarHi and close < nBarHi and close < open
if turtleSoupBull
    _ts1 = label.new(bar_index, low, " 🐢 TS ▲ ", color=color.new(C_GOLD, 20), textcolor=C_TEXT_BLACK, style=label.style_label_up, size=sz_tiny, yloc=yloc.belowbar)
    f_pushMisc(_ts1)
if turtleSoupBear
    _ts2 = label.new(bar_index, high, " 🐢 TS ▼ ", color=color.new(C_GOLD, 20), textcolor=C_TEXT_BLACK, style=label.style_label_down, size=sz_tiny, yloc=yloc.abovebar)
    f_pushMisc(_ts2)

// ═══════════════════════════════════════════════════════════════
// v19 ICT ADDITIONS — IDM, CISD, JUDAS SWING
// ═══════════════════════════════════════════════════════════════

// ICT-1: MINOR-SWING SWEEP (v23 FIX-#4: was mislabeled "IDM/Inducement").
// Honesty: canonical ICT inducement is a specific engineered liquidity pool taken BEFORE the real
// POI is reached. This code only detects a failed break / sweep of the last minor swing (wick beyond
// the swing, close back inside). That is a useful continuation cue but is NOT full inducement logic.
// Var names (idmBull/idmBear) + alert IDs kept for compatibility; only labels/comments clarified.
// idmBull: downtrend, high pokes above lastSH then closes back below (bearish continuation cue).
// idmBear: uptrend, low pokes below lastSL then closes back above (bullish continuation cue).
idmBull = barstate.isconfirmed and internalTrend == -1 and not na(lastSH) and not lastSHBroken and high > lastSH and close < lastSH and close < open
idmBear = barstate.isconfirmed and internalTrend == 1 and not na(lastSL) and not lastSLBroken and low < lastSL and close > lastSL and close > open

if idmBull
    _idmL = label.new(bar_index, high, " Sweep ▼ ", color=color.new(C_GOLD, 25), textcolor=C_TEXT_BLACK, style=label.style_label_down, size=sz_tiny, yloc=yloc.abovebar)
    f_pushMisc(_idmL)
if idmBear
    _idmS = label.new(bar_index, low, " Sweep ▲ ", color=color.new(C_GOLD, 25), textcolor=C_TEXT_BLACK, style=label.style_label_up, size=sz_tiny, yloc=yloc.belowbar)
    f_pushMisc(_idmS)

// ICT-2: CISD (Change In State of Delivery) — v23 FIX-H2: REAL delivery-sequence shift.
// Prior impl was a single-bar displaced close-through (close > prior HIGH) = an engulf variant,
// NOT a change in state of delivery. True CISD = a run of same-direction delivery candles, then the
// first opposite candle that closes back through the OPEN of the candle that STARTED that delivery
// leg (the "CISD level"). Tracks the leg explicitly on confirmed bars to avoid intrabar repaint.
var int   _cisdBearRun     = 0     // consecutive bearish-close candles (down delivery)
var int   _cisdBullRun     = 0     // consecutive bullish-close candles (up delivery)
var float _cisdBearLegOpen = na    // open of the FIRST candle of the active down leg = bull-CISD level
var float _cisdBullLegOpen = na    // open of the FIRST candle of the active up leg   = bear-CISD level
// snapshot prior-bar state BEFORE this bar's update, so the breaking bar reads the leg it is breaking
_wasBearRun     = _cisdBearRun
_wasBullRun     = _cisdBullRun
_wasBearLegOpen = _cisdBearLegOpen
_wasBullLegOpen = _cisdBullLegOpen
if barstate.isconfirmed
    if close < open
        if _cisdBearRun == 0
            _cisdBearLegOpen := open
        _cisdBearRun := _cisdBearRun + 1
        _cisdBullRun := 0
    else if close > open
        if _cisdBullRun == 0
            _cisdBullLegOpen := open
        _cisdBullRun := _cisdBullRun + 1
        _cisdBearRun := 0
// min 0.4 ATR displacement on the breaking candle keeps doji-grade flips out (preserves v20 FIX-3 intent)
_cisdBullDisp = (close - open) >= atrVal * 0.4 and close > open
_cisdBearDisp = (open - close) >= atrVal * 0.4 and close < open
// Bull CISD: >=2-candle down leg, current bullish candle closes ABOVE that leg's start open.
cisdBull = barstate.isconfirmed and _wasBearRun >= 2 and not na(_wasBearLegOpen) and close > _wasBearLegOpen and _cisdBullDisp
// Bear CISD: >=2-candle up leg, current bearish candle closes BELOW that leg's start open.
cisdBear = barstate.isconfirmed and _wasBullRun >= 2 and not na(_wasBullLegOpen) and close < _wasBullLegOpen and _cisdBearDisp

if cisdBull
    _cisdL = label.new(bar_index, low, " CISD ▲ ", color=color.new(C_PURPLE, 20), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny, yloc=yloc.belowbar)
    f_pushMisc(_cisdL)
if cisdBear
    _cisdS = label.new(bar_index, high, " CISD ▼ ", color=color.new(C_PURPLE, 20), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny, yloc=yloc.abovebar)
    f_pushMisc(_cisdS)

// ICT-3: Judas Swing — false directional move at London KZ open before true direction
// v20 FIX-4: one-shot per session — was firing every bar, inflating liqOkBull/Bear entire session
var float judasSessHigh = na, var float judasSessLow = na, var float judasSessOpen = na
var bool judasBullFired = false
var bool judasBearFired = false
if inLondonKZ and not inLondonKZ[1]
    judasSessOpen  := open
    judasSessHigh  := high
    judasSessLow   := low
    judasBullFired := false
    judasBearFired := false
else if inLondonKZ and not na(judasSessHigh)
    judasSessHigh := math.max(judasSessHigh, high)
    judasSessLow  := math.min(judasSessLow,  low)

// Judas Bull: London pushed DOWN >= 0.4 ATR then closes ABOVE session open (false push down)
_judasBullRaw = barstate.isconfirmed and inLondonKZ and not na(judasSessOpen) and (judasSessOpen - judasSessLow) >= atrVal * 0.4 and close > judasSessOpen and close > open
// Judas Bear: London pushed UP >= 0.4 ATR then closes BELOW session open (false push up)
_judasBearRaw = barstate.isconfirmed and inLondonKZ and not na(judasSessOpen) and (judasSessHigh - judasSessOpen) >= atrVal * 0.4 and close < judasSessOpen and close < open

judasBullSignal = _judasBullRaw and not judasBullFired
judasBearSignal = _judasBearRaw and not judasBearFired

if judasBullSignal
    judasBullFired := true
    _jL = label.new(bar_index, low, " ⚔ JUDAS ▲ ", color=color.new(C_ORANGE, 15), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small, yloc=yloc.belowbar)
    f_pushMisc(_jL)
if judasBearSignal
    judasBearFired := true
    _jS = label.new(bar_index, high, " ⚔ JUDAS ▼ ", color=color.new(C_ORANGE, 15), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
    f_pushMisc(_jS)

// PATTERNS — pin uses exposed pinMinBodyAtr (v15 P2-11)
candleBody  = math.abs(close - open)
candleRange = high - low
upperWick   = high - math.max(close, open)
lowerWick   = math.min(close, open) - low
_pinMinBody = atrVal * pinMinBodyAtr
bullPin = showPinBar and showPatterns and candleRange > 0 and candleBody >= _pinMinBody and lowerWick >= candleBody * pinBarRatio and lowerWick >= candleRange * 0.55 and upperWick <= candleBody * 0.5 and close > open
bearPin = showPinBar and showPatterns and candleRange > 0 and candleBody >= _pinMinBody and upperWick >= candleBody * pinBarRatio and upperWick >= candleRange * 0.55 and lowerWick <= candleBody * 0.5 and close < open

// v16 M2 fix: draw pin markers only on confirmed bar (booleans still feed confluence/triggers).
// Prevents the 🔨/⭐ label flickering as the live bar's wick/body ratios change tick-to-tick.
if bullPin and barstate.isconfirmed
    _pl = label.new(bar_index, low, " 🔨 ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small, yloc=yloc.belowbar)
    f_pushMisc(_pl)
if bearPin and barstate.isconfirmed
    _pl2 = label.new(bar_index, high, " ⭐ ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
    f_pushMisc(_pl2)

doubleTopWindow = swingLen + 5
_dtTol = atrVal * 0.3
doubleTopRaw = showDoubleTB and showPatterns and not na(lastSH) and not na(prevSH) and not na(atrVal) and math.abs(lastSH - prevSH) <= _dtTol and (bar_index - lastSHIdx) < doubleTopWindow and not na(lastSL) and lastSL < math.min(lastSH, prevSH)
doubleBotRaw = showDoubleTB and showPatterns and not na(lastSL) and not na(prevSL) and not na(atrVal) and math.abs(lastSL - prevSL) <= _dtTol and (bar_index - lastSLIdx) < doubleTopWindow and not na(lastSH) and lastSH > math.max(lastSL, prevSL)

var int lastDoubleTopSwingIdx = na
var int lastDoubleBotSwingIdx = na
doubleTop = doubleTopRaw and (na(lastDoubleTopSwingIdx) or lastDoubleTopSwingIdx != lastSHIdx)
doubleBot = doubleBotRaw and (na(lastDoubleBotSwingIdx) or lastDoubleBotSwingIdx != lastSLIdx)

if doubleTop
    lastDoubleTopSwingIdx := lastSHIdx
if doubleBot
    lastDoubleBotSwingIdx := lastSLIdx

if doubleTop
    _dtLn = line.new(prevSHIdx, prevSH, lastSHIdx, lastSH, color=color.new(C_BEAR, 40), width=1, style=line.style_dotted)
    f_pushMiscLine(_dtLn)
    _dtLbl = cleanMode ? label.new(lastSHIdx, lastSH, " =H ", color=color.new(C_LBL_BEAR, 30), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny) : label.new(lastSHIdx, lastSH, " 🔻 DT ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small)
    f_pushMisc(_dtLbl)
if doubleBot
    _dbLn = line.new(prevSLIdx, prevSL, lastSLIdx, lastSL, color=color.new(C_BULL, 40), width=1, style=line.style_dotted)
    f_pushMiscLine(_dbLn)
    _dbLbl = cleanMode ? label.new(lastSLIdx, lastSL, " =L ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny) : label.new(lastSLIdx, lastSL, " 🔺 DB ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small)
    f_pushMisc(_dbLbl)

// ═══════════════════════════════════════════════════════════════
// CONFLUENCE — v15 with POI age decay
// ═══════════════════════════════════════════════════════════════
bullEngulf = isBullC and isBearC[1] and open <= close[1] and close >= open[1] and (close - open) > (open[1] - close[1])
bearEngulf = isBearC and isBullC[1] and open >= close[1] and close <= open[1] and (open - close) > (close[1] - open[1])

mid_ = not na(lastSH) and not na(lastSL) ? (lastSH + lastSL) / 2 : close

// v14 B2: Frozen PD ref mid
_zoneMid = not na(pdRefHigh) and not na(pdRefLow) ? (pdRefHigh + pdRefLow) / 2 : mid_

// v21 FIX-5: gate fresh-bar FVG booleans with barstate.isconfirmed so intrabar score
// fluctuation is eliminated. Box push was already gated (v19 REPAINT-1); confluence now matches.
_bullFVGConfirmed = bullFVG and barstate.isconfirmed
_bearFVGConfirmed = bearFVG and barstate.isconfirmed
ltfBullPOI = priceInBullOB or priceInBullFVG or _bullFVGConfirmed or priceInBullBreaker or priceInBullInverted
ltfBearPOI = priceInBearOB or priceInBearFVG or _bearFVGConfirmed or priceInBearBreaker or priceInBearInverted

// v21 FIX-7: OTE zone presence for confluence (price inside 61.8–78.6% Fib retrace)
priceInOTE = showFibRet and showOTEZone and not na(_fibOteTop) and not na(_fibOteBot) and low <= _fibOteTop and high >= _fibOteBot

// v15 P2-9: Determine freshest contributing POI bar for age-decay weight
bullPOIFreshBar = math.max(bullOBFreshBar, bullFVGFreshBar)
bearPOIFreshBar = math.max(bearOBFreshBar, bearFVGFreshBar)
bullPOIWeight = ltfBullPOI ? f_poiAgeWeight(bullPOIFreshBar) : 0
bearPOIWeight = ltfBearPOI ? f_poiAgeWeight(bearPOIFreshBar) : 0

// ═══════════════════════════════════════════════════════════════
// CONFLUENCE — v23 ISSUE-3: ORTHOGONAL SCORING MODEL
//   Audit defect: bull/bear score double-counted correlated inputs — trend was scored TWICE
//   (MTF bias +3 AND internalTrend +2), and zone/OTE/POI all encode the same "price is at a
//   discount" idea (+2/+2/+2). Correlated points inflate the score without adding information.
//   Fix: 5 mutually-exclusive categories, each CAPPED so no single market property can score
//   more than its category allows. Trend counts ONCE (single best source).
//     Trend (≤3) · OrderFlow/Location (≤3) · Liquidity (≤2) · Timing (≤1) · SMT (≤smtWeight)
//     + Volatility (≤_volMax, 0 on FX) kept orthogonal.
// ═══════════════════════════════════════════════════════════════
// category caps (also used for the dashboard /max denominator)
_zoneMax = (not (useHardGate and hgRequireZone)) ? 1 : 0   // zone now contributes inside OrderFlow cap
_kzMax   = (not (useHardGate and hgRequireKZ))   ? 1 : 0
_volMax  = _isForexOrOTC ? 0 : 1                            // volBoost permanently 0 on FX/OTC
_smtMax  = useSMT ? smtWeight : 0
_trendMax = 3
_ofMax    = 3
_liqMax   = 2
_timeMax  = 1

// ---- BULL ----
// Trend (single source — no double count): MTF bias > entry-track trend > single-HTF bias
_trendBull = mtfBullBias ? 3 : entryTrend == 1 ? 2 : trendHTF1 == 1 ? 1 : 0
// Order-flow / location (zone discount, OTE, fresh POI, HTF POI, IDM/CISD) — correlated, so CAPPED at 3
_ofBullRaw = (_zoneMax > 0 and not na(_zoneMid) and close < _zoneMid ? 1 : 0) + (priceInOTE ? 1 : 0) + (bullPOIWeight > 0 ? 1 : 0) + (useHTFPOI and (priceInHTFBullFVG or priceInHTFBullOB) ? 1 : 0) + ((idmBear or cisdBull) ? 1 : 0)
_ofBull = math.min(_ofMax, _ofBullRaw)
// Liquidity (sweep/grab, AMD/turtle, pin/double) — CAPPED at 2. v19 SCORE-1 self-validation kept:
// a sweep that is itself the trigger still only contributes 1 within the cap.
_bullSweepScore = bullSweep and not bullEngulf and not (includePinBarSignals and bullPin) ? 1 : (hasSSL or bullSweep) ? 1 : 0
_liqBullRaw = _bullSweepScore + ((amdLondonSweepLo or turtleSoupBull) ? 1 : 0) + ((bullPin or doubleBot) ? 1 : 0)
_liqBull = math.min(_liqMax, _liqBullRaw)
// Timing (KZ boost + Judas-non-sole) — CAPPED at 1
_judasBullSoleTrigger = judasBullSignal and not bullEngulf and not (includePinBarSignals and bullPin) and not (includeSweepSignals and bullSweep) and not (useSMT and smtBull) and not cisdBull
_timeBull = math.min(_timeMax, (_kzMax > 0 and killzoneBoostConfluence and inAnyKZ ? 1 : 0) + (judasBullSignal and not _judasBullSoleTrigger ? 1 : 0))
// SMT + Volatility (orthogonal)
_smtBullScore = smtBull ? smtWeight : 0
_volBullScore = volBoost ? 1 : 0
bullScore = _trendBull + _ofBull + _liqBull + _timeBull + _smtBullScore + _volBullScore

// ---- BEAR ----
_trendBear = mtfBearBias ? 3 : entryTrend == -1 ? 2 : trendHTF1 == -1 ? 1 : 0
_ofBearRaw = (_zoneMax > 0 and not na(_zoneMid) and close > _zoneMid ? 1 : 0) + (priceInOTE ? 1 : 0) + (bearPOIWeight > 0 ? 1 : 0) + (useHTFPOI and (priceInHTFBearFVG or priceInHTFBearOB) ? 1 : 0) + ((idmBull or cisdBear) ? 1 : 0)
_ofBear = math.min(_ofMax, _ofBearRaw)
_bearSweepScore = bearSweep and not bearEngulf and not (includePinBarSignals and bearPin) ? 1 : (hasBSL or bearSweep) ? 1 : 0
_liqBearRaw = _bearSweepScore + ((amdLondonSweepHi or turtleSoupBear) ? 1 : 0) + ((bearPin or doubleTop) ? 1 : 0)
_liqBear = math.min(_liqMax, _liqBearRaw)
_judasBearSoleTrigger = judasBearSignal and not bearEngulf and not (includePinBarSignals and bearPin) and not (includeSweepSignals and bearSweep) and not (useSMT and smtBear) and not cisdBear
_timeBear = math.min(_timeMax, (_kzMax > 0 and killzoneBoostConfluence and inAnyKZ ? 1 : 0) + (judasBearSignal and not _judasBearSoleTrigger ? 1 : 0))
_smtBearScore = smtBear ? smtWeight : 0
_volBearScore = volBoost ? 1 : 0
bearScore = _trendBear + _ofBear + _liqBear + _timeBear + _smtBearScore + _volBearScore

// v23 attainable max = sum of category caps. Trend(3)+OrderFlow(3)+Liquidity(2)+Timing(_timeMax)
// +SMT(_smtMax)+Vol(_volMax). Used by the dashboard "/max" so the displayed ratio is honest.
maxScore_v15 = _trendMax + _ofMax + _liqMax + _timeMax + _smtMax + _volMax

canEnterByKZ = not killzoneOnly or inAnyKZ

var int lastBullSignalBar = -1000
var int lastBearSignalBar = -1000

cooldownOkBull = useGlobalCooldown ? (bar_index - math.max(lastBullSignalBar, lastBearSignalBar)) >= signalCooldownBars : (bar_index - lastBullSignalBar) >= signalCooldownBars
cooldownOkBear = useGlobalCooldown ? (bar_index - math.max(lastBullSignalBar, lastBearSignalBar)) >= signalCooldownBars : (bar_index - lastBearSignalBar) >= signalCooldownBars

// v15 P1-5: Displacement applied to engulf only by default
_bodyAbs = math.abs(close - open)
dispOkBullEngulf = not useDisplacement or (not na(atrVal) and _bodyAbs >= atrVal * dispBodyAtr and close > open)
dispOkBearEngulf = not useDisplacement or (not na(atrVal) and _bodyAbs >= atrVal * dispBodyAtr and close < open)
dispOkBullPin = not (useDisplacement and dispAppliesToPins) or (not na(atrVal) and _bodyAbs >= atrVal * dispBodyAtr and close > open)
dispOkBearPin = not (useDisplacement and dispAppliesToPins) or (not na(atrVal) and _bodyAbs >= atrVal * dispBodyAtr and close < open)

// v19: SMT divergence + CISD + Judas Swing added as entry triggers
bullTrigger = (bullEngulf and dispOkBullEngulf) or (includePinBarSignals and bullPin and dispOkBullPin) or (includeSweepSignals and bullSweep) or (useSMT and smtBull) or cisdBull or judasBullSignal
bearTrigger = (bearEngulf and dispOkBearEngulf) or (includePinBarSignals and bearPin and dispOkBearPin) or (includeSweepSignals and bearSweep) or (useSMT and smtBear) or cisdBear or judasBearSignal

// v23 ISSUE-2: entry MSS now qualified by the dedicated ENTRY structure track (entrySwingLen),
// not the fast pivot-3 display track. entryTrend alignment OR a fresh entry-track MSS event.
mssOkBull = not useInternalMSS or entryMssBull or entryTrend == 1
mssOkBear = not useInternalMSS or entryMssBear or entryTrend == -1

validBullEntryRaw = bullTrigger and mssOkBull and (requireConfluence ? bullScore >= minConfluence : true) and canEnterByKZ
validBearEntryRaw = bearTrigger and mssOkBear and (requireConfluence ? bearScore >= minConfluence : true) and canEnterByKZ

// v23 ISSUE-6: Institutional Mode forces confirmed-bar entries (non-repaint). Experimental
// intrabar mode is only reachable when both institutionalMode AND waitForBarClose are OFF.
_barOk = institutionalMode ? barstate.isconfirmed : (not waitForBarClose or barstate.isconfirmed)

_htfBullCount = (trendHTF1 == 1 ? 1 : 0) + (trendHTF2 == 1 ? 1 : 0) + (trendHTF3 == 1 ? 1 : 0)
_htfBearCount = (trendHTF1 == -1 ? 1 : 0) + (trendHTF2 == -1 ? 1 : 0) + (trendHTF3 == -1 ? 1 : 0)
htfAlignedBull = not hgRequireHTF or _htfBullCount >= 2
htfAlignedBear = not hgRequireHTF or _htfBearCount >= 2

zoneOkBull = not hgRequireZone or (not na(_zoneMid) and close < _zoneMid)
zoneOkBear = not hgRequireZone or (not na(_zoneMid) and close > _zoneMid)

_kzGateActive = hgRequireKZ and not _isOTC
kzOkHard = not _kzGateActive or inAnyKZ

var int lastBullLiqBar = -1000
var int lastBearLiqBar = -1000
if bullSweep or bullLiqGrab or amdLondonSweepLo or turtleSoupBull or smtBull or judasBullSignal
    lastBullLiqBar := bar_index
if bearSweep or bearLiqGrab or amdLondonSweepHi or turtleSoupBear or smtBear or judasBearSignal
    lastBearLiqBar := bar_index
liqOkBull = not hgRequireLiq or (bar_index - lastBullLiqBar) <= hgLiqLookback
liqOkBear = not hgRequireLiq or (bar_index - lastBearLiqBar) <= hgLiqLookback

volOkHard = not hgRequireVol or volatilityHealthy

hardGateBull = not useHardGate or (htfAlignedBull and zoneOkBull and kzOkHard and liqOkBull and volOkHard)
hardGateBear = not useHardGate or (htfAlignedBear and zoneOkBear and kzOkHard and liqOkBear and volOkHard)

f_inNewsWindow() =>
    blocked = false
    if useNewsBlocker
        _nowM = hour(time, "America/New_York") * 60 + minute(time, "America/New_York")
        _parts = str.split(newsWindows, ",")
        if array.size(_parts) > 0
            for _i = 0 to array.size(_parts) - 1
                _s = str.trim(array.get(_parts, _i))
                if str.length(_s) >= 3
                    _hhmm = str.tonumber(_s)
                    if not na(_hhmm)
                        _h = math.floor(_hhmm / 100)
                        _m = _hhmm - _h * 100
                        _evtM = _h * 60 + _m
                        if math.abs(_nowM - _evtM) <= newsBufferMin
                            blocked := true
                            break
    blocked
newsBlocked = f_inNewsWindow()

// v19 RISK-2: declare posDirection/posEntry/posOrigSL early so _unrealizedR_guard can read them
// Full initialization happens in POSITION MANAGEMENT below; defaults (0/na/na) are safe for guard math.
var int   posDirection = 0
var float posEntry     = na
var float posOrigSL    = na

// Risk guards
var float dayRealizedR = 0.0
var int   dayBar = na
// v17 C-BUG-2 fix: declared early so it can be reset on the new-day boundary below.
var int consecLosses = 0
// AUDIT FIX-4: per-day trade counter — declared early so the new-day boundary below can reset it.
var int tradesToday = 0
// FIX-3 (audit HIGH-4): reset on 17:00 NY FX rollover by default, not chart-exchange midnight.
_nyHourNow  = hour(time, "America/New_York")
_nyHourPrev = hour(time[1], "America/New_York")
_fxRollover = _nyHourNow == 17 and _nyHourPrev != 17
isNewTradingDay = na(dayBar) or (dailyResetAnchor == "Chart exchange midnight" ? ta.change(time("D")) != 0 : _fxRollover)
if isNewTradingDay
    dayRealizedR := 0.0
    dayBar := bar_index
    // v17 C-BUG-2 fix: reset consecutive losses each new trading day. Was NEVER reset →
    // maxConsecLosses hits anywhere in history permanently locked out ALL future entries.
    consecLosses := 0
    // AUDIT FIX-4: per-day trade counter reset on the same daily anchor as the loss/consec counters.
    tradesToday := 0
var int   tradesThisKZ = 0
var bool  inAnyKZ_prev = false
if inAnyKZ and not inAnyKZ_prev
    tradesThisKZ := 0
inAnyKZ_prev := inAnyKZ

// consecLosses declared + daily-reset above (moved up — C-BUG-2 fix)
// v19 RISK-2: include open unrealized R so an open loss counts against daily cap
_guardRisk = math.abs(posEntry - posOrigSL)
// FIX-3 (audit HIGH-3): use the most-adverse INTRABAR extreme (low for long, high for short),
// not close. A position −NR at the bar low that recovers by close must still block new entries.
_guardAdverse = posDirection == 1 ? low : high
_unrealizedR_guard = posDirection != 0 and not na(posEntry) and _guardRisk > 0 ? (posDirection == 1 ? _guardAdverse - posEntry : posEntry - _guardAdverse) / _guardRisk : 0.0
dailyOk = not useDailyLossCap or (dayRealizedR + _unrealizedR_guard) > dailyLossR
// AUDIT FIX-3: cap applies on EVERY bar. Inside a KZ → per-window cap (tradesThisKZ). Outside any
// KZ → per-day cap (tradesToday). Prior form short-circuited true when not inAnyKZ → unbounded
// off-session entries when killzoneOnly=false.
kzTradeCapOk = not useMaxTradesKZ or (inAnyKZ ? tradesThisKZ < maxTradesPerKZ : tradesToday < maxTradesPerDay)
consecOk = not useMaxConsecLosses or consecLosses < maxConsecLosses

// v19 RISK-1: dynamic equity — updates after each closed trade (starts at accountEquity input)
// Declared here so drawdownOk is available for validBullEntry/validBearEntry
var float realEquity = accountEquity
var float peakEquity = accountEquity

// ════════ FIX-1 (audit CRITICAL-1): account-currency point value ════════
// Sizing + P&L previously assumed 1 unit × 1 price-point = $1 — true only for USD-quoted,
// point-value-1 symbols. That silently corrupted realEquity / drawdown% / margin% / dollar P&L
// on JPY & cross FX, indices, and metals (3 of 4 target asset classes). valuePerPoint converts a
// 1.0 price-point move on 1 unit into ACCOUNT currency (assumed USD — accountEquity is "$").
// Pine v5: request.security cannot be ternary-gated → fetch both conversion candidates uncond.
_acctCur  = acctCurrency
_quoteCur = syminfo.currency
_qToAcct  = request.security(_quoteCur + _acctCur, timeframe.period, close, ignore_invalid_symbol=true, lookahead=barmerge.lookahead_off)
_acctToQ  = request.security(_acctCur + _quoteCur, timeframe.period, close, ignore_invalid_symbol=true, lookahead=barmerge.lookahead_off)
_quoteToAcctRate = _quoteCur == _acctCur ? 1.0 : not na(_qToAcct) ? _qToAcct : (not na(_acctToQ) and _acctToQ > 0 ? 1.0 / _acctToQ : 1.0)
// MED-fix: surface the silent FX-rate fallback. When neither quote→acct nor acct→quote resolves,
// valuePerPoint quietly assumes 1.0 → mis-sizing on that symbol. Latch a flag to warn on the chart.
var bool _fxConvUnresolved = false
if barstate.isconfirmed and _quoteCur != _acctCur and na(_qToAcct) and (na(_acctToQ) or _acctToQ <= 0)
    _fxConvUnresolved := true
// syminfo.pointvalue carries the contract/lot multiplier (indices, metals, futures); ×FX conv → account $.
// USD-quoted majors & crypto resolve to valuePerPoint=1.0 → identical to prior behaviour (regression-safe).
valuePerPoint = (na(syminfo.pointvalue) or syminfo.pointvalue <= 0 ? 1.0 : syminfo.pointvalue) * _quoteToAcctRate

// v23 P2: UNIFIED equity-compounding helper — single source of truth for all ~10 exit sites that
// previously inlined a duplicated useSizing if/else. Two intentionally-asymmetric regimes, EXACTLY
// preserving prior behaviour:
//   sizing ON  & units>0      → dollar compounding: eq + dollarPnLPerUnit × units
//                               (partials already booked at TP, so only the booked move is passed)
//   sizing OFF & riskPerUnit>0 → R-proxy compounding: eq × (1 + Rmultiple × risk%)
//                               (partials are NOT booked when sizing off, so Rmultiple carries the
//                                full trade R incl. partials at the final/flip exit)
//   otherwise                 → unchanged (mirrors the old "do nothing" degenerate guards)
// Always clamped at 0 (no negative equity). Pair every call with: peakEquity := math.max(peakEquity, realEquity)
f_equityStep(float eq, float dollarPnLPerUnit, float units, float rMultiple, float riskPerUnit) =>
    // FIX-1: dollarPnLPerUnit is a per-unit PRICE move; × valuePerPoint → account currency.
    // R-proxy branch (sizing off) is unitless and intentionally NOT scaled.
    useSizing and units > 0 ? math.max(0.0, eq + dollarPnLPerUnit * units * valuePerPoint) : (not useSizing and riskPerUnit > 0 ? math.max(0.0, eq * (1 + rMultiple * riskPctEquity / 100.0)) : eq)

// v19 RISK-3: max drawdown tracking
_currentDrawdownPct = peakEquity > 0 ? (peakEquity - realEquity) / peakEquity * 100.0 : 0.0
drawdownOk = not useMaxDrawdown or _currentDrawdownPct < maxDrawdownPct

validBullEntry = validBullEntryRaw and cooldownOkBull and _barOk and hardGateBull and not newsBlocked and dailyOk and kzTradeCapOk and consecOk and drawdownOk
validBearEntry = validBearEntryRaw and cooldownOkBear and _barOk and hardGateBear and not newsBlocked and dailyOk and kzTradeCapOk and consecOk and drawdownOk

// AUDIT FIX-4: cooldown bookkeeping stays at SIGNAL time (cooldown is about signals), but the
// trade-cap counters (tradesThisKZ/tradesToday) moved to EXECUTION sites below — a signal rejected
// at next-bar execution (margin/DD/news/guard) must not consume a cap slot.
if validBullEntry
    lastBullSignalBar := bar_index
    if not useGlobalCooldown
        lastBearSignalBar := math.max(lastBearSignalBar, bar_index - signalCooldownBars + 3)
if validBearEntry
    lastBearSignalBar := bar_index
    if not useGlobalCooldown
        lastBullSignalBar := math.max(lastBullSignalBar, bar_index - signalCooldownBars + 3)

sigSize_sig = signalLabelSize == "Tiny" ? size.tiny : signalLabelSize == "Small" ? size.small : signalLabelSize == "Normal" ? size.normal : size.large
sigBullText = signalLabelStyle == "Compact" ? "▲" : "▲ LONG"
sigBearText = signalLabelStyle == "Compact" ? "▼" : "▼ SHORT"

// v19 LABEL-1: route signal labels through pool (closes leak toward 500-label cap)
if showEngulf and validBullEntry
    f_pushMisc(label.new(bar_index, low, sigBullText, color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sigSize_sig, yloc=yloc.belowbar))

if showEngulf and validBearEntry
    f_pushMisc(label.new(bar_index, high, sigBearText, color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sigSize_sig, yloc=yloc.abovebar))

plotshape(validBullEntry, title="LONG Signal", location=location.belowbar, style=shape.triangleup,   color=color.new(C_BULL, 100), size=size.tiny, display=display.none)
plotshape(validBearEntry, title="SHORT Signal", location=location.abovebar, style=shape.triangledown, color=color.new(C_BEAR, 100), size=size.tiny, display=display.none)

// ═══════════════════════════════════════════════════════════════
// POSITION MANAGEMENT — v15 P1-4 same-bar resolution, P1-7 fill mode, P0-3 sizing
// ═══════════════════════════════════════════════════════════════
// posDirection, posEntry, posOrigSL declared above (hoisted for v19 RISK-2 guard)
var float posSL             = na
var float posTP1            = na
var float posTP2            = na
var float posTP3            = na
var bool  posTP1Hit         = false
var bool  posTP2Hit         = false
var float posSizeRemaining  = 1.0
var float posRealizedPnL    = 0.0
var int   posOpenBar        = na
var int   posOpenScore      = 0
var float posUnitSize       = 0.0   // v15 P0-3: position units/lots (display)
var float posUnitsRaw       = 0.0   // v16 H2: raw units for dollar P&L conversion
var line  posEntryLine      = na, var line posSLLine = na
var line  posTP1Line        = na, var line posTP2Line = na, var line posTP3Line = na
var label posEntryLbl       = na, var label posSLLbl = na
var label posTP1Lbl         = na, var label posTP2Lbl = na, var label posTP3Lbl = na
var label posPnLLbl         = na
var box   rewardBox         = na, var box riskBox = na

var float vizLastSL         = na
var float vizLastTP1        = na
var float vizLastTP2        = na
var float vizLastTP3        = na
var float vizLastEntry      = na
var int   vizLastDir        = 0
var bool  vizLastTP1Hit     = false
var bool  vizLastTP2Hit     = false
var int   vizLastRightX     = na

pipSize   = syminfo.mintick * 10
slBuffer  = slBufferMode == "ATR fraction" ? atrVal * slBufferAtrFrac : slBufferPips * pipSize

// v16 H1 / v19 RISK-5: round-trip trading cost = spread + commission + slippage
_spreadPrice    = costSpreadMode == "Pips (forex)" ? costSpreadVal * pipSize : costSpreadMode == "Ticks" ? costSpreadVal * syminfo.mintick : costSpreadVal
_slippagePrice  = costSpreadMode == "Pips (forex)" ? costSlippageVal * pipSize : costSpreadMode == "Ticks" ? costSlippageVal * syminfo.mintick : costSlippageVal
tradeCostPerUnit = useCosts ? _spreadPrice + costCommPrice + _slippagePrice : 0.0

f_calcSL(_isLong) =>
    if slMode == "ATR-based"
        _isLong ? low[1] - atrVal * atrMult : high[1] + atrVal * atrMult
    else if slMode == "Swing-based" and not na(lastSL) and not na(lastSH)
        _isLong ? math.min(low[1], lastSL) - slBuffer : math.max(high[1], lastSH) + slBuffer
    else
        _isLong ? low[1] - slBuffer : high[1] + slBuffer

// v19 RISK-1+4: uses realEquity (dynamic) and applies max lot cap
f_calcUnitSize(_entry, _sl) =>
    _riskDollar = realEquity * (riskPctEquity / 100.0)
    _riskPerUnit = math.abs(_entry - _sl)
    // FIX-1: risk-per-unit in ACCOUNT $ = price distance × valuePerPoint → real broker units.
    _riskPerUnitAcct = _riskPerUnit * valuePerPoint
    _units = _riskPerUnitAcct > 0 ? _riskDollar / _riskPerUnitAcct : 0.0
    _sized = sizingMode == "Lots (forex)" ? _units / forexLotSize : _units
    useLotCap ? math.min(maxLotsCap, _sized) : _sized

// v19 RISK-1+4: uses realEquity + applies lot cap (raw units = lot-divided × forexLotSize for forex)
f_calcRawUnits(_entry, _sl) =>
    _riskDollar = realEquity * (riskPctEquity / 100.0)
    _riskPerUnit = math.abs(_entry - _sl)
    // FIX-1: account-$ risk per unit → real broker units (matches f_calcUnitSize).
    _riskPerUnitAcct = _riskPerUnit * valuePerPoint
    _rawFull = _riskPerUnitAcct > 0 ? _riskDollar / _riskPerUnitAcct : 0.0
    if useLotCap
        _lotsCapped = sizingMode == "Lots (forex)" ? math.min(maxLotsCap, _rawFull / forexLotSize) * forexLotSize : math.min(maxLotsCap, _rawFull)
        _lotsCapped
    else
        _rawFull

// v22 MED-6: estimated margin % for a prospective entry (0 when gate disabled)
// FIX-2 (audit HIGH-2): no longer gated on useSizing — the guard must protect even R-proxy mode,
// where no broker size is otherwise computed. f_calcRawUnits derives units from realEquity+risk%
// regardless of the sizing-display toggle. FIX-1: ×valuePerPoint → notional in account currency.
f_marginPct(_px, _sl) =>
    _u = useMarginBlock ? f_calcRawUnits(_px, _sl) : 0.0
    (useMarginBlock and accountLeverage > 0 and realEquity > 0) ? (_u * _px * valuePerPoint) / (realEquity * accountLeverage) * 100.0 : 0.0

f_clearPositionViz() =>
    if not na(posEntryLine)
        line.delete(posEntryLine)
    if not na(posSLLine)
        line.delete(posSLLine)
    if not na(posTP1Line)
        line.delete(posTP1Line)
    if not na(posTP2Line)
        line.delete(posTP2Line)
    if not na(posTP3Line)
        line.delete(posTP3Line)
    if not na(posEntryLbl)
        label.delete(posEntryLbl)
    if not na(posSLLbl)
        label.delete(posSLLbl)
    if not na(posTP1Lbl)
        label.delete(posTP1Lbl)
    if not na(posTP2Lbl)
        label.delete(posTP2Lbl)
    if not na(posTP3Lbl)
        label.delete(posTP3Lbl)
    if not na(posPnLLbl)
        label.delete(posPnLLbl)
    if not na(rewardBox)
        box.delete(rewardBox)
    if not na(riskBox)
        box.delete(riskBox)

// v16 H2: dollar P&L = per-unit price P&L × raw units. Includes a half-spread on the still-open portion
// so the live figure is not optimistic. 0 if sizing disabled.
// Defined FIRST — f_totalPnLPct calls this; Pine v5 does not hoist user functions.
f_totalPnLDollar(_currentPrice) =>
    unrealizedPnL = posDirection == 1 ? (_currentPrice - posEntry) * posSizeRemaining : (posEntry - _currentPrice) * posSizeRemaining
    _openCost = tradeCostPerUnit * 0.5 * posSizeRemaining
    totalPnL = posRealizedPnL + unrealizedPnL - _openCost
    // FIX-1: per-unit price P&L × raw units × account-currency value per point.
    totalPnL * posUnitsRaw * valuePerPoint

// v18 FIX-11: prior formula used (totalPnL / posEntry) × 100 — dividing price×fraction by an
// absolute price level. Result was ~0.5-1% on EURUSD while actual equity impact was 5-10%.
// When position sizing is enabled, return actual % of accountEquity (dollar P&L / equity).
// When sizing is disabled, fall back to price-normalized % (best available without lot size).
f_totalPnLPct(_currentPrice) =>
    unrealizedPnL = posDirection == 1 ? (_currentPrice - posEntry) * posSizeRemaining : (posEntry - _currentPrice) * posSizeRemaining
    totalPnL = posRealizedPnL + unrealizedPnL
    useSizing and accountEquity > 0 ? (f_totalPnLDollar(_currentPrice) / accountEquity) * 100 : (totalPnL / posEntry) * 100

f_rMultiple(_currentPrice) =>
    unrealizedPnL = posDirection == 1 ? (_currentPrice - posEntry) * posSizeRemaining : (posEntry - _currentPrice) * posSizeRemaining
    totalPnL = posRealizedPnL + unrealizedPnL
    risk_per_unit = math.abs(posEntry - posOrigSL)
    risk_per_unit > 0 ? totalPnL / risk_per_unit : 0

// v15 P1-7: Pending entry/flip — applies to BOTH initial entry and flip
var bool  pendingOpenLong   = false
var bool  pendingOpenShort  = false
var bool  pendingFlipToLong = false
var bool  pendingFlipToShort = false

// v22 HIGH-3: stash the flipped-out position so its exit P&L is booked at the next bar's OPEN
// (the real fill price) instead of the signal-bar CLOSE. _flipExitDir 0 = nothing pending.
var int   _flipExitDir      = 0
var float _flipExitEntry    = na
var float _flipExitOrigSL   = na
var float _flipExitSize     = na
var float _flipExitRealized = na
var float _flipExitUnitsRaw = na

_useNextBarFill = fillMode == "Next bar open"

// Execute deferred OPEN/flip on this bar's open
// v18 BUG-3 fix: re-check dailyOk + consecOk + kzTradeCapOk at execution time.
// Previously these guards were only checked at SIGNAL time. A flip that pushed dayRealizedR
// past the daily cap on the signal bar simultaneously queued pendingFlipToLong — that pending
// entry then executed on the next bar regardless of the now-failed cap. Clear pending and
// skip if any guard now fails.
// v22 HIGH-3: book any deferred flip exit ONCE at this bar's open (direction-agnostic)
if _useNextBarFill and _flipExitDir != 0 and not na(_flipExitEntry)
    _fxPnL = (_flipExitDir == 1 ? (open - _flipExitEntry) : (_flipExitEntry - open)) * _flipExitSize - tradeCostPerUnit * _flipExitSize
    _fxRisk = math.abs(_flipExitEntry - _flipExitOrigSL)
    if _fxRisk > 0
        _fxR = (_flipExitRealized + _fxPnL) / _fxRisk
        dayRealizedR := dayRealizedR + _fxR
        consecLosses := _fxR < 0 ? consecLosses + 1 : 0
        // v23 P2: unified via f_equityStep (was inlined if/else)
        realEquity := f_equityStep(realEquity, _fxPnL, _flipExitUnitsRaw, _fxR, _fxRisk)
        peakEquity := math.max(peakEquity, realEquity)
    _flipExitDir := 0
    _flipExitEntry := na

// v22: shared exec guards (position flat here → no unrealized term)
_ddNowPend  = peakEquity > 0 ? (peakEquity - realEquity) / peakEquity * 100.0 : 0.0
_okPendBase = (not useDailyLossCap or dayRealizedR > dailyLossR) and (not useMaxConsecLosses or consecLosses < maxConsecLosses) and kzTradeCapOk and (not useMaxDrawdown or _ddNowPend < maxDrawdownPct) and not f_inNewsWindow()

if (pendingOpenLong or pendingFlipToLong) and _useNextBarFill
    _slPL = f_calcSL(true)
    if _okPendBase and (not useMarginBlock or f_marginPct(open, _slPL) <= marginMaxPct)  // FIX-2: gate active even when sizing off
        posDirection := 1
        posEntry := open
        posSL := _slPL
        posOrigSL := posSL
        _riskFlip = posEntry - posSL
        posTP1 := posEntry + _riskFlip * rrTP1
        posTP2 := posEntry + _riskFlip * math.max(rrTP2, rrTP1 + 0.1)
        posTP3 := posEntry + _riskFlip * math.max(rrRatio, rrTP2 + 0.1)
        posTP1Hit := false
        posTP2Hit := false
        posSizeRemaining := 1.0
        posRealizedPnL := 0.0
        posOpenBar := bar_index
        posOpenScore := bullScore
        posUnitSize := useSizing ? f_calcUnitSize(posEntry, posSL) : 0.0
        posUnitsRaw := useSizing ? f_calcRawUnits(posEntry, posSL) : 0.0
    pendingOpenLong := false
    pendingFlipToLong := false

if (pendingOpenShort or pendingFlipToShort) and _useNextBarFill
    _slPS = f_calcSL(false)
    if _okPendBase and (not useMarginBlock or f_marginPct(open, _slPS) <= marginMaxPct)  // FIX-2: gate active even when sizing off
        posDirection := -1
        posEntry := open
        posSL := _slPS
        posOrigSL := posSL
        _riskFlip = posSL - posEntry
        posTP1 := posEntry - _riskFlip * rrTP1
        posTP2 := posEntry - _riskFlip * math.max(rrTP2, rrTP1 + 0.1)
        posTP3 := posEntry - _riskFlip * math.max(rrRatio, rrTP2 + 0.1)
        posTP1Hit := false
        posTP2Hit := false
        posSizeRemaining := 1.0
        posRealizedPnL := 0.0
        posOpenBar := bar_index
        posOpenScore := bearScore
        posUnitSize := useSizing ? f_calcUnitSize(posEntry, posSL) : 0.0
        posUnitsRaw := useSizing ? f_calcRawUnits(posEntry, posSL) : 0.0
    pendingOpenShort := false
    pendingFlipToShort := false

// ---- LONG entry / flip-to-long ----
doOpenLong = false
doFlipToLong = false
if enablePositions and validBullEntry
    if posDirection == 0
        doOpenLong := true
    else if allowFlip and posDirection == -1 and bullScore >= (posOpenScore + minFlipDelta)
        doFlipToLong := true

if doFlipToLong
    if trackFlipPnL and not na(posEntry)
        currentPnL_flip = (posEntry - close) * posSizeRemaining
        totalPnL_flip = (trackRealizedPnL ? posRealizedPnL : 0.0) + currentPnL_flip
        flipPct_flip = (totalPnL_flip / posEntry) * 100
        flipColor_flip = totalPnL_flip >= 0 ? C_LBL_BULL : C_LBL_BEAR
        flipIcon_flip = totalPnL_flip >= 0 ? "✓" : "✗"
        flipText_flip = cleanMode ? " " + flipIcon_flip + " " + str.tostring(flipPct_flip, "#.##") + "% " : " 🔄 FLIP " + flipIcon_flip + " " + str.tostring(flipPct_flip, "#.##") + "% "
        flipSize_flip = cleanMode ? sz_tiny : sz_small
        f_pushExit(label.new(bar_index, close, flipText_flip, color=flipColor_flip, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=flipSize_flip))
    // v22 HIGH-3: with next-bar fill, defer the flipped-out SHORT's exit booking to next bar OPEN
    // (real fill price). Legacy "Signal close" still books at close.
    if _useNextBarFill
        if not na(posEntry)
            _flipExitDir      := posDirection
            _flipExitEntry    := posEntry
            _flipExitOrigSL   := posOrigSL
            _flipExitSize     := posSizeRemaining
            _flipExitRealized := posRealizedPnL
            _flipExitUnitsRaw := posUnitsRaw
        f_clearPositionViz()
        posDirection := 0
        pendingFlipToLong := true
        doOpenLong := false
        doFlipToLong := false
    else
        // legacy signal-close fill: book the flipped-out SHORT's realized R at close
        if not na(posEntry)
            _flipClosePnL = (posEntry - close) * posSizeRemaining - tradeCostPerUnit * posSizeRemaining
            _flipTotal = posRealizedPnL + _flipClosePnL
            _flipRisk = math.abs(posEntry - posOrigSL)
            if _flipRisk > 0
                _flipR = _flipTotal / _flipRisk
                dayRealizedR := dayRealizedR + _flipR
                consecLosses := _flipR < 0 ? consecLosses + 1 : 0
                // v23 P2: unified via f_equityStep
                realEquity := f_equityStep(realEquity, _flipClosePnL, posUnitsRaw, _flipR, _flipRisk)
                peakEquity := math.max(peakEquity, realEquity)
        f_clearPositionViz()

// v15 P1-7: Initial entry also deferred when fill mode = Next bar open
if doOpenLong and _useNextBarFill
    pendingOpenLong := true
    doOpenLong := false

// v21 FIX-3: re-check drawdown at immediate-fill execution. TP/SL exits earlier on this bar
// may have updated realEquity after drawdownOk was computed at line ~2153.
_ddNowLong = peakEquity > 0 ? (peakEquity - realEquity) / peakEquity * 100.0 : 0.0
if useMaxDrawdown and _ddNowLong >= maxDrawdownPct
    doOpenLong   := false
    doFlipToLong := false

// v22 MED-6: margin gate for immediate (signal-close) fills
if useMarginBlock and f_marginPct(close, f_calcSL(true)) > marginMaxPct  // FIX-2: gate active even when sizing off
    doOpenLong   := false
    doFlipToLong := false

if doOpenLong or doFlipToLong
    posDirection := 1
    posEntry := close
    posSL := f_calcSL(true)
    posOrigSL := posSL
    riskL_open = posEntry - posSL
    _t1 = posEntry + riskL_open * rrTP1
    _t2 = posEntry + riskL_open * math.max(rrTP2, rrTP1 + 0.1)
    _t3 = posEntry + riskL_open * math.max(rrRatio, rrTP2 + 0.1)
    posTP1 := _t1
    posTP2 := _t2
    posTP3 := _t3
    posTP1Hit := false
    posTP2Hit := false
    posSizeRemaining := 1.0
    posRealizedPnL := 0.0
    posOpenBar := bar_index
    posOpenScore := bullScore
    posUnitSize := useSizing ? f_calcUnitSize(posEntry, posSL) : 0.0
    posUnitsRaw := useSizing ? f_calcRawUnits(posEntry, posSL) : 0.0

// ---- SHORT entry / flip-to-short ----
doOpenShort = false
doFlipToShort = false
if enablePositions and validBearEntry
    if posDirection == 0
        doOpenShort := true
    else if allowFlip and posDirection == 1 and bearScore >= (posOpenScore + minFlipDelta)
        doFlipToShort := true

if doFlipToShort
    if trackFlipPnL and not na(posEntry)
        currentPnL_flip2 = (close - posEntry) * posSizeRemaining
        totalPnL_flip2 = (trackRealizedPnL ? posRealizedPnL : 0.0) + currentPnL_flip2
        flipPct_flip2 = (totalPnL_flip2 / posEntry) * 100
        flipColor_flip2 = totalPnL_flip2 >= 0 ? C_LBL_BULL : C_LBL_BEAR
        flipIcon_flip2 = totalPnL_flip2 >= 0 ? "✓" : "✗"
        flipText_flip2 = cleanMode ? " " + flipIcon_flip2 + " " + str.tostring(flipPct_flip2, "#.##") + "% " : " 🔄 FLIP " + flipIcon_flip2 + " " + str.tostring(flipPct_flip2, "#.##") + "% "
        flipSize_flip2 = cleanMode ? sz_tiny : sz_small
        f_pushExit(label.new(bar_index, close, flipText_flip2, color=flipColor_flip2, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=flipSize_flip2))
    // v22 HIGH-3: with next-bar fill, defer the flipped-out LONG's exit booking to next bar OPEN.
    if _useNextBarFill
        if not na(posEntry)
            _flipExitDir      := posDirection
            _flipExitEntry    := posEntry
            _flipExitOrigSL   := posOrigSL
            _flipExitSize     := posSizeRemaining
            _flipExitRealized := posRealizedPnL
            _flipExitUnitsRaw := posUnitsRaw
        f_clearPositionViz()
        posDirection := 0
        pendingFlipToShort := true
        doOpenShort := false
        doFlipToShort := false
    else
        // legacy signal-close fill: book the flipped-out LONG's realized R at close
        if not na(posEntry)
            _flipClosePnL2 = (close - posEntry) * posSizeRemaining - tradeCostPerUnit * posSizeRemaining
            _flipTotal2 = posRealizedPnL + _flipClosePnL2
            _flipRisk2 = math.abs(posEntry - posOrigSL)
            if _flipRisk2 > 0
                _flipR2 = _flipTotal2 / _flipRisk2
                dayRealizedR := dayRealizedR + _flipR2
                consecLosses := _flipR2 < 0 ? consecLosses + 1 : 0
                // v23 P2: unified via f_equityStep
                realEquity := f_equityStep(realEquity, _flipClosePnL2, posUnitsRaw, _flipR2, _flipRisk2)
                peakEquity := math.max(peakEquity, realEquity)
        f_clearPositionViz()

if doOpenShort and _useNextBarFill
    pendingOpenShort := true
    doOpenShort := false

// v21 FIX-3: same-bar drawdown re-check for short immediate fill
_ddNowShort = peakEquity > 0 ? (peakEquity - realEquity) / peakEquity * 100.0 : 0.0
if useMaxDrawdown and _ddNowShort >= maxDrawdownPct
    doOpenShort   := false
    doFlipToShort := false

// v22 MED-6: margin gate for immediate (signal-close) fills
if useMarginBlock and f_marginPct(close, f_calcSL(false)) > marginMaxPct  // FIX-2: gate active even when sizing off
    doOpenShort   := false
    doFlipToShort := false

if doOpenShort or doFlipToShort
    posDirection := -1
    posEntry := close
    posSL := f_calcSL(false)
    posOrigSL := posSL
    riskS_open = posSL - posEntry
    _ts1 = posEntry - riskS_open * rrTP1
    _ts2 = posEntry - riskS_open * math.max(rrTP2, rrTP1 + 0.1)
    _ts3 = posEntry - riskS_open * math.max(rrRatio, rrTP2 + 0.1)
    posTP1 := _ts1
    posTP2 := _ts2
    posTP3 := _ts3
    posTP1Hit := false
    posTP2Hit := false
    posSizeRemaining := 1.0
    posRealizedPnL := 0.0
    posOpenBar := bar_index
    posOpenScore := bearScore
    posUnitSize := useSizing ? f_calcUnitSize(posEntry, posSL) : 0.0
    posUnitsRaw := useSizing ? f_calcRawUnits(posEntry, posSL) : 0.0

// AUDIT FIX-4 (token-lean): single fill counter. Any of the 4 open paths sets posOpenBar=bar_index;
// count once here, before exits run. Replaces 8 inline increments (8 lines → 3) to fit compile limit.
if posOpenBar == bar_index and posDirection != 0
    tradesThisKZ := tradesThisKZ + 1
    tradesToday  := tradesToday + 1

// v15 P1-4: Same-bar SL/TP ambiguity resolver
//   "Tick-approx by candle open": if open is closer to TP side, TP touched first
//   "SL-first": conservative (legacy v14)
//   "TP-first": optimistic
// v22: merged long/short same-bar resolver (bodies were identical)
f_slFirst(_sl, _tp) =>
    if ambigMode == "SL-first (pessimistic)"
        true
    else if ambigMode == "TP-first (optimistic)"
        false
    else
        math.abs(open - _sl) < math.abs(open - _tp)

// LONG EXITS
if enablePositions and posDirection == 1
    slTouched_long = low <= posSL
    tp1Touched_long = useMultiTP and not posTP1Hit and high >= posTP1
    slFirstWins_long = slTouched_long and tp1Touched_long and f_slFirst(posSL, posTP1)

    if useMultiTP and not posTP1Hit and high >= posTP1 and not slFirstWins_long
        posTP1Hit := true
        realizedAtTP1 = (posTP1 - posEntry) * tp1Frac - tradeCostPerUnit * tp1Frac
        posRealizedPnL := posRealizedPnL + realizedAtTP1
        posSizeRemaining := math.max(0.0, posSizeRemaining - tp1Frac)
        // v23 P2: unified via f_equityStep (partials book only when sizing on; rMultiple/risk=0 → no-op when off)
        realEquity := f_equityStep(realEquity, realizedAtTP1, posUnitsRaw, 0.0, 0.0)
        peakEquity := math.max(peakEquity, realEquity)  // v20 FIX-2: rolling high-water mark
        f_pushExit(label.new(bar_index, posTP1, cleanMode ? " ✓1 " : " ✓ TP1 -" + str.tostring(partialTP1, "#") + "% ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=cleanMode ? sz_tiny : sz_small))
        if moveToBreakeven
            posSL := posEntry + atrVal * beBufferAtr

    tp2Touched_long = useMultiTP and posTP1Hit and not posTP2Hit and high >= posTP2
    slTouched_long_tp2 = low <= posSL
    slFirstWinsTP2_long = slTouched_long_tp2 and tp2Touched_long and f_slFirst(posSL, posTP2)
    if tp2Touched_long and not slFirstWinsTP2_long
        posTP2Hit := true
        realizedAtTP2 = (posTP2 - posEntry) * tp2Frac - tradeCostPerUnit * tp2Frac
        posRealizedPnL := posRealizedPnL + realizedAtTP2
        posSizeRemaining := math.max(0.0, posSizeRemaining - tp2Frac)
        // v23 P2: unified via f_equityStep (partials book only when sizing on; rMultiple/risk=0 → no-op when off)
        realEquity := f_equityStep(realEquity, realizedAtTP2, posUnitsRaw, 0.0, 0.0)
        peakEquity := math.max(peakEquity, realEquity)  // v20 FIX-2: rolling high-water mark
        f_pushExit(label.new(bar_index, posTP2, cleanMode ? " ✓2 " : " ✓ TP2 -" + str.tostring(partialTP2, "#") + "% ", color=color.new(C_LBL_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=cleanMode ? sz_tiny : sz_small))

    // Structure trail
    // v18 FIX-10: trail was placing SL directly on the swing low with no buffer.
    // Adding slBuffer prevents getting stopped exactly at the structural level.
    if posTP2Hit and useStructTrail and not na(intLastLo) and (intLastLo - slBuffer) > posSL and intLastLo < close
        posSL := intLastLo - slBuffer

    // v19 RISK-6: gap-through SL — if candle opens AT or BELOW SL, exit at open (worse than SL)
    _effectiveSLLong = (open <= posSL and posOpenBar != bar_index) ? open : posSL
    if low <= posSL or open <= posSL
        finalRealized = (_effectiveSLLong - posEntry) * posSizeRemaining - tradeCostPerUnit * posSizeRemaining
        totalRealized = posRealizedPnL + finalRealized
        totalPct = (totalRealized / posEntry) * 100
        _riskPerUnit = math.abs(posEntry - posOrigSL)
        if _riskPerUnit > 0
            _tradeR = totalRealized / _riskPerUnit
            dayRealizedR := dayRealizedR + _tradeR
            // v15 consec losses
            if _tradeR < 0
                consecLosses := consecLosses + 1
            else
                consecLosses := 0
        slColor = totalRealized >= 0 ? C_LBL_BULL : C_LBL_BEAR
        slIcon = totalRealized >= 0 ? "🛡️" : "🛑"
        if compactExitLabels
            f_pushExit(label.new(bar_index, _effectiveSLLong, " " + slIcon + " " + str.tostring(totalPct, "#.##") + "% ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small))
        else
            f_pushExit(label.new(bar_index, _effectiveSLLong, " " + slIcon + " SL " + str.tostring(totalPct, "#.##") + "% ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal))
        // v23 P2: unified via f_equityStep
        realEquity := f_equityStep(realEquity, totalRealized, posUnitsRaw, _riskPerUnit > 0 ? totalRealized / _riskPerUnit : 0.0, _riskPerUnit)
        peakEquity := math.max(peakEquity, realEquity)
        f_clearPositionViz()
        posDirection := 0
    else if high >= posTP3
        finalRealized = (posTP3 - posEntry) * posSizeRemaining - tradeCostPerUnit * posSizeRemaining
        totalRealized = posRealizedPnL + finalRealized
        totalPct = (totalRealized / posEntry) * 100
        _riskPerUnit = math.abs(posEntry - posOrigSL)
        if _riskPerUnit > 0
            _tradeR = totalRealized / _riskPerUnit
            dayRealizedR := dayRealizedR + _tradeR
            consecLosses := 0
        if compactExitLabels
            f_pushExit(label.new(bar_index, posTP3, " 🎯 " + str.tostring(totalPct, "#.##") + "% ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small))
        else
            f_pushExit(label.new(bar_index, posTP3, " 🎯 TP " + str.tostring(rrRatio, "#.#") + "R " + str.tostring(totalPct, "#.##") + "% ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal))
        // v23 P2: unified via f_equityStep
        realEquity := f_equityStep(realEquity, totalRealized, posUnitsRaw, _riskPerUnit > 0 ? totalRealized / _riskPerUnit : 0.0, _riskPerUnit)
        peakEquity := math.max(peakEquity, realEquity)
        f_clearPositionViz()
        posDirection := 0

// SHORT EXITS
if enablePositions and posDirection == -1
    slTouched_short = high >= posSL
    tp1Touched_short = useMultiTP and not posTP1Hit and low <= posTP1
    slFirstWins_short = slTouched_short and tp1Touched_short and f_slFirst(posSL, posTP1)

    if useMultiTP and not posTP1Hit and low <= posTP1 and not slFirstWins_short
        posTP1Hit := true
        realizedAtTP1 = (posEntry - posTP1) * tp1Frac - tradeCostPerUnit * tp1Frac
        posRealizedPnL := posRealizedPnL + realizedAtTP1
        posSizeRemaining := math.max(0.0, posSizeRemaining - tp1Frac)
        // v23 P2: unified via f_equityStep (partials book only when sizing on; rMultiple/risk=0 → no-op when off)
        realEquity := f_equityStep(realEquity, realizedAtTP1, posUnitsRaw, 0.0, 0.0)
        peakEquity := math.max(peakEquity, realEquity)  // v20 FIX-2: rolling high-water mark
        f_pushExit(label.new(bar_index, posTP1, cleanMode ? " ✓1 " : " ✓ TP1 -" + str.tostring(partialTP1, "#") + "% ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=cleanMode ? sz_tiny : sz_small))
        if moveToBreakeven
            posSL := posEntry - atrVal * beBufferAtr

    tp2Touched_short = useMultiTP and posTP1Hit and not posTP2Hit and low <= posTP2
    slTouched_short_tp2 = high >= posSL
    slFirstWinsTP2_short = slTouched_short_tp2 and tp2Touched_short and f_slFirst(posSL, posTP2)
    if tp2Touched_short and not slFirstWinsTP2_short
        posTP2Hit := true
        realizedAtTP2 = (posEntry - posTP2) * tp2Frac - tradeCostPerUnit * tp2Frac
        posRealizedPnL := posRealizedPnL + realizedAtTP2
        posSizeRemaining := math.max(0.0, posSizeRemaining - tp2Frac)
        // v23 P2: unified via f_equityStep (partials book only when sizing on; rMultiple/risk=0 → no-op when off)
        realEquity := f_equityStep(realEquity, realizedAtTP2, posUnitsRaw, 0.0, 0.0)
        peakEquity := math.max(peakEquity, realEquity)  // v20 FIX-2: rolling high-water mark
        f_pushExit(label.new(bar_index, posTP2, cleanMode ? " ✓2 " : " ✓ TP2 -" + str.tostring(partialTP2, "#") + "% ", color=color.new(C_LBL_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=cleanMode ? sz_tiny : sz_small))

    // v18 FIX-10: short-side trail also needs buffer (mirrors long-side fix above)
    if posTP2Hit and useStructTrail and not na(intLastHi) and (intLastHi + slBuffer) < posSL and intLastHi > close
        posSL := intLastHi + slBuffer

    // v19 RISK-6: gap-through SL — if candle opens AT or ABOVE SL, exit at open
    _effectiveSLShort = (open >= posSL and posOpenBar != bar_index) ? open : posSL
    if high >= posSL or open >= posSL
        finalRealized = (posEntry - _effectiveSLShort) * posSizeRemaining - tradeCostPerUnit * posSizeRemaining
        totalRealized = posRealizedPnL + finalRealized
        totalPct = (totalRealized / posEntry) * 100
        _riskPerUnitS = math.abs(posEntry - posOrigSL)
        if _riskPerUnitS > 0
            _tradeRS = totalRealized / _riskPerUnitS
            dayRealizedR := dayRealizedR + _tradeRS
            if _tradeRS < 0
                consecLosses := consecLosses + 1
            else
                consecLosses := 0
        slColor = totalRealized >= 0 ? C_LBL_BULL : C_LBL_BEAR
        slIcon = totalRealized >= 0 ? "🛡️" : "🛑"
        if compactExitLabels
            f_pushExit(label.new(bar_index, _effectiveSLShort, " " + slIcon + " " + str.tostring(totalPct, "#.##") + "% ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small))
        else
            f_pushExit(label.new(bar_index, _effectiveSLShort, " " + slIcon + " SL " + str.tostring(totalPct, "#.##") + "% ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal))
        // v23 P2: unified via f_equityStep
        realEquity := f_equityStep(realEquity, totalRealized, posUnitsRaw, _riskPerUnitS > 0 ? totalRealized / _riskPerUnitS : 0.0, _riskPerUnitS)
        peakEquity := math.max(peakEquity, realEquity)
        f_clearPositionViz()
        posDirection := 0
    else if low <= posTP3
        finalRealized = (posEntry - posTP3) * posSizeRemaining - tradeCostPerUnit * posSizeRemaining
        totalRealized = posRealizedPnL + finalRealized
        totalPct = (totalRealized / posEntry) * 100
        _riskPerUnitS = math.abs(posEntry - posOrigSL)
        if _riskPerUnitS > 0
            _tradeRS = totalRealized / _riskPerUnitS
            dayRealizedR := dayRealizedR + _tradeRS
            consecLosses := 0
        if compactExitLabels
            f_pushExit(label.new(bar_index, posTP3, " 🎯 " + str.tostring(totalPct, "#.##") + "% ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small))
        else
            f_pushExit(label.new(bar_index, posTP3, " 🎯 TP " + str.tostring(rrRatio, "#.#") + "R " + str.tostring(totalPct, "#.##") + "% ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal))
        // v23 P2: unified via f_equityStep
        realEquity := f_equityStep(realEquity, totalRealized, posUnitsRaw, _riskPerUnitS > 0 ? totalRealized / _riskPerUnitS : 0.0, _riskPerUnitS)
        peakEquity := math.max(peakEquity, realEquity)
        f_clearPositionViz()
        posDirection := 0

// v21 FIX-9: update peakEquity from unrealized P&L on every bar.
// Most prop firms track drawdown from intraday equity peak including open positions.
// Without this, peakEquity only advances on realized closes — understating true drawdown.
// FIX-3 (audit H3): advance the high-water mark in BOTH sizing and R-proxy modes, using the
// FAVORABLE intrabar extreme (high for long, low for short) so peak is not understated.
// FIX-1: sizing-mode unrealized now ×valuePerPoint, consistent with f_equityStep / f_totalPnLDollar.
if posDirection != 0 and not na(posEntry)
    _favEx = posDirection == 1 ? high : low
    if useSizing and posUnitsRaw > 0
        _unrealPnLUnits = posDirection == 1 ? (_favEx - posEntry) * posSizeRemaining : (posEntry - _favEx) * posSizeRemaining
        _unrealDollar = _unrealPnLUnits * posUnitsRaw * valuePerPoint
        peakEquity := math.max(peakEquity, realEquity + _unrealDollar)
    else if not useSizing and _guardRisk > 0
        _unrealR = (posDirection == 1 ? (_favEx - posEntry) : (posEntry - _favEx)) / _guardRisk
        peakEquity := math.max(peakEquity, realEquity * (1 + math.max(0.0, _unrealR) * riskPctEquity / 100.0))

// ═══════════════════════════════════════════════════════════════
// LIVE TRADE LINES
// ═══════════════════════════════════════════════════════════════
if showPositionLines and enablePositions and posDirection != 0 and barstate.islast
    rightX = bar_index + rightLabelOffset
    structuralChange = vizLastDir != posDirection or vizLastSL != posSL or vizLastTP1 != posTP1 or vizLastTP2 != posTP2 or vizLastTP3 != posTP3 or vizLastEntry != posEntry or vizLastTP1Hit != posTP1Hit or vizLastTP2Hit != posTP2Hit

    if structuralChange
        f_clearPositionViz()
        if shadeRRZones
            rewardBox := box.new(posOpenBar, posEntry, rightX, posTP3, bgcolor=color.new(C_BULL, 94), border_color=na)
            riskBox   := box.new(posOpenBar, posEntry, rightX, posSL,  bgcolor=color.new(C_BEAR, 94), border_color=na)

        posEntryLine := line.new(posOpenBar, posEntry, rightX, posEntry, color=C_BLUE, width=3)
        // v15 P0-3: include unit size in entry label
        _sizeStr = useSizing ? (sizingMode == "Lots (forex)" ? str.tostring(posUnitSize, "#.##") + " lot" : str.tostring(posUnitSize, "#.##") + " u") : ""
        _entryTxt = " ● ENTRY " + str.tostring(posEntry, format.mintick) + " (" + str.tostring(posSizeRemaining * 100, "#") + "%)" + (useSizing ? " | " + _sizeStr : "") + " "
        posEntryLbl  := label.new(rightX, posEntry, _entryTxt, color=C_BLUE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)

        _isBE = posTP1Hit and moveToBreakeven
        slTxt = _isBE ? " 🛡️ BE " : " 🛑 SL "
        slColor = _isBE ? C_GOLD : C_LBL_BEAR
        posSLLine := line.new(posOpenBar, posSL, rightX, posSL, color=_isBE ? C_GOLD : C_BEAR, width=3, style=line.style_dashed)
        posSLLbl  := label.new(rightX, posSL, slTxt + str.tostring(posSL, format.mintick) + " ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)

        if useMultiTP
            tp1Active = not posTP1Hit
            tp2Active = not posTP2Hit
            posTP1Line := line.new(posOpenBar, posTP1, rightX, posTP1, color=color.new(C_BULL, tp1Active ? 40 : 80), width=2, style=line.style_dotted)
            posTP1Lbl  := label.new(rightX, posTP1, (tp1Active ? " TP1 (" + str.tostring(rrTP1, "#.#") + "R) " : " ✓ TP1 ") + str.tostring(posTP1, format.mintick) + " ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
            posTP2Line := line.new(posOpenBar, posTP2, rightX, posTP2, color=color.new(C_BULL, tp2Active ? 20 : 70), width=2, style=line.style_dotted)
            posTP2Lbl  := label.new(rightX, posTP2, (tp2Active ? " TP2 (" + str.tostring(rrTP2, "#.#") + "R) " : " ✓ TP2 ") + str.tostring(posTP2, format.mintick) + " ", color=color.new(C_LBL_BULL, 15), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)

        posTP3Line := line.new(posOpenBar, posTP3, rightX, posTP3, color=C_BULL, width=3, style=line.style_dashed)
        posTP3Lbl  := label.new(rightX, posTP3, " 🎯 TP " + str.tostring(rrRatio, "#.#") + "R " + str.tostring(posTP3, format.mintick) + " ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)

        vizLastDir := posDirection
        vizLastSL := posSL
        vizLastTP1 := posTP1
        vizLastTP2 := posTP2
        vizLastTP3 := posTP3
        vizLastEntry := posEntry
        vizLastTP1Hit := posTP1Hit
        vizLastTP2Hit := posTP2Hit

    if vizLastRightX != rightX
        vizLastRightX := rightX
        if not na(posEntryLine)
            line.set_x2(posEntryLine, rightX)
            line.set_x2(posSLLine, rightX)
            line.set_x2(posTP3Line, rightX)
            label.set_x(posEntryLbl, rightX)
            label.set_x(posSLLbl, rightX)
            label.set_x(posTP3Lbl, rightX)
            if useMultiTP and not na(posTP1Line)
                line.set_x2(posTP1Line, rightX)
                line.set_x2(posTP2Line, rightX)
                label.set_x(posTP1Lbl, rightX)
                label.set_x(posTP2Lbl, rightX)
            if shadeRRZones and not na(rewardBox)
                box.set_right(rewardBox, rightX)
                box.set_right(riskBox, rightX)

    if showPnL
        totalPct = trackRealizedPnL ? f_totalPnLPct(close) : (posDirection == 1 ? (close - posEntry) / posEntry * 100 : (posEntry - close) / posEntry * 100)
        rMultiple = trackRealizedPnL ? f_rMultiple(close) : (math.abs(posEntry - posOrigSL) > 0 ? (posDirection == 1 ? (close - posEntry) : (posEntry - close)) / math.abs(posEntry - posOrigSL) : 0)
        pnlColor = totalPct >= 0 ? C_LBL_BULL : C_LBL_BEAR
        dirText_pnl = posDirection == 1 ? "LONG" : "SHORT"
        dirIcon_pnl = posDirection == 1 ? "▲" : "▼"
        // v16 H2: dollar P&L + % of equity when sizing enabled
        _pnlDollar = useSizing ? f_totalPnLDollar(close) : 0.0
        _eqPct = useSizing and accountEquity > 0 ? _pnlDollar / accountEquity * 100 : 0.0
        _dollarLine = useSizing ? "\n $" + str.tostring(_pnlDollar, "#.##") + " (" + str.tostring(_eqPct, "#.##") + "% eq) " : ""
        pnlText = " " + dirIcon_pnl + " " + dirText_pnl + " ACTIVE \n P&L: " + str.tostring(totalPct, "#.##") + "% (" + str.tostring(rMultiple, "#.##") + "R) \n Size: " + str.tostring(posSizeRemaining * 100, "#") + "% | Realized: " + str.tostring((posRealizedPnL / posEntry) * 100, "#.##") + "%" + _dollarLine

        if na(posPnLLbl)
            posPnLLbl := label.new(rightX, (posEntry + close) / 2, pnlText, color=pnlColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_large)
        else
            label.set_xy(posPnLLbl, rightX, (posEntry + close) / 2)
            label.set_text(posPnLLbl, pnlText)
            label.set_color(posPnLLbl, pnlColor)

if posDirection == 0 and vizLastDir != 0
    vizLastDir := 0
    vizLastSL := na
    vizLastTP1 := na
    vizLastTP2 := na
    vizLastTP3 := na
    vizLastEntry := na
    vizLastTP1Hit := false
    vizLastTP2Hit := false
    vizLastRightX := na

// ═══════════════════════════════════════════════════════════════
// DASHBOARD
// ═══════════════════════════════════════════════════════════════
f_tablePos(_pos) =>
    _pos == "Top Right" ? position.top_right : _pos == "Top Left" ? position.top_left : _pos == "Middle Right" ? position.middle_right : _pos == "Bottom Right" ? position.bottom_right : position.bottom_left

var table mtfTable = table.new(f_tablePos(tablePosition), 3, 15, bgcolor=C_BG_TABLE, border_width=1, border_color=C_BORDER_TBL, frame_color=C_GOLD, frame_width=2)

f_trendBadge(_t) => _t == 1 ? "▲ BULL" : _t == -1 ? "▼ BEAR" : "● NEUT"
f_trendBg(_t)    => _t == 1 ? C_LBL_BULL : _t == -1 ? C_LBL_BEAR : C_NEUTRAL

f_drawDashboard() =>
    if showMTFTable and barstate.islast
        modeText = isMinimal ? "Minimal" : isTrading ? "Trading" : "Full"
        table.cell(mtfTable, 0, 0, " ⚡ SMC MASTER PRO ", text_color=C_GOLD, bgcolor=C_BG_HEADER, text_size=size.normal)
        table.cell(mtfTable, 1, 0, "", bgcolor=C_BG_HEADER)
        table.cell(mtfTable, 2, 0, " v23 " + modeText + " ", text_color=C_TEXT_WHITE, bgcolor=C_BG_HEADER, text_size=size.small)

        table.cell(mtfTable, 0, 1, " TIMEFRAME ", text_color=C_TEXT_WHITE, bgcolor=C_BG_HEADER, text_size=size.small)
        table.cell(mtfTable, 1, 1, " PERIOD ",   text_color=C_TEXT_WHITE, bgcolor=C_BG_HEADER, text_size=size.small)
        table.cell(mtfTable, 2, 1, " TREND ",    text_color=C_TEXT_WHITE, bgcolor=C_BG_HEADER, text_size=size.small)

        table.cell(mtfTable, 0, 2, " ◉ Current ", text_color=C_TEXT_MAIN, bgcolor=C_BG_TABLE, text_size=size.normal)
        table.cell(mtfTable, 1, 2, " " + timeframe.period + " ", text_color=C_BLUE, bgcolor=C_BG_TABLE, text_size=size.normal)
        table.cell(mtfTable, 2, 2, " " + f_trendBadge(internalTrend) + " ", text_color=C_TEXT_WHITE, bgcolor=f_trendBg(internalTrend), text_size=size.normal)

        table.cell(mtfTable, 0, 3, " HTF #1 ", text_color=C_TEXT_MAIN, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)
        table.cell(mtfTable, 1, 3, " " + htf1 + " ", text_color=C_BLUE, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)
        table.cell(mtfTable, 2, 3, " " + f_trendBadge(trendHTF1) + " ", text_color=C_TEXT_WHITE, bgcolor=f_trendBg(trendHTF1), text_size=size.normal)

        table.cell(mtfTable, 0, 4, " HTF #2 ", text_color=C_TEXT_MAIN, bgcolor=C_BG_TABLE, text_size=size.normal)
        table.cell(mtfTable, 1, 4, " " + htf2 + " ", text_color=C_BLUE, bgcolor=C_BG_TABLE, text_size=size.normal)
        table.cell(mtfTable, 2, 4, " " + f_trendBadge(trendHTF2) + " ", text_color=C_TEXT_WHITE, bgcolor=f_trendBg(trendHTF2), text_size=size.normal)

        table.cell(mtfTable, 0, 5, " HTF #3 ", text_color=C_TEXT_MAIN, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)
        table.cell(mtfTable, 1, 5, " " + htf3 + " ", text_color=C_BLUE, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)
        table.cell(mtfTable, 2, 5, " " + f_trendBadge(trendHTF3) + " ", text_color=C_TEXT_WHITE, bgcolor=f_trendBg(trendHTF3), text_size=size.normal)

        biasText = mtfBullBias ? "🚀 STRONG BULL" : mtfBearBias ? "🔻 STRONG BEAR" : "⚠ MIXED"
        biasColor = mtfBullBias ? C_LBL_BULL : mtfBearBias ? C_LBL_BEAR : C_GOLD
        biasTextColor = mtfBullBias or mtfBearBias ? C_TEXT_WHITE : C_TEXT_BLACK
        table.cell(mtfTable, 0, 6, " 📊 MTF BIAS ", text_color=biasTextColor, bgcolor=biasColor, text_size=size.normal)
        table.cell(mtfTable, 1, 6, " → ", text_color=biasTextColor, bgcolor=biasColor, text_size=size.normal)
        table.cell(mtfTable, 2, 6, " " + biasText + " ", text_color=biasTextColor, bgcolor=biasColor, text_size=size.normal)

        sessText = inAsia ? "🌏 Asia" : inLondon ? "🇬🇧 London" : inNY ? "🇺🇸 NY" : "💤 Off"
        sessBg = inAsia ? C_ASIA : inLondon ? C_LONDON : inNY ? C_NY : C_NEUTRAL
        sessTxt = inLondon ? C_TEXT_BLACK : C_TEXT_WHITE
        table.cell(mtfTable, 0, 7, " 🌍 SESSION ", text_color=sessTxt, bgcolor=sessBg, text_size=size.normal)
        table.cell(mtfTable, 1, 7, " Now ", text_color=sessTxt, bgcolor=sessBg, text_size=size.normal)
        table.cell(mtfTable, 2, 7, " " + sessText + " ", text_color=sessTxt, bgcolor=sessBg, text_size=size.normal)

        kzText = inSilverBullet ? "🥈 Silver Bullet" : inLondonKZ ? "⚡ London KZ" : inNyKZ ? "⚡ NY KZ" : inNyPmKZ ? "⚡ NY PM" : "—"
        kzBg = inAnyKZ ? C_PURPLE : C_LBL_DARK
        table.cell(mtfTable, 0, 8, " ⚡ KILL ZONE ", text_color=C_TEXT_WHITE, bgcolor=kzBg, text_size=size.normal)
        table.cell(mtfTable, 1, 8, " Status ", text_color=C_TEXT_WHITE, bgcolor=kzBg, text_size=size.normal)
        table.cell(mtfTable, 2, 8, " " + kzText + " ", text_color=C_TEXT_WHITE, bgcolor=kzBg, text_size=size.normal)

        // v18 BUG-5 fix: dashboard was using (lastSH+lastSL)/2 (current rolling swings) while
        // the hard gate zoneOkBull/Bear uses _zoneMid (frozen CHoCH reference). User would see
        // "Discount" here but the gate blocked entry because the frozen mid was different.
        // Both now use _zoneMid so what you see is what blocks/allows.
        inPremium  = not na(_zoneMid) and close > _zoneMid
        inDiscount = not na(_zoneMid) and close <= _zoneMid
        zoneText = inPremium ? "▼ Premium" : inDiscount ? "▲ Discount" : "—"
        zoneBg = inPremium ? C_LBL_BEAR : inDiscount ? C_LBL_BULL : C_NEUTRAL
        table.cell(mtfTable, 0, 9, " 💎 PD Zone ", text_color=C_TEXT_MAIN, bgcolor=C_BG_TABLE, text_size=size.normal)
        table.cell(mtfTable, 1, 9, " Price ",    text_color=C_TEXT_MAIN, bgcolor=C_BG_TABLE, text_size=size.normal)
        table.cell(mtfTable, 2, 9, " " + zoneText + " ", text_color=C_TEXT_WHITE, bgcolor=zoneBg, text_size=size.normal)

        maxScore = maxScore_v15
        scoreText = "▲" + str.tostring(bullScore) + "  ▼" + str.tostring(bearScore)
        scoreBg = bullScore >= minConfluence ? C_LBL_BULL : bearScore >= minConfluence ? C_LBL_BEAR : C_PURPLE
        table.cell(mtfTable, 0, 10, " ⚡ CONFLUENCE ", text_color=C_TEXT_WHITE, bgcolor=scoreBg, text_size=size.normal)
        table.cell(mtfTable, 1, 10, " /" + str.tostring(maxScore) + " ", text_color=C_TEXT_WHITE, bgcolor=scoreBg, text_size=size.normal)
        table.cell(mtfTable, 2, 10, " " + scoreText + " ", text_color=C_TEXT_WHITE, bgcolor=scoreBg, text_size=size.normal)

        posText = posDirection == 1 ? "🟢 LONG OPEN" : posDirection == -1 ? "🔴 SHORT OPEN" : "⚪ FLAT"
        posBg = posDirection == 1 ? C_LBL_BULL : posDirection == -1 ? C_LBL_BEAR : C_LBL_DARK
        table.cell(mtfTable, 0, 11, " 📈 POSITION ", text_color=C_TEXT_WHITE, bgcolor=posBg, text_size=size.normal)
        table.cell(mtfTable, 1, 11, " Status ",    text_color=C_TEXT_WHITE, bgcolor=posBg, text_size=size.normal)
        table.cell(mtfTable, 2, 11, " " + posText + " ", text_color=C_TEXT_WHITE, bgcolor=posBg, text_size=size.normal)

        if posDirection != 0
            totalPct = trackRealizedPnL ? f_totalPnLPct(close) : (posDirection == 1 ? (close - posEntry) / posEntry * 100 : (posEntry - close) / posEntry * 100)
            rMult = trackRealizedPnL ? f_rMultiple(close) : (math.abs(posEntry - posOrigSL) > 0 ? (posDirection == 1 ? (close - posEntry) : (posEntry - close)) / math.abs(posEntry - posOrigSL) : 0)
            pnlBg = totalPct >= 0 ? C_LBL_BULL : C_LBL_BEAR
            pnlIcon = totalPct >= 0 ? "💰" : "💸"
            // v16 H2: show dollars when sizing on, else price-move %
            _pnlDollarDash = useSizing ? f_totalPnLDollar(close) : 0.0
            _pnlMidTxt = useSizing ? " $" + str.tostring(_pnlDollarDash, "#.##") + " " : " " + str.tostring(totalPct, "#.##") + "% "
            table.cell(mtfTable, 0, 12, " " + pnlIcon + " P&L ", text_color=C_TEXT_WHITE, bgcolor=pnlBg, text_size=size.normal)
            table.cell(mtfTable, 1, 12, _pnlMidTxt, text_color=C_TEXT_WHITE, bgcolor=pnlBg, text_size=size.normal)
            table.cell(mtfTable, 2, 12, " " + str.tostring(rMult, "#.##") + "R ", text_color=C_TEXT_WHITE, bgcolor=pnlBg, text_size=size.normal)
        else
            table.cell(mtfTable, 0, 12, " 💤 Awaiting ", text_color=C_TEXT_DIM, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)
            table.cell(mtfTable, 1, 12, " Signal ",     text_color=C_TEXT_DIM, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)
            table.cell(mtfTable, 2, 12, " — ",          text_color=C_TEXT_DIM, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)

        // v19: show real equity + drawdown in guards row
        guardTxt = " R: " + str.tostring(dayRealizedR, "#.##") + " | L: " + str.tostring(consecLosses) + " "
        _ddPctDash = peakEquity > 0 ? (peakEquity - realEquity) / peakEquity * 100.0 : 0.0
        guardBg = (not dailyOk) or (not consecOk) or (not drawdownOk) ? C_LBL_BEAR : C_LBL_DARK
        table.cell(mtfTable, 0, 13, " 🛡️ GUARDS ", text_color=C_TEXT_WHITE, bgcolor=guardBg, text_size=size.normal)
        table.cell(mtfTable, 1, 13, useSizing ? " $" + str.tostring(math.round(realEquity), "#") : " Risk ", text_color=C_TEXT_WHITE, bgcolor=guardBg, text_size=size.normal)
        table.cell(mtfTable, 2, 13, useSizing ? " DD: " + str.tostring(_ddPctDash, "#.#") + "% " : guardTxt, text_color=C_TEXT_WHITE, bgcolor=guardBg, text_size=size.normal)
f_drawDashboard()

// MED-fix: chart warning when account-currency conversion could not resolve (sizing assumes 1.0).
if barstate.islast and _fxConvUnresolved
    f_pushMisc(label.new(bar_index, high, " ⚠ FX conv unresolved (" + _quoteCur + "→" + _acctCur + ") — sizing assumes 1.0 ", color=color.new(C_BEAR, 10), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar))

// ═══════════════════════════════════════════════════════════════
// ALERTS
// ═══════════════════════════════════════════════════════════════
alertBullCond = alertOnlyConfluence ? validBullEntry : bullTrigger
alertBearCond = alertOnlyConfluence ? validBearEntry : bearTrigger

alertcondition(alertBullCond, "LONG Signal",  "SMC LONG entry — check chart for details")
alertcondition(alertBearCond, "SHORT Signal", "SMC SHORT entry — check chart for details")
alertcondition(bosBull,   "BOS Bullish",     "Bullish BOS confirmed")
alertcondition(bosBear,   "BOS Bearish",     "Bearish BOS confirmed")
alertcondition(chochBull, "CHoCH Bullish",   "Bullish CHoCH — trend reversal up")
alertcondition(chochBear, "CHoCH Bearish",   "Bearish CHoCH — trend reversal down")
alertcondition(bullSweep, "Bull Sweep",      "Liquidity sweep below — bullish")
alertcondition(bearSweep, "Bear Sweep",      "Liquidity sweep above — bearish")
alertcondition(inSilverBullet and not inSilverBullet[1], "Silver Bullet", "Silver Bullet window opened")
alertcondition(mtfBullBias and not mtfBullBias[1], "MTF Bull Aligned", "All HTFs flipped bullish")
alertcondition(mtfBearBias and not mtfBearBias[1], "MTF Bear Aligned", "All HTFs flipped bearish")
alertcondition(priceInHTFBullFVG and not priceInHTFBullFVG[1], "HTF Bull POI Tap", "Price entered HTF bullish FVG")
alertcondition(priceInHTFBearFVG and not priceInHTFBearFVG[1], "HTF Bear POI Tap", "Price entered HTF bearish FVG")
alertcondition(amdLondonSweepHi, "AMD Bear Setup", "London swept Asia high — bearish AMD")
alertcondition(amdLondonSweepLo, "AMD Bull Setup", "London swept Asia low — bullish AMD")
alertcondition(turtleSoupBull, "Turtle Soup Bull", "False break below N-bar low")
alertcondition(turtleSoupBear, "Turtle Soup Bear", "False break above N-bar high")
// v23 ISSUE-4: text corrected to match v18 reversal logic (1701-1702). Prior text described
// a continuation, contradicting the implemented stop-run-and-reverse behaviour.
alertcondition(bullLiqGrab, "Bull Liq Grab", "SSL grabbed below, close back above — bullish reversal")
alertcondition(bearLiqGrab, "Bear Liq Grab", "BSL grabbed above, close back below — bearish reversal")
alertcondition(smtBull,         "SMT Bull Divergence",  "SMT: primary lower low, correlated higher low — reversal up")
alertcondition(smtBear,         "SMT Bear Divergence",  "SMT: primary higher high, correlated lower high — reversal down")
// AUDIT FIX-4: titles say "Minor Swing Sweep" (not "IDM") — this is a failed-break sweep, NOT
// canonical ICT inducement. Internal var names idmBull/idmBear kept for compatibility.
alertcondition(idmBull,         "Minor Swing Sweep Bear", "Minor-swing sweep: downtrend high swept, bearish close — continuation down (NOT full inducement)")
alertcondition(idmBear,         "Minor Swing Sweep Bull", "Minor-swing sweep: uptrend low swept, bullish close — continuation up (NOT full inducement)")
alertcondition(cisdBull,        "CISD Bull",            "Change in state of delivery — bullish")
alertcondition(cisdBear,        "CISD Bear",            "Change in state of delivery — bearish")
alertcondition(judasBullSignal, "Judas Swing Bull",     "Judas: false London push down, real direction up")
alertcondition(judasBearSignal, "Judas Swing Bear",     "Judas: false London push up, real direction down")
alertcondition(not drawdownOk,  "Max Drawdown Hit",     "Equity drawdown limit reached — trading halted")
