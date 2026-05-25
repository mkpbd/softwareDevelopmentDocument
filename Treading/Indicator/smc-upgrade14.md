//@version=5
indicator("SMC Master Pro v14 | Pro Audit Applied", shorttitle="SMC Pro v14", overlay=true, max_boxes_count=500, max_lines_count=500, max_labels_count=500, max_bars_back=5000)

// ═══════════════════════════════════════════════════════════════
// v14 — Pro Audit Fixes (built on v13)
//   B1  HTF trend no live-bar fallback (kills HTF rollover repaint)
//   B2  Zone gate uses FROZEN PD reference (consistent with displayed PD)
//   B3  Double Top/Bottom tolerance now ATR-relative
//   B5  Pin bar requires min body (kills doji false pins)
//   B7  POI confluence OR-collapsed (no double-weighting OB+FVG same zone)
//   B8  Internal MSS dual-pivot trigger (cuts entry lag from swingLen→intLen)
//   B9  News window blacklist input
//   B10 Breakeven default OFF; structure trail after TP2
//   B11 TP3 cascade sanity guard
//   B12 No phantom FVG labels
//   B13 OTC auto-disables KZ-gate / AMD / sessions
//   B14 Displacement candle mandatory at trigger
//   B15 Daily loss cutoff (R-based) + max trades per KZ
// v13 fixes preserved.
// ═══════════════════════════════════════════════════════════════

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
showMTFTable = input.bool(true, "Show Dashboard", group=grpMTF)
tablePosition = input.string("Top Right", "Position", options=["Top Right", "Top Left", "Middle Right", "Bottom Right", "Bottom Left"], group=grpMTF)

grpStruct = "📊 Market Structure"
swingLen = input.int(8, "Swing Length (HTF bias)", minval=3, maxval=50, group=grpStruct, tooltip="Used for HH/HL/LH/LL swing structure")
intSwingLen = input.int(3, "Internal Swing Length (entry MSS)", minval=2, maxval=10, group=grpStruct, tooltip="v14 B8: shorter pivots used to detect MSS for entries — cuts lag")
useInternalMSS = input.bool(true, "Require internal MSS at entry", group=grpStruct, tooltip="v14 B8: entry must coincide with internal-structure shift in trade direction")
showBOS_user = input.bool(true, "Show BOS", group=grpStruct)
showCHoCH_user = input.bool(true, "Show CHoCH", group=grpStruct)
showSwings_user = input.bool(false, "Show Swing Labels", group=grpStruct)
maxStructLabels = input.int(3, "Max BOS/CHoCH labels", minval=1, maxval=10, group=grpStruct)
useWickForBOS = input.bool(false, "Use wick (not close) for BOS", group=grpStruct, tooltip="Strict ICT uses close; wick = more aggressive")
firstShiftAsCHoCH = input.bool(true, "Treat first directional shift as CHoCH", group=grpStruct, tooltip="If true, the first shift from neutral is labeled CHoCH instead of INIT")

grpTrend = "📈 Trendlines"
showTrendlines_user = input.bool(true, "Show Trendlines", group=grpTrend)
trendlineExtend = input.bool(false, "Extend forward", group=grpTrend)
maxTrendlines = input.int(2, "Max active per side", minval=1, maxval=4, group=grpTrend)
breakTrendline_user = input.bool(true, "Mark TL break (once only)", group=grpTrend)
trendlineMaxAgeBars = input.int(200, "TL max age before retiring", minval=20, maxval=1000, group=grpTrend, tooltip="Stop monitoring trendlines older than this")
trendlineWidth = input.int(3, "Trendline width", minval=1, maxval=5, group=grpTrend, tooltip="Visual thickness")
trendlineStyle = input.string("Solid", "Trendline style", options=["Solid", "Dashed", "Dotted"], group=grpTrend)
trendlineGlow = input.bool(true, "Glow effect (subtle halo)", group=grpTrend, tooltip="Adds a soft halo behind trendlines for better visibility")
tlBreakMarker = input.string("Tick mark", "TL break marker", options=["Full label", "Tick mark", "Hidden"], group=grpTrend, tooltip="Reduce clutter when trendlines break")

grpCleanUI = "✨ Clean UI Mode"
cleanMode = input.bool(false, "Enable clean UI (reduces visual clutter)", group=grpCleanUI, tooltip="Hides redundant labels, shortens extension lines, dims secondary markers")
shortExtensionLines = input.int(5, "Liquidity label extension (bars)", minval=2, maxval=20, group=grpCleanUI, tooltip="Shorter = less visual drag across chart")
dedupeSweepLabels = input.bool(true, "One sweep label per swing", group=grpCleanUI, tooltip="Prevents stacked SWEEP labels on consecutive bars")
sweepMarkerStyle = input.string("Compact triangle", "Sweep marker style", options=["Full label", "Compact triangle", "Diamond only"], group=grpCleanUI)

grpFibR = "📐 Fibonacci"
showFibRet_user = input.bool(true, "Show Fib Retracement", group=grpFibR)
showAllFibs = input.bool(false, "Show all levels", group=grpFibR)

grpOB = "🟦 Order Block"
showOB_user = input.bool(true, "Show OBs", group=grpOB)
obMaxBoxes = input.int(4, "Max Active OBs", minval=1, maxval=10, group=grpOB)
obStrength = input.float(0.5, "OB Min Body/Range Ratio", minval=0.3, maxval=0.8, step=0.05, group=grpOB)
obImpulseATR = input.float(1.0, "OB Min Impulse (×ATR)", minval=0.2, maxval=5.0, step=0.1, group=grpOB, tooltip="Impulse candle must be at least this many ATRs in range")
obLookback = input.int(3, "OB lookback bars", minval=1, maxval=8, group=grpOB, tooltip="Scan window for the last opposite-color candle before the impulse — that's the OB")
hideMitigatedLabels = input.bool(true, "Hide mitigated labels", group=grpOB)
obOpacity = input.int(75, "OB Opacity %", minval=50, maxval=95, group=grpOB)
// v13 M4: OB mitigation mode (was hardcoded any-touch)
obMitigationMode = input.string("50% fill", "OB mitigation mode", options=["Touch", "50% fill", "Full fill"], group=grpOB, tooltip="50% (ICT default) prevents single-wick mitigation.")
// v13 M5: Strict ICT — OB only valid if its impulse created BOS/CHoCH
obRequireBOS = input.bool(true, "Strict: require BOS/CHoCH on OB impulse", group=grpOB, tooltip="True ICT: OB is the candle whose impulse breaks structure. When ON, OB is only drawn if the impulse bar fires bosBull/bosBear/chochBull/chochBear.")
// v12 #9: Mitigation Block distinction
distinguishMB = input.bool(true, "Tag MB (post-CHoCH) vs OB", group=grpOB, tooltip="Order Blocks that form after a CHoCH (trend reversal) are labeled MB. They tend to be stronger.")
// v12 #8: Breaker Blocks
grpBreaker = "🟥 Breaker Blocks"
showBreaker = input.bool(true, "Show Breaker Blocks", group=grpBreaker, tooltip="When a mitigated OB is closed through, the zone inverts into resistance/support — that's a Breaker Block.")
breakerOpacity = input.int(70, "Breaker Opacity %", minval=50, maxval=95, group=grpBreaker)
breakerMaxAge = input.int(150, "Breaker max age (bars)", minval=20, maxval=500, group=grpBreaker)

grpFVG = "📐 FVG"
showFVG_user = input.bool(true, "Show FVG", group=grpFVG)
showBPR_user = input.bool(false, "Show BPR", group=grpFVG)
fvgMinSizeMode = input.string("ATR fraction", "Min FVG size mode", options=["ATR fraction", "Percent"], group=grpFVG, tooltip="v13 default: ATR fraction (instrument-agnostic). Percent kept for back-compat.")
fvgMinSizeAtr = input.float(0.10, "Min FVG size (× ATR)", minval=0.0, maxval=2.0, step=0.05, group=grpFVG, tooltip="Gap must be at least this many ATRs wide. 0.10 = 10% of ATR.")
fvgMinSize = input.float(0.05, "Min FVG Size % (legacy)", minval=0.0, step=0.05, group=grpFVG)
maxFVGs = input.int(4, "Max active FVGs", minval=1, maxval=10, group=grpFVG)
showFVGLabels = input.bool(true, "Show FVG labels", group=grpFVG)
trackFVGMitigation = input.bool(true, "Track FVG mitigation", group=grpFVG)
fvgMitigationMode = input.string("50% fill", "Mitigation threshold", options=["Touch", "50% fill", "Full fill"], group=grpFVG, tooltip="ICT default is 50% — partial fill marks consequent encroachment")
// v12 #17: FVG displacement quality filter
fvgDisplacementATR = input.float(1.5, "Min displacement (× ATR)", minval=0.3, maxval=5.0, step=0.1, group=grpFVG, tooltip="The middle (impulse) candle must have range ≥ this many ATRs. Filters trivial gaps.")
// v12 #10: Inversion FVG
showInversionFVG = input.bool(true, "Show Inversion FVGs (iFVG)", group=grpFVG, tooltip="When a FVG fully fills and price closes through it, the zone flips into opposite-side support/resistance.")

grpPD = "💎 Premium/Discount"
showPD_user = input.bool(true, "PD Zones", group=grpPD)

grpLiq = "💧 Liquidity"
showLiq_user = input.bool(true, "Liquidity Levels", group=grpLiq)
liqToleranceMode = input.string("ATR fraction", "Equal H/L mode", options=["ATR fraction", "Percent"], group=grpLiq, tooltip="ATR-relative auto-scales across forex/stocks/crypto")
liqTolerance = input.float(0.08, "Equal H/L %", minval=0.01, step=0.01, group=grpLiq, tooltip="Used in Percent mode")
liqToleranceAtr = input.float(0.3, "Equal H/L (× ATR)", minval=0.05, maxval=2.0, step=0.05, group=grpLiq, tooltip="Used in ATR mode. 0.3 = within 30% of ATR")
detectSweeps = input.bool(true, "Detect liquidity sweeps", group=grpLiq, tooltip="Wick takes liquidity then closes back inside")
// v12 #25: Liquidity grab (purge + continue) — distinct from sweep (purge + reverse)
detectLiqGrabs = input.bool(true, "Detect liquidity grabs (purge + continue)", group=grpLiq, tooltip="Price breaks through and stays through — bearish signal when bullish liquidity is grabbed and price continues lower.")
sweepMinRange = input.float(0.5, "Sweep min swing significance (× ATR)", minval=0.1, maxval=5.0, step=0.1, group=grpLiq, tooltip="Distance from swept swing to opposite swing must be at least this many ATRs — filters trivial micro-sweeps")

grpPattern = "🔷 Chart Patterns"
showPatterns_user = input.bool(true, "Patterns", group=grpPattern)
showPinBar = input.bool(true, "Pin Bar / Hammer", group=grpPattern)
showDoubleTB = input.bool(true, "Double Top/Bottom", group=grpPattern)
pinBarRatio = input.float(1.8, "Pin Ratio", minval=1.2, step=0.1, group=grpPattern)
// v12 #15: Turtle Soup
showTurtleSoup = input.bool(true, "Turtle Soup (N-bar false break)", group=grpPattern, tooltip="Detects when price wicks above the N-bar high (or below N-bar low) but closes back inside. Classic stop-run signal.")
turtleSoupLookback = input.int(20, "Turtle Soup lookback (bars)", minval=5, maxval=100, group=grpPattern)

// v12 #11: HTF POI Confluence
grpHTFPOI = "🔭 HTF POI Confluence"
useHTFPOI = input.bool(true, "Detect HTF POI (FVG/OB) taps", group=grpHTFPOI, tooltip="Adds high-weight confluence when LTF price is inside a HTF FVG or order block zone.")
htfPOITF = input.timeframe("240", "HTF for POI", group=grpHTFPOI)
htfPOIWeight = input.int(3, "HTF POI confluence weight", minval=1, maxval=5, group=grpHTFPOI)
// v12.1: HTF Order Block — was promised in v12 UI but never implemented
useHTFOB = input.bool(true, "Include HTF Order Blocks", group=grpHTFPOI, tooltip="In addition to HTF FVGs, detect strong HTF impulse candles as HTF OB zones.")

// v12 #12: Daily / Weekly / Midnight Opens
grpOpens = "🕛 Reference Opens"
showDailyOpen = input.bool(true, "Daily Open (00:00 server)", group=grpOpens)
showWeeklyOpen = input.bool(true, "Weekly Open (Mon 00:00 server)", group=grpOpens)
showMidnightOpen = input.bool(true, "NY Midnight Open (00:00 NY)", group=grpOpens, tooltip="ICT-key intraday reference — Tuesday tends to set the weekly bias relative to it.")
openLineWidth = input.int(2, "Open line width", minval=1, maxval=4, group=grpOpens)
openLineExtend = input.bool(true, "Extend right", group=grpOpens)

// v12.1: Previous Day / Week High & Low — fundamental ICT reference levels
grpPrev = "📍 Previous Day/Week Levels"
showPDH = input.bool(true, "Show PDH / PDL (yesterday's H/L)", group=grpPrev, tooltip="Most intraday price action happens between these. Often gets swept.")
showPWH = input.bool(true, "Show PWH / PWL (last week's H/L)", group=grpPrev)
prevLineWidth = input.int(1, "Line width", minval=1, maxval=3, group=grpPrev)
prevLineExtend = input.bool(true, "Extend right", group=grpPrev)

// v12.1: Session H/L persistence — keep Asia/London/NY range levels visible after session closes
grpSessLevels = "🏷️ Session Range Levels"
showSessionLevels = input.bool(true, "Persist session H/L as levels", group=grpSessLevels, tooltip="Asia high/low, London high/low, NY high/low — remain on chart until next session.")
sessLevelWidth = input.int(1, "Line width", minval=1, maxval=3, group=grpSessLevels)

// v12 #13: OTE Zone
grpOTE = "📐 OTE Zone"
showOTEZone = input.bool(true, "Shade 0.618–0.786 OTE zone", group=grpOTE)
oteOpacity = input.int(90, "OTE opacity %", minval=80, maxval=99, group=grpOTE)

// v12 #14: AMD / Power of 3
grpAMD = "🌀 AMD / Power of 3"
detectAMD = input.bool(true, "Detect AMD setups", group=grpAMD, tooltip="Asia accumulation → London manipulation (sweep) → NY distribution. Marks when London wicks Asia high/low and reverses.")
amdMinRangeATR = input.float(0.5, "Min Asia range (× ATR)", minval=0.1, maxval=5.0, step=0.1, group=grpAMD)

// v12 #16: Volume Confirmation
grpVol = "📊 Volume Confirmation"
useVolConfirm = input.bool(true, "Volume confluence (+1)", group=grpVol, tooltip="Adds +1 to confluence when current volume is significantly above average.")
volMaLen = input.int(20, "Volume MA length", minval=5, maxval=100, group=grpVol)
volMult = input.float(1.5, "Volume multiplier", minval=1.0, maxval=5.0, step=0.1, group=grpVol, tooltip="Volume must exceed (MA × multiplier) to qualify")

grpSess = "🌍 Sessions"
showSessions_user = input.bool(true, "Session Boxes", group=grpSess)
asiaSession = input.session("2000-0000", "Asia", group=grpSess)
londonSession = input.session("0200-0500", "London", group=grpSess)
nySession = input.session("0700-1000", "NY", group=grpSess)
sessionOpacity = input.int(93, "Session Opacity", minval=85, maxval=99, group=grpSess)
sessionTimezone = input.string("America/New_York", "Timezone", options=["America/New_York", "Europe/London", "Asia/Tokyo", "UTC"], group=grpSess)

grpKZ = "⚡ Kill Zones"
showKillzones_user = input.bool(true, "Show KZ background", group=grpKZ)
londonKZ = input.session("0200-0500", "London KZ", group=grpKZ)
nyKZ = input.session("0830-1100", "NY AM KZ", group=grpKZ)
silverBulletKZ = input.session("1000-1100", "Silver Bullet", group=grpKZ)
nyPmKZ = input.session("1330-1600", "NY PM", group=grpKZ)
kzOpacity = input.int(92, "KZ Opacity", minval=85, maxval=98, group=grpKZ)

grpSig = "🕯️ Entry Signals"
showEngulf = input.bool(true, "Show Signals", group=grpSig)
requireConfluence = input.bool(true, "Require Confluence", group=grpSig)
minConfluence = input.int(8, "Min Confluence (weighted)", minval=1, maxval=22, group=grpSig, tooltip="v12 max ≈ 22 (with HTF POI weight 3). Default 8 is a good 'A-grade only' floor. Lower to 5–6 for more signals.")
killzoneBoostConfluence = input.bool(true, "+1 in KZ", group=grpSig)
signalCooldownBars = input.int(12, "Signal Cooldown bars", minval=0, maxval=100, group=grpSig)
// v11.1 Fix #7: bar-close gate
waitForBarClose = input.bool(true, "Signals only on confirmed bar close (no repaint)", group=grpSig, tooltip="Recommended ON. If OFF, signals may appear/disappear during the forming bar.")
useGlobalCooldown = input.bool(true, "Global cooldown (both directions)", group=grpSig, tooltip="Prevents whipsaw signals immediately after opposing entry")
includePinBarSignals = input.bool(true, "Pin bars also fire signals", group=grpSig)
includeSweepSignals = input.bool(true, "Liquidity sweeps fire signals", group=grpSig)
signalLabelSize = input.string("Small", "Signal label size", options=["Tiny", "Small", "Normal", "Large"], group=grpSig, tooltip="LONG/SHORT badge size — Small recommended for clean UI")
signalLabelStyle = input.string("Compact", "Signal label style", options=["Compact", "Full text"], group=grpSig, tooltip="Compact = ▲/▼ arrow only; Full = ▲ LONG / ▼ SHORT")

grpPos = "📈 Position"
enablePositions = input.bool(true, "Track Positions", group=grpPos)
showPositionLines = input.bool(true, "Live Trade Lines", group=grpPos)
showPnL = input.bool(true, "Live P&L", group=grpPos)
allowFlip = input.bool(true, "Allow Flip", group=grpPos)
minFlipDelta = input.int(2, "Min flip advantage", minval=1, maxval=5, group=grpPos)
killzoneOnly = input.bool(false, "Only enter in KZ", group=grpPos)
compactExitLabels = input.bool(true, "Compact exit markers", group=grpPos)
rightLabelOffset = input.int(30, "Right label offset", minval=15, maxval=60, group=grpPos)
trackFlipPnL = input.bool(true, "Record P&L on flip", group=grpPos)
trackRealizedPnL = input.bool(true, "Include realized P&L from partials", group=grpPos, tooltip="When SL/TP hits, include partial profits already taken")
// v12 #7: Flip slippage simulation — fill new position at NEXT bar open instead of current close
flipUseNextBarOpen = input.bool(false, "Simulate flip slippage (fill at next bar open)", group=grpPos, tooltip="Backtest realism: flips fill at the next bar's open, not the signal bar's close. Won't repaint live.")

grpRR = "💰 Risk"
slMode = input.string("Swing-based", "SL Method", options=["Swing-based", "Previous candle", "ATR-based"], group=grpRR)
atrLen = input.int(14, "ATR Length", minval=5, group=grpRR)
atrMult = input.float(1.5, "ATR SL Multiplier", minval=0.5, step=0.1, group=grpRR)
rrRatio = input.float(3.0, "Target R:R", minval=1.0, step=0.5, group=grpRR)
// v12 #29: TP1/TP2 R-ratios now configurable (previously hardcoded 1R/2R)
rrTP1 = input.float(1.0, "TP1 R-ratio", minval=0.5, maxval=10.0, step=0.5, group=grpRR)
rrTP2 = input.float(2.0, "TP2 R-ratio", minval=0.5, maxval=10.0, step=0.5, group=grpRR)
useMultiTP = input.bool(true, "Multi-TP with partial closure", group=grpRR)
partialTP1 = input.float(50.0, "TP1 partial close %", minval=0, maxval=100, step=5, group=grpRR)
partialTP2 = input.float(30.0, "TP2 partial close %", minval=0, maxval=100, step=5, group=grpRR)
// v11.1 Fix #4: Convert percentages to fractions ONCE. All internal math uses fractions.
tp1Frac = partialTP1 / 100.0
tp2Frac = partialTP2 / 100.0
moveToBreakeven = input.bool(false, "Move SL to BE after TP1", group=grpRR, tooltip="v14 B10: default OFF — BE choke winners. Use struct trail instead.")
useStructTrail = input.bool(true, "Structure trail SL after TP2", group=grpRR, tooltip="v14 B10: after TP2, trail SL to last opposite internal swing")
shadeRRZones = input.bool(true, "Shade R:R zones", group=grpRR)
slBufferMode = input.string("ATR fraction", "SL Buffer mode", options=["ATR fraction", "Pips (forex only)"], group=grpRR, tooltip="ATR fraction = instrument-agnostic. Pips assumes forex 0.0001 = 1 pip.")
slBufferAtrFrac = input.float(0.1, "SL Buffer (× ATR)", minval=0.0, maxval=2.0, step=0.05, group=grpRR, tooltip="0.1 = 10% of ATR. Recommended 0.1-0.3")
slBufferPips = input.float(2.0, "SL Buffer pips (forex)", minval=0.0, step=0.5, group=grpRR)

grpAlert = "🔔 Alerts"
alertOnlyConfluence = input.bool(true, "Alert only on Confluence", group=grpAlert)
includeAlertDetails = input.bool(true, "Include price/R:R in alerts", group=grpAlert)

// v13 NEW — Range/Chop filter
grpRange = "🌊 Range Filter (v13)"
useRangeFilter = input.bool(true, "Suppress signals in chop", group=grpRange, tooltip="Blocks signals when ADX is low and price action is range-bound.")
adxLenRng = input.int(14, "ADX length", minval=5, maxval=50, group=grpRange)
adxMinRng = input.float(18.0, "Min ADX (below = chop)", minval=10.0, maxval=40.0, step=1.0, group=grpRange)
atrPctlLen = input.int(100, "ATR percentile lookback", minval=20, maxval=500, group=grpRange)
atrPctlMin = input.float(25.0, "Min ATR percentile %", minval=5.0, maxval=80.0, step=5.0, group=grpRange, tooltip="ATR must be above this percentile of recent ATR. Filters dead sessions.")

// v13 NEW — Mandatory hard-filter gate
grpHardGate = "🚦 Mandatory Hard Gate (v13)"
useHardGate = input.bool(true, "Enforce mandatory filters", group=grpHardGate, tooltip="Beyond confluence score, require: HTF align + correct zone + KZ + recent liquidity sweep + healthy volatility.")
hgRequireHTF = input.bool(true, "Require HTF bias align (≥2 of 3)", group=grpHardGate)
hgRequireZone = input.bool(true, "Require correct PD zone", group=grpHardGate, tooltip="Long only in Discount, Short only in Premium")
hgRequireKZ = input.bool(false, "Require Kill Zone", group=grpHardGate)
hgRequireLiq = input.bool(true, "Require recent liquidity sweep/grab/AMD", group=grpHardGate)
hgLiqLookback = input.int(8, "Liq sweep lookback bars", minval=1, maxval=50, group=grpHardGate)
hgRequireVol = input.bool(true, "Require healthy volatility (not chop)", group=grpHardGate)

// v13 NEW — BE buffer
beBufferAtr = input.float(0.15, "Breakeven buffer (× ATR)", minval=0.0, maxval=1.0, step=0.05, group=grpRR, tooltip="After TP1, SL moves to entry + this buffer instead of exact entry. Prevents BE stop-out on minor wicks.")

// v13 NEW — Auto-detect forex/OTC for volume filter (V1)
_isForexOrOTC = syminfo.type == "forex" or str.contains(str.lower(syminfo.ticker), "otc")
_isOTC        = str.contains(str.lower(syminfo.ticker), "otc")

// v14 B14 — Displacement filter at trigger
grpDisp = "💥 Displacement (v14)"
useDisplacement = input.bool(true, "Require displacement body at trigger", group=grpDisp, tooltip="Trigger candle body must be at least N×ATR")
dispBodyAtr = input.float(0.5, "Min body (× ATR)", minval=0.1, maxval=3.0, step=0.05, group=grpDisp)

// v14 B9 — News window blacklist
grpNews = "📰 News Blocker (v14)"
useNewsBlocker = input.bool(false, "Enable news window blocker", group=grpNews)
newsWindows = input.string("0830,1000,1400", "News HHMM list (NY)", group=grpNews, tooltip="Comma list of HHMM in NY time. Blocks ±N minutes around each.")
newsBufferMin = input.int(15, "Buffer minutes ±", minval=1, maxval=60, group=grpNews)

// v14 B15 — Daily loss cutoff + max trades per KZ
grpGuard = "🛡️ Risk Guards (v14)"
useDailyLossCap = input.bool(true, "Daily loss cap", group=grpGuard, tooltip="Block new entries after N R lost today")
dailyLossR = input.float(-2.0, "Daily stop (R)", maxval=-0.5, step=0.5, group=grpGuard)
useMaxTradesKZ = input.bool(true, "Max trades per kill zone", group=grpGuard)
maxTradesPerKZ = input.int(2, "Max trades per KZ", minval=1, maxval=10, group=grpGuard)

// ═══════════════════════════════════════════════════════════════
// PRESET OVERRIDES
// ═══════════════════════════════════════════════════════════════
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

// Theme
C_TEXT_MAIN    = darkMode ? C_TEXT_LIGHT : C_TEXT_DARK
C_BG_TABLE     = darkMode ? #0D1117 : #FFFFFF
C_BG_TABLE_ALT = darkMode ? #161B22 : #F6F8FA
C_BG_HEADER    = darkMode ? #21262D : #1A1F2E
C_BORDER_TBL   = darkMode ? #30363D : #D1D5DB

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

if showSessions
    if inAsia and not inAsia[1]
        asiaHi := high
        asiaLo := low
        asiaBox := box.new(bar_index, asiaHi, bar_index, asiaLo, bgcolor=color.new(C_ASIA, sessionOpacity), border_color=color.new(C_ASIA, 70), border_width=1)
        label.new(bar_index, high, " 🌏 ASIA ", color=C_ASIA, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small)
    if inAsia and not na(asiaBox)
        asiaHi := math.max(asiaHi, high)
        asiaLo := math.min(asiaLo, low)
        box.set_right(asiaBox, bar_index)
        box.set_top(asiaBox, asiaHi)
        box.set_bottom(asiaBox, asiaLo)

    if inLondon and not inLondon[1]
        londonHi := high
        londonLo := low
        londonBox := box.new(bar_index, londonHi, bar_index, londonLo, bgcolor=color.new(C_LONDON, sessionOpacity), border_color=color.new(C_LONDON, 70), border_width=1)
        label.new(bar_index, high, " 🇬🇧 LONDON ", color=C_LONDON, textcolor=C_TEXT_BLACK, style=label.style_label_down, size=sz_small)
    if inLondon and not na(londonBox)
        londonHi := math.max(londonHi, high)
        londonLo := math.min(londonLo, low)
        box.set_right(londonBox, bar_index)
        box.set_top(londonBox, londonHi)
        box.set_bottom(londonBox, londonLo)

    if inNY and not inNY[1]
        nyHi := high
        nyLo := low
        nyBox := box.new(bar_index, nyHi, bar_index, nyLo, bgcolor=color.new(C_NY, sessionOpacity), border_color=color.new(C_NY, 70), border_width=1)
        label.new(bar_index, high, " 🇺🇸 NY ", color=C_NY, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small)
    if inNY and not na(nyBox)
        nyHi := math.max(nyHi, high)
        nyLo := math.min(nyLo, low)
        box.set_right(nyBox, bar_index)
        box.set_top(nyBox, nyHi)
        box.set_bottom(nyBox, nyLo)

bgcolor(showKillzones and inLondonKZ     ? color.new(C_LONDON, kzOpacity)      : na, title="London KZ BG")
bgcolor(showKillzones and inNyKZ         ? color.new(C_NY, kzOpacity)          : na, title="NY AM KZ BG")
bgcolor(showKillzones and inSilverBullet ? color.new(C_PURPLE, kzOpacity - 3)  : na, title="Silver Bullet BG")
bgcolor(showKillzones and inNyPmKZ       ? color.new(C_PINK, kzOpacity)        : na, title="NY PM KZ BG")

if showKillzones and inLondonKZ and not inLondonKZ[1]
    label.new(bar_index, high, " ⚡ LONDON KZ ", color=C_LONDON, textcolor=C_TEXT_BLACK, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
if showKillzones and inNyKZ and not inNyKZ[1]
    label.new(bar_index, high, " ⚡ NY KZ ", color=C_NY, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
if showKillzones and inSilverBullet and not inSilverBullet[1]
    label.new(bar_index, high, " 🥈 SILVER BULLET ", color=C_PURPLE, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)

// ═══════════════════════════════════════════════════════════════
// HOISTED HELPERS — declared before first use in session levels, PDH/PDL, D/W/M opens
// ═══════════════════════════════════════════════════════════════
_clampBar(_b) => not na(_b) and (bar_index - _b) > 4900 ? bar_index - 4900 : _b

// v12.1 BUG#4: Bounded label/line arrays for misc one-shot markers
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

// ═══════════════════════════════════════════════════════════════
// SESSION H/L PERSISTENCE — v12.1 Tier 2
// ═══════════════════════════════════════════════════════════════
// Asia/London/NY high & low remain as horizontal levels after the session closes,
// until the next session of the same type starts and overwrites them.
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

// Snapshot session H/L when the session JUST ended
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

// Draw on last bar
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
// PREVIOUS DAY / WEEK HIGH & LOW — v12.1 Tier 2
// ═══════════════════════════════════════════════════════════════
// PDH/PDL: previous COMPLETED daily bar's high/low (request with [1] = closed value)
// PWH/PWL: previous COMPLETED weekly bar's high/low
[_pdh, _pdl] = request.security(syminfo.tickerid, "D", [high[1], low[1]], lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)
[_pwh, _pwl] = request.security(syminfo.tickerid, "W", [high[1], low[1]], lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)

var line  pdhLine = na, var label pdhLbl = na
var line  pdlLine = na, var label pdlLbl = na
var line  pwhLine = na, var label pwhLbl = na
var line  pwlLine = na, var label pwlLbl = na

// Refresh PDH/PDL on each new day to track current vs prior day
isNewDayForPrev = ta.change(time("D")) != 0
var int prevDayStartBar = 0
if isNewDayForPrev
    prevDayStartBar := bar_index

// v13 M1: Track real week-start bar for PWH/PWL anchor
isNewWeekForPrev = ta.change(time("W")) != 0
var int prevWeekStartBar = 0
if isNewWeekForPrev
    prevWeekStartBar := bar_index

// Draw on last bar
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
        // v13 M1: anchor at real week-start bar
        pwhLine := line.new(weekStartBar, _pwh, rightPrevX, _pwh, color=color.new(C_BEAR, 20), width=prevLineWidth + 1, style=line.style_dashed, extend=prevLineExtend ? extend.right : extend.none)
        pwhLbl := label.new(rightPrevX, _pwh, " PWH " + str.tostring(_pwh, format.mintick) + " ", color=color.new(C_LBL_BEAR, 20), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)

    if showPWH and not na(_pwl)
        if not na(pwlLine)
            line.delete(pwlLine)
        if not na(pwlLbl)
            label.delete(pwlLbl)
        pwlLine := line.new(weekStartBar, _pwl, rightPrevX, _pwl, color=color.new(C_BULL, 20), width=prevLineWidth + 1, style=line.style_dashed, extend=prevLineExtend ? extend.right : extend.none)
        pwlLbl := label.new(rightPrevX, _pwl, " PWL " + str.tostring(_pwl, format.mintick) + " ", color=color.new(C_LBL_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)


// v12 #24: Daily/Weekly use exchange timezone (server-aligned). Midnight uses NY tz explicitly.
var line  dailyOpenLine = na, var label dailyOpenLbl = na
var line  weeklyOpenLine = na, var label weeklyOpenLbl = na
var line  midnightOpenLine = na, var label midnightOpenLbl = na
var float dailyOpenPx = na, var int dailyOpenBar = na
var float weeklyOpenPx = na, var int weeklyOpenBar = na
var float midnightOpenPx = na, var int midnightOpenBar = na

// Capture daily open at the start of each new daily bar
isNewDaily = ta.change(time("D")) != 0
if showDailyOpen and isNewDaily
    dailyOpenPx := open
    dailyOpenBar := bar_index

// Weekly open
isNewWeekly = ta.change(time("W")) != 0
if showWeeklyOpen and isNewWeekly
    weeklyOpenPx := open
    weeklyOpenBar := bar_index

// NY Midnight Open — detect when bar's NY-time hour just became 0 (i.e., 00:00 NY)
nyHourNow = hour(time, "America/New_York")
nyHourPrev = hour(time[1], "America/New_York")
isNewNYDay = showMidnightOpen and nyHourNow == 0 and nyHourPrev != 0
if isNewNYDay
    midnightOpenPx := open
    midnightOpenBar := bar_index

// Draw / refresh lines on last bar (_clampBar already hoisted above)
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
// MTF TREND — v14 B1: Closed bar only, no live fallback (kills HTF rollover repaint)
// ═══════════════════════════════════════════════════════════════
f_getTrend(_tf) =>
    [_ema20Closed, _ema50Closed] = request.security(
         syminfo.tickerid, _tf,
         [ta.ema(close, 20)[1], ta.ema(close, 50)[1]],
         lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)
    na(_ema20Closed) or na(_ema50Closed) ? 0 : _ema20Closed > _ema50Closed ? 1 : _ema20Closed < _ema50Closed ? -1 : 0

trendHTF1   = f_getTrend(htf1)
trendHTF2   = f_getTrend(htf2)
trendHTF3   = f_getTrend(htf3)
mtfBullBias = trendHTF1 == 1 and trendHTF2 == 1 and trendHTF3 == 1
mtfBearBias = trendHTF1 == -1 and trendHTF2 == -1 and trendHTF3 == -1

atrVal = ta.atr(atrLen)

// v13 F1: Range/chop filter — ADX + ATR percentile
[_diPlus, _diMinus, _adxVal] = ta.dmi(adxLenRng, adxLenRng)
_atrPctlThresh = ta.percentile_linear_interpolation(atrVal, atrPctlLen, atrPctlMin)
_adxLowChop = not na(_adxVal) and _adxVal < adxMinRng
_atrLowVol  = not na(_atrPctlThresh) and atrVal < _atrPctlThresh
isChopMarket = useRangeFilter and (_adxLowChop or _atrLowVol)
volatilityHealthy = not isChopMarket

// v12 #16: Volume confirmation — qualifying volume is +1 confluence
// v13 V1: auto-disable on forex/OTC (broker tick-volume is junk / non-existent)
volMA = ta.sma(volume, volMaLen)
_volUsable = useVolConfirm and not _isForexOrOTC
volBoost = _volUsable and not na(volMA) and volMA > 0 and volume >= volMA * volMult

// (_miscLabels / _miscLines / f_pushMisc / f_pushMiscLine already hoisted above)

// ═══════════════════════════════════════════════════════════════
// STRUCT LABEL HELPER (hoisted above swing block for Fix #2)
// ═══════════════════════════════════════════════════════════════
var label[] structLabels = array.new<label>()
var line[]  structLines  = array.new<line>()

f_pushStructLabel(lbl, ln) =>
    array.push(structLabels, lbl)
    array.push(structLines, ln)
    if array.size(structLabels) > maxStructLabels
        label.delete(array.shift(structLabels))
        line.delete(array.shift(structLines))

// ═══════════════════════════════════════════════════════════════
// SWING H/L — v11.1 Fix #2: Retro-scan intervening bars
// ═══════════════════════════════════════════════════════════════
swingHigh = ta.pivothigh(high, swingLen, swingLen)
swingLow  = ta.pivotlow(low, swingLen, swingLen)

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
    lastSHIdx := bar_index - swingLen
    lastSHBroken := false
    lastSHResetBar := bar_index

    // Retro-scan: did any bar between formation (excl.) and now (excl.) break this level?
    _retroBroken = false
    if swingLen > 1
        for _i = 1 to swingLen - 1
            _checkLvl = useWickForBOS ? high[_i] : close[_i]
            if _checkLvl > lastSH
                _retroBroken := true
                break
    if _retroBroken
        lastSHBroken := true
        if showBOS or showCHoCH
            _retroLn = line.new(lastSHIdx, lastSH, bar_index, lastSH, color=C_BEAR, style=line.style_dotted, width=1)
            _retroLbl = label.new(bar_index, lastSH, " ⤴ retro-broke ", color=color.new(C_LBL_BEAR, 40), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny)
            f_pushStructLabel(_retroLbl, _retroLn)
        if internalTrend != 1
            internalTrend := 1

    if showSwings
        label.new(bar_index - swingLen, swingHigh, " SH ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny)

if not na(swingLow)
    prevSL := lastSL
    prevSLIdx := lastSLIdx
    lastSL := swingLow
    lastSLIdx := bar_index - swingLen
    lastSLBroken := false
    lastSLResetBar := bar_index

    _retroBrokenL = false
    if swingLen > 1
        for _i = 1 to swingLen - 1
            _checkLvl = useWickForBOS ? low[_i] : close[_i]
            if _checkLvl < lastSL
                _retroBrokenL := true
                break
    if _retroBrokenL
        lastSLBroken := true
        if showBOS or showCHoCH
            _retroLnL = line.new(lastSLIdx, lastSL, bar_index, lastSL, color=C_BULL, style=line.style_dotted, width=1)
            _retroLblL = label.new(bar_index, lastSL, " ⤵ retro-broke ", color=color.new(C_LBL_BULL, 40), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny)
            f_pushStructLabel(_retroLblL, _retroLnL)
        if internalTrend != -1
            internalTrend := -1

    if showSwings
        label.new(bar_index - swingLen, swingLow, " SL ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny)

// ═══════════════════════════════════════════════════════════════
// BOS & CHoCH — v11.1 Fix #1: ATR-relative dual-break resolution
// ═══════════════════════════════════════════════════════════════
breakLevelHigh = useWickForBOS ? high : close
breakLevelLow  = useWickForBOS ? low  : close

sameBarBlockSH = not na(lastSHResetBar) and lastSHResetBar == bar_index
sameBarBlockSL = not na(lastSLResetBar) and lastSLResetBar == bar_index

// v13 R3: BOS/CHoCH only confirmed on bar close. Prevents intra-bar flip/repaint.
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

// ═══════════════════════════════════════════════════════════════
// v14 B8 — INTERNAL STRUCTURE (MSS trigger for entries)
// Shorter pivots; used to detect micro-MSS so entries fire faster.
// ═══════════════════════════════════════════════════════════════
intPHi = ta.pivothigh(high, intSwingLen, intSwingLen)
intPLo = ta.pivotlow (low,  intSwingLen, intSwingLen)
var float intLastHi = na, var float intLastLo = na
var bool  intHiBroken = false, var bool intLoBroken = false
var int   intTrend = 0
if not na(intPHi)
    intLastHi := intPHi
    intHiBroken := false
if not na(intPLo)
    intLastLo := intPLo
    intLoBroken := false
_intConfirmed = barstate.isconfirmed
intMssBull = _intConfirmed and not na(intLastHi) and not intHiBroken and close > intLastHi
intMssBear = _intConfirmed and not na(intLastLo) and not intLoBroken and close < intLastLo
if intMssBull
    intHiBroken := true
    intTrend := 1
if intMssBear
    intLoBroken := true
    intTrend := -1

// ═══════════════════════════════════════════════════════════════
// TRENDLINES
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

if showTrendlines and not na(lastSL) and not na(prevSL) and not na(swingLow) and lastSL > prevSL
    extendStyle = trendlineExtend ? extend.right : extend.none
    glow = trendlineGlow ? line.new(prevSLIdx, prevSL, lastSLIdx, lastSL, color=color.new(C_BULL, 70), width=trendlineWidth + 3, extend=extendStyle, style=line.style_solid) : na
    tl = line.new(prevSLIdx, prevSL, lastSLIdx, lastSL, color=C_BULL, width=trendlineWidth, extend=extendStyle, style=f_tlStyle())
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

if showTrendlines and not na(lastSH) and not na(prevSH) and not na(swingHigh) and lastSH < prevSH
    extendStyle = trendlineExtend ? extend.right : extend.none
    glow = trendlineGlow ? line.new(prevSHIdx, prevSH, lastSHIdx, lastSH, color=color.new(C_BEAR, 70), width=trendlineWidth + 3, extend=extendStyle, style=line.style_solid) : na
    tl = line.new(prevSHIdx, prevSH, lastSHIdx, lastSH, color=C_BEAR, width=trendlineWidth, extend=extendStyle, style=f_tlStyle())
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

if breakTrendline and array.size(bullTrendlines) > 0
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

if breakTrendline and array.size(bearTrendlines) > 0
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
// ORDER BLOCKS
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
// v13 M5: Strict mode requires the impulse candle to fire BOS/CHoCH
_bullStructEvent = bosBull or chochBull or initBull
_bearStructEvent = bosBear or chochBear or initBear
bullOBCond   = bullOBOffset > 0 and (not obRequireBOS or _bullStructEvent)
bearOBCond   = bearOBOffset > 0 and (not obRequireBOS or _bearStructEvent)

var box[]   bullOBs         = array.new<box>()
var label[] bullOBLabels    = array.new<label>()
var bool[]  bullOBMitigated = array.new<bool>()
var bool[]  bullOBIsMB      = array.new<bool>()    // v12 #9: post-CHoCH flag
var box[]   bearOBs         = array.new<box>()
var label[] bearOBLabels    = array.new<label>()
var bool[]  bearOBMitigated = array.new<bool>()
var bool[]  bearOBIsMB      = array.new<bool>()

// v12 #9: Track recent CHoCH for MB tagging — OBs formed within 10 bars of a CHoCH are MBs
var int lastBullCHoCHBar = -1000
var int lastBearCHoCHBar = -1000
if chochBull or initBull
    lastBullCHoCHBar := bar_index
if chochBear or initBear
    lastBearCHoCHBar := bar_index

// v12 #8: Breaker Blocks — when a mitigated OB is closed THROUGH, the zone flips to opposite-side resistance/support
var box[]   bullBreakers      = array.new<box>()    // Was bull OB → broken → now resistance
var label[] bullBreakerLabels = array.new<label>()
var int[]   bullBreakerBars   = array.new<int>()    // creation bar for age limit
var box[]   bearBreakers      = array.new<box>()    // Was bear OB → broken → now support
var label[] bearBreakerLabels = array.new<label>()
var int[]   bearBreakerBars   = array.new<int>()

if showOB and bullOBCond
    obHigh = high[bullOBOffset]
    obLow  = low[bullOBOffset]
    isMB = distinguishMB and (bar_index - lastBullCHoCHBar) <= 10
    obColor = isMB ? C_PURPLE : C_BULL
    obLabelColor = isMB ? C_PURPLE : C_LBL_BULL
    obLabelTxt = isMB ? " 💎 BULL MB " : " 🟢 BULL OB "
    obBox  = box.new(bar_index - bullOBOffset, obHigh, bar_index + 40, obLow, bgcolor=color.new(obColor, obOpacity), border_color=obColor, border_width=2)
    obLabel = label.new(bar_index + 40, (obHigh + obLow) / 2, obLabelTxt, color=obLabelColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
    array.push(bullOBs, obBox)
    array.push(bullOBLabels, obLabel)
    array.push(bullOBMitigated, false)
    array.push(bullOBIsMB, isMB)
    if array.size(bullOBs) > obMaxBoxes
        box.delete(array.shift(bullOBs))
        label.delete(array.shift(bullOBLabels))
        array.shift(bullOBMitigated)
        array.shift(bullOBIsMB)

if showOB and bearOBCond
    obHigh = high[bearOBOffset]
    obLow  = low[bearOBOffset]
    isMB = distinguishMB and (bar_index - lastBearCHoCHBar) <= 10
    obColor = isMB ? C_PURPLE : C_BEAR
    obLabelColor = isMB ? C_PURPLE : C_LBL_BEAR
    obLabelTxt = isMB ? " 💎 BEAR MB " : " 🔴 BEAR OB "
    obBox  = box.new(bar_index - bearOBOffset, obHigh, bar_index + 40, obLow, bgcolor=color.new(obColor, obOpacity), border_color=obColor, border_width=2)
    obLabel = label.new(bar_index + 40, (obHigh + obLow) / 2, obLabelTxt, color=obLabelColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
    array.push(bearOBs, obBox)
    array.push(bearOBLabels, obLabel)
    array.push(bearOBMitigated, false)
    array.push(bearOBIsMB, isMB)
    if array.size(bearOBs) > obMaxBoxes
        box.delete(array.shift(bearOBs))
        label.delete(array.shift(bearOBLabels))
        array.shift(bearOBMitigated)
        array.shift(bearOBIsMB)

// v12.1 BUG#1: Breaker promotion is two-phase. When an OB is mitigated, we record its
// bounds in a "pending breaker" tracker. On any subsequent bar where price closes
// THROUGH the zone, we promote it to a Breaker. This is the correct ICT definition.
var float[] bullPendingTops = array.new<float>()  // mitigated bull OBs awaiting close-below
var float[] bullPendingBots = array.new<float>()
var int[]   bullPendingBars = array.new<int>()
var float[] bearPendingTops = array.new<float>()  // mitigated bear OBs awaiting close-above
var float[] bearPendingBots = array.new<float>()
var int[]   bearPendingBars = array.new<int>()
_pendingMaxAge = 30  // give the OB 30 bars to either get reclaimed or break

// v13 M4: OB mitigation threshold helper (Touch / 50% / Full)
f_obMitTrigger(_top, _bot, _isBull) =>
    if obMitigationMode == "Touch"
        _isBull ? low <= _top : high >= _bot
    else if obMitigationMode == "50% fill"
        _mid = (_top + _bot) / 2
        _isBull ? low <= _mid : high >= _mid
    else  // Full fill
        _isBull ? low <= _bot : high >= _top

// Mitigation phase — uses configurable threshold (v13 M4)
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
                // v12.1 BUG#1: Don't promote to breaker here — add to pending tracker
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

// v12.1 BUG#1 + v13 R5: Breaker promotion. Close-through check gated by bar close.
_breakerConfirmed = barstate.isconfirmed
if showBreaker and array.size(bullPendingTops) > 0
    for i = array.size(bullPendingTops) - 1 to 0
        topL = array.get(bullPendingTops, i)
        botL = array.get(bullPendingBots, i)
        ageL = bar_index - array.get(bullPendingBars, i)
        // Bull OB pending: if price now closes BELOW the bottom, becomes bearish breaker
        if _breakerConfirmed and close < botL
            brBox = box.new(bar_index, topL, bar_index + 40, botL, bgcolor=color.new(C_BEAR, breakerOpacity), border_color=C_BEAR, border_width=1, border_style=line.style_dashed)
            brLbl = label.new(bar_index + 40, (topL + botL) / 2, " ⚡ BREAKER ▼ ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
            array.push(bearBreakers, brBox)
            array.push(bearBreakerLabels, brLbl)
            array.push(bearBreakerBars, bar_index)
            array.remove(bullPendingTops, i)
            array.remove(bullPendingBots, i)
            array.remove(bullPendingBars, i)
        else if ageL > _pendingMaxAge
            // Aged out without breakdown — drop from pending
            array.remove(bullPendingTops, i)
            array.remove(bullPendingBots, i)
            array.remove(bullPendingBars, i)

if showBreaker and array.size(bearPendingTops) > 0
    for i = array.size(bearPendingTops) - 1 to 0
        topL = array.get(bearPendingTops, i)
        botL = array.get(bearPendingBots, i)
        ageL = bar_index - array.get(bearPendingBars, i)
        // Bear OB pending: if price now closes ABOVE the top, becomes bullish breaker
        if _breakerConfirmed and close > topL
            brBox = box.new(bar_index, topL, bar_index + 40, botL, bgcolor=color.new(C_BULL, breakerOpacity), border_color=C_BULL, border_width=1, border_style=line.style_dashed)
            brLbl = label.new(bar_index + 40, (topL + botL) / 2, " ⚡ BREAKER ▲ ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
            array.push(bullBreakers, brBox)
            array.push(bullBreakerLabels, brLbl)
            array.push(bullBreakerBars, bar_index)
            array.remove(bearPendingTops, i)
            array.remove(bearPendingBots, i)
            array.remove(bearPendingBars, i)
        else if ageL > _pendingMaxAge
            array.remove(bearPendingTops, i)
            array.remove(bearPendingBots, i)
            array.remove(bearPendingBars, i)

// v12 #8: Age-out old breakers
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

f_countActiveOBs(_mitArr) =>
    cnt = 0
    if array.size(_mitArr) > 0
        for i = 0 to array.size(_mitArr) - 1
            if not array.get(_mitArr, i)
                cnt += 1
    cnt

activeBullOBs = f_countActiveOBs(bullOBMitigated)
activeBearOBs = f_countActiveOBs(bearOBMitigated)

f_priceInActiveOB(_obArr, _mitArr) =>
    inside = false
    if array.size(_obArr) > 0
        for i = 0 to array.size(_obArr) - 1
            if not array.get(_mitArr, i)
                b = array.get(_obArr, i)
                if low <= box.get_top(b) and high >= box.get_bottom(b)
                    inside := true
                    break
    inside

priceInBullOB = f_priceInActiveOB(bullOBs, bullOBMitigated)
priceInBearOB = f_priceInActiveOB(bearOBs, bearOBMitigated)

// ═══════════════════════════════════════════════════════════════
// FVG
// ═══════════════════════════════════════════════════════════════
fvgBullGap = math.abs(low - high[2])
fvgBearGap = math.abs(low[2] - high)
fvgBullSize = fvgBullGap / close * 100
fvgBearSize = fvgBearGap / close * 100
// v12 #17: Displacement filter — the middle (impulse) candle must be ≥ N×ATR in range
fvgDisplacementOK = not na(atrVal) and atrVal > 0 and (high[1] - low[1]) >= atrVal * fvgDisplacementATR
// v13 M3: ATR-based gap size — instrument-agnostic
_fvgAtrFloor = atrVal * fvgMinSizeAtr
fvgBullSizeOK = fvgMinSizeMode == "ATR fraction" ? (not na(atrVal) and fvgBullGap >= _fvgAtrFloor) : fvgBullSize >= fvgMinSize
fvgBearSizeOK = fvgMinSizeMode == "ATR fraction" ? (not na(atrVal) and fvgBearGap >= _fvgAtrFloor) : fvgBearSize >= fvgMinSize
bullFVG = low > high[2]  and close[1] > open[1] and fvgBullSizeOK and fvgDisplacementOK
bearFVG = high < low[2]  and close[1] < open[1] and fvgBearSizeOK and fvgDisplacementOK

var box[]   bullFVGs         = array.new<box>()
var label[] bullFVGLabels    = array.new<label>()
var bool[]  bullFVGMitigated = array.new<bool>()
var box[]   bearFVGs         = array.new<box>()
var label[] bearFVGLabels    = array.new<label>()
var bool[]  bearFVGMitigated = array.new<bool>()

// v12 #10: Inversion FVGs — when a FVG fully fills and price closes through, role inverts
var box[]   bullInverted = array.new<box>()    // Was bull FVG → fully filled → now resistance
var label[] bullInvertedLabels = array.new<label>()
var int[]   bullInvertedBars = array.new<int>()
var box[]   bearInverted = array.new<box>()    // Was bear FVG → fully filled → now support
var label[] bearInvertedLabels = array.new<label>()
var int[]   bearInvertedBars = array.new<int>()

if showFVG and bullFVG
    fvgBox = box.new(bar_index - 2, low, bar_index + 25, high[2], bgcolor=color.new(C_BLUE, 78), border_color=C_BLUE, border_width=1)
    fvgLbl = showFVGLabels ? label.new(bar_index + 25, (low + high[2]) / 2, " 🔵 FVG ", color=C_BLUE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small) : na
    array.push(bullFVGs, fvgBox)
    array.push(bullFVGLabels, fvgLbl)
    array.push(bullFVGMitigated, false)
    if array.size(bullFVGs) > maxFVGs
        box.delete(array.shift(bullFVGs))
        label.delete(array.shift(bullFVGLabels))
        array.shift(bullFVGMitigated)

if showFVG and bearFVG
    fvgBox = box.new(bar_index - 2, high, bar_index + 25, low[2], bgcolor=color.new(C_ORANGE, 78), border_color=C_ORANGE, border_width=1)
    fvgLbl = showFVGLabels ? label.new(bar_index + 25, (high + low[2]) / 2, " 🟠 FVG ", color=C_ORANGE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small) : na
    array.push(bearFVGs, fvgBox)
    array.push(bearFVGLabels, fvgLbl)
    array.push(bearFVGMitigated, false)
    if array.size(bearFVGs) > maxFVGs
        box.delete(array.shift(bearFVGs))
        label.delete(array.shift(bearFVGLabels))
        array.shift(bearFVGMitigated)

f_mitigateLevel(_top, _bot, _isBull) =>
    mid = (_top + _bot) / 2
    if fvgMitigationMode == "Touch"
        _isBull ? _top : _bot
    else if fvgMitigationMode == "50% fill"
        mid
    else
        _isBull ? _bot : _top

// v12.1 BUG#6: iFVG promotion is also two-phase. When a FVG is fully filled,
// we add it to a pending-inversion tracker. On a subsequent bar that closes
// THROUGH the zone, we promote it to an inverted FVG.
var float[] bullFVGPendingTops = array.new<float>()
var float[] bullFVGPendingBots = array.new<float>()
var int[]   bullFVGPendingBars = array.new<int>()
var float[] bearFVGPendingTops = array.new<float>()
var float[] bearFVGPendingBots = array.new<float>()
var int[]   bearFVGPendingBars = array.new<int>()
_pendingFVGMaxAge = 20

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
                // v12.1 BUG#6: Don't promote here — track for later closure check
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

// v12.1 BUG#6 + v13 R6: iFVG promotion gated by bar close
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
        else if ageL > _pendingFVGMaxAge
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
        else if ageL > _pendingFVGMaxAge
            array.remove(bearFVGPendingTops, i)
            array.remove(bearFVGPendingBots, i)
            array.remove(bearFVGPendingBars, i)

// v12 #10: Age out inverted FVGs (60-bar cap to keep chart clean)
if showInversionFVG
    if array.size(bullInverted) > 0
        for i = array.size(bullInverted) - 1 to 0
            if (bar_index - array.get(bullInvertedBars, i)) > 60
                box.delete(array.get(bullInverted, i))
                label.delete(array.get(bullInvertedLabels, i))
                array.remove(bullInverted, i)
                array.remove(bullInvertedLabels, i)
                array.remove(bullInvertedBars, i)
    if array.size(bearInverted) > 0
        for i = array.size(bearInverted) - 1 to 0
            if (bar_index - array.get(bearInvertedBars, i)) > 60
                box.delete(array.get(bearInverted, i))
                label.delete(array.get(bearInvertedLabels, i))
                array.remove(bearInverted, i)
                array.remove(bearInvertedLabels, i)
                array.remove(bearInvertedBars, i)

if showBPR and array.size(bullFVGs) > 0 and array.size(bearFVGs) > 0
    lastBullFVG = array.get(bullFVGs, array.size(bullFVGs) - 1)
    lastBearFVG = array.get(bearFVGs, array.size(bearFVGs) - 1)
    overlapTop = math.min(box.get_top(lastBullFVG), box.get_top(lastBearFVG))
    overlapBot = math.max(box.get_bottom(lastBullFVG), box.get_bottom(lastBearFVG))
    if overlapTop > overlapBot
        box.new(bar_index - 5, overlapTop, bar_index + 15, overlapBot, bgcolor=color.new(C_PURPLE, 55), border_color=C_PURPLE, border_width=2)
        label.new(bar_index + 15, (overlapTop + overlapBot) / 2, " ⚡ BPR ", color=C_PURPLE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)

f_priceInActiveFVG(_fvgArr, _mitArr) =>
    inside = false
    if array.size(_fvgArr) > 0
        for i = 0 to array.size(_fvgArr) - 1
            if not array.get(_mitArr, i)
                b = array.get(_fvgArr, i)
                if low <= box.get_top(b) and high >= box.get_bottom(b)
                    inside := true
                    break
    inside

priceInBullFVG = f_priceInActiveFVG(bullFVGs, bullFVGMitigated)
priceInBearFVG = f_priceInActiveFVG(bearFVGs, bearFVGMitigated)

// ═══════════════════════════════════════════════════════════════
// HTF POI — v12 #11 — Detect when LTF price is inside an HTF FVG or near HTF swing
// ═══════════════════════════════════════════════════════════════
// v13 R1: All HTF bars MUST be closed. Shift by [1]: 3-bar FVG uses [1]/[2]/[3] not [0]/[1]/[2].
[htfHigh3, htfLow3, htfHigh1, htfLow1, htfClose2, htfOpen2] = request.security(
     syminfo.tickerid, htfPOITF,
     [high[3], low[3], high[1], low[1], close[2], open[2]],
     lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)

// HTF bull FVG: low[1] > high[3] on HTF (gap up), middle [2] is bullish
htfBullFVGTop    = na(htfLow1) ? na : htfLow1
htfBullFVGBot    = na(htfHigh3) ? na : htfHigh3
htfBullFVGExists = useHTFPOI and not na(htfBullFVGTop) and not na(htfBullFVGBot) and htfBullFVGTop > htfBullFVGBot and not na(htfClose2) and not na(htfOpen2) and htfClose2 > htfOpen2

htfBearFVGTop    = na(htfLow3) ? na : htfLow3
htfBearFVGBot    = na(htfHigh1) ? na : htfHigh1
htfBearFVGExists = useHTFPOI and not na(htfBearFVGTop) and not na(htfBearFVGBot) and htfBearFVGTop > htfBearFVGBot and not na(htfClose2) and not na(htfOpen2) and htfClose2 < htfOpen2

priceInHTFBullFVG = htfBullFVGExists and low <= htfBullFVGTop and high >= htfBullFVGBot
priceInHTFBearFVG = htfBearFVGExists and low <= htfBearFVGTop and high >= htfBearFVGBot

// v12.1: HTF Order Blocks — was promised in v12 UI, now implemented.
// Strategy: detect strong HTF impulse candles (range >= 1×ATR_HTF), then the prior
// opposite-color candle is the HTF OB. We pull the impulse-candle range + the prior
// candle's H/L via request.security.
[htfHigh_imp, htfLow_imp, htfClose_imp, htfOpen_imp, htfHigh_pre, htfLow_pre, htfClose_pre, htfOpen_pre, htfATR_v] = request.security(
     syminfo.tickerid, htfPOITF,
     [high[1], low[1], close[1], open[1], high[2], low[2], close[2], open[2], ta.atr(14)[1]],
     lookahead=barmerge.lookahead_off, gaps=barmerge.gaps_off)

_htfImpRange = na(htfHigh_imp) or na(htfLow_imp) ? na : htfHigh_imp - htfLow_imp
_htfImpStrong = not na(_htfImpRange) and not na(htfATR_v) and htfATR_v > 0 and _htfImpRange >= htfATR_v
_htfImpIsBull = not na(htfClose_imp) and not na(htfOpen_imp) and htfClose_imp > htfOpen_imp
_htfImpIsBear = not na(htfClose_imp) and not na(htfOpen_imp) and htfClose_imp < htfOpen_imp
_htfPreIsBull = not na(htfClose_pre) and not na(htfOpen_pre) and htfClose_pre > htfOpen_pre
_htfPreIsBear = not na(htfClose_pre) and not na(htfOpen_pre) and htfClose_pre < htfOpen_pre

// HTF Bull OB: strong bullish impulse, prior candle was bearish — prior H/L is the OB zone
htfBullOBExists = useHTFOB and _htfImpStrong and _htfImpIsBull and _htfPreIsBear
htfBullOBTop = htfBullOBExists ? htfHigh_pre : na
htfBullOBBot = htfBullOBExists ? htfLow_pre  : na

// HTF Bear OB: strong bearish impulse, prior candle was bullish — prior H/L is the OB zone
htfBearOBExists = useHTFOB and _htfImpStrong and _htfImpIsBear and _htfPreIsBull
htfBearOBTop = htfBearOBExists ? htfHigh_pre : na
htfBearOBBot = htfBearOBExists ? htfLow_pre  : na

priceInHTFBullOB = htfBullOBExists and low <= htfBullOBTop and high >= htfBullOBBot
priceInHTFBearOB = htfBearOBExists and low <= htfBearOBTop and high >= htfBearOBBot

// Visualize HTF POI (only on last bar to avoid clutter)
var box htfBullPOIBox = na, var label htfBullPOILbl = na
var box htfBearPOIBox = na, var label htfBearPOILbl = na
var box htfBullOBBox = na, var label htfBullOBLbl = na
var box htfBearOBBox = na, var label htfBearOBLbl = na

if useHTFPOI and barstate.islast
    if htfBullFVGExists
        if not na(htfBullPOIBox)
            box.delete(htfBullPOIBox)
        if not na(htfBullPOILbl)
            label.delete(htfBullPOILbl)
        htfBullPOIBox := box.new(bar_index - 30, htfBullFVGTop, bar_index + 5, htfBullFVGBot, bgcolor=color.new(C_BLUE, 88), border_color=color.new(C_BLUE, 40), border_width=1, border_style=line.style_dotted)
        htfBullPOILbl := label.new(bar_index - 30, (htfBullFVGTop + htfBullFVGBot) / 2, " 🔭 HTF FVG (" + htfPOITF + ") ", color=color.new(C_BLUE, 40), textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_tiny)
    if htfBearFVGExists
        if not na(htfBearPOIBox)
            box.delete(htfBearPOIBox)
        if not na(htfBearPOILbl)
            label.delete(htfBearPOILbl)
        htfBearPOIBox := box.new(bar_index - 30, htfBearFVGTop, bar_index + 5, htfBearFVGBot, bgcolor=color.new(C_ORANGE, 88), border_color=color.new(C_ORANGE, 40), border_width=1, border_style=line.style_dotted)
        htfBearPOILbl := label.new(bar_index - 30, (htfBearFVGTop + htfBearFVGBot) / 2, " 🔭 HTF FVG (" + htfPOITF + ") ", color=color.new(C_ORANGE, 40), textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_tiny)
    if useHTFOB and htfBullOBExists
        if not na(htfBullOBBox)
            box.delete(htfBullOBBox)
        if not na(htfBullOBLbl)
            label.delete(htfBullOBLbl)
        htfBullOBBox := box.new(bar_index - 30, htfBullOBTop, bar_index + 5, htfBullOBBot, bgcolor=color.new(C_BULL, 86), border_color=color.new(C_BULL, 30), border_width=1, border_style=line.style_dashed)
        htfBullOBLbl := label.new(bar_index - 30, (htfBullOBTop + htfBullOBBot) / 2, " 🔭 HTF OB (" + htfPOITF + ") ", color=color.new(C_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_tiny)
    if useHTFOB and htfBearOBExists
        if not na(htfBearOBBox)
            box.delete(htfBearOBBox)
        if not na(htfBearOBLbl)
            label.delete(htfBearOBLbl)
        htfBearOBBox := box.new(bar_index - 30, htfBearOBTop, bar_index + 5, htfBearOBBot, bgcolor=color.new(C_BEAR, 86), border_color=color.new(C_BEAR, 30), border_width=1, border_style=line.style_dashed)
        htfBearOBLbl := label.new(bar_index - 30, (htfBearOBTop + htfBearOBBot) / 2, " 🔭 HTF OB (" + htfPOITF + ") ", color=color.new(C_BEAR, 30), textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_tiny)


// ═══════════════════════════════════════════════════════════════
// FIBONACCI
// ═══════════════════════════════════════════════════════════════
var line  fib0Line = na, var line fib236Line = na, var line fib382Line = na
var line  fib50Line = na, var line fib618Line = na, var line fib786Line = na, var line fib100Line = na
var label fib0Lbl = na, var label fib236Lbl = na, var label fib382Lbl = na
var label fib50Lbl = na, var label fib618Lbl = na, var label fib786Lbl = na, var label fib100Lbl = na
// v12 #13: OTE zone vars
var box   oteBox = na
var label oteLbl = na

if showFibRet and not na(lastSH) and not na(lastSL) and barstate.islast
    isUpswing = lastSLIdx < lastSHIdx
    swHi = lastSH
    swLo = lastSL
    rng = swHi - swLo
    leftX = math.min(lastSHIdx, lastSLIdx)
    rightX = bar_index + 25

    fib_0   = isUpswing ? swHi : swLo
    fib_236 = isUpswing ? swHi - rng * 0.236 : swLo + rng * 0.236
    fib_382 = isUpswing ? swHi - rng * 0.382 : swLo + rng * 0.382
    fib_50  = isUpswing ? swHi - rng * 0.50  : swLo + rng * 0.50
    fib_618 = isUpswing ? swHi - rng * 0.618 : swLo + rng * 0.618
    fib_786 = isUpswing ? swHi - rng * 0.786 : swLo + rng * 0.786
    fib_100 = isUpswing ? swLo : swHi

    if not na(fib0Line)
        line.delete(fib0Line)
    if not na(fib236Line)
        line.delete(fib236Line)
    if not na(fib382Line)
        line.delete(fib382Line)
    if not na(fib50Line)
        line.delete(fib50Line)
    if not na(fib618Line)
        line.delete(fib618Line)
    if not na(fib786Line)
        line.delete(fib786Line)
    if not na(fib100Line)
        line.delete(fib100Line)
    if not na(fib0Lbl)
        label.delete(fib0Lbl)
    if not na(fib236Lbl)
        label.delete(fib236Lbl)
    if not na(fib382Lbl)
        label.delete(fib382Lbl)
    if not na(fib50Lbl)
        label.delete(fib50Lbl)
    if not na(fib618Lbl)
        label.delete(fib618Lbl)
    if not na(fib786Lbl)
        label.delete(fib786Lbl)
    if not na(fib100Lbl)
        label.delete(fib100Lbl)

    fib50Line  := line.new(leftX, fib_50,  rightX, fib_50,  color=C_FIB_50,  width=1, style=line.style_dashed)
    fib50Lbl   := label.new(rightX, fib_50,  " 50%  "    + str.tostring(fib_50,  format.mintick) + " ", color=C_FIB_50,  textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_small)
    fib618Line := line.new(leftX, fib_618, rightX, fib_618, color=C_FIB_618, width=2, style=line.style_solid)
    fib618Lbl  := label.new(rightX, fib_618, " ★ 61.8%  " + str.tostring(fib_618, format.mintick) + " ", color=C_FIB_618, textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_normal)
    fib786Line := line.new(leftX, fib_786, rightX, fib_786, color=C_FIB_786, width=1, style=line.style_dotted)
    fib786Lbl  := label.new(rightX, fib_786, " 78.6%  "  + str.tostring(fib_786, format.mintick) + " ", color=C_FIB_786, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)

    // v12 #13: OTE zone (0.618 → 0.786) — the high-probability entry band
    if showOTEZone
        if not na(oteBox)
            box.delete(oteBox)
        if not na(oteLbl)
            label.delete(oteLbl)
        oteTop = math.max(fib_618, fib_786)
        oteBot = math.min(fib_618, fib_786)
        oteBox := box.new(leftX, oteTop, rightX, oteBot, bgcolor=color.new(C_GOLD, oteOpacity), border_color=color.new(C_GOLD, 50), border_width=1)
        oteLbl := label.new(leftX, (oteTop + oteBot) / 2, " ⭐ OTE ", color=C_GOLD, textcolor=C_TEXT_BLACK, style=label.style_label_right, size=sz_small)

    if showAllFibs
        fib0Line   := line.new(leftX, fib_0,   rightX, fib_0,   color=C_NEUTRAL, width=1, style=line.style_solid)
        fib0Lbl    := label.new(rightX, fib_0,   " 0%  "    + str.tostring(fib_0,   format.mintick) + " ", color=C_NEUTRAL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
        fib236Line := line.new(leftX, fib_236, rightX, fib_236, color=C_BLUE,    width=1, style=line.style_dotted)
        fib236Lbl  := label.new(rightX, fib_236, " 23.6%  " + str.tostring(fib_236, format.mintick) + " ", color=C_BLUE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
        fib382Line := line.new(leftX, fib_382, rightX, fib_382, color=C_CYAN,    width=1, style=line.style_dotted)
        fib382Lbl  := label.new(rightX, fib_382, " 38.2%  " + str.tostring(fib_382, format.mintick) + " ", color=C_CYAN, textcolor=C_TEXT_BLACK, style=label.style_label_left, size=sz_small)
        fib100Line := line.new(leftX, fib_100, rightX, fib_100, color=C_NEUTRAL, width=1, style=line.style_solid)
        fib100Lbl  := label.new(rightX, fib_100, " 100%  "  + str.tostring(fib_100, format.mintick) + " ", color=C_NEUTRAL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)

// ═══════════════════════════════════════════════════════════════
// PD ZONES — v12 #20: frozen at last CHoCH; #23: fixed-bar anchor
// ═══════════════════════════════════════════════════════════════
var box   premiumBox     = na
var box   discountBox    = na
var line  equilibriumLine = na
var label premiumLabel   = na
var label discountLabel  = na
var label eqLabel        = na

// v12 #20: Snapshot the swing range at the moment of each CHoCH and freeze it.
// This prevents PD zones from jumping mid-trend just because a new pivot formed.
var float pdRefHigh = na
var float pdRefLow  = na
var int   pdRefBar  = na

if (chochBull or chochBear or initBull or initBear) and not na(lastSH) and not na(lastSL)
    pdRefHigh := lastSH
    pdRefLow  := lastSL
    pdRefBar  := bar_index

// Fallback for charts where no CHoCH has happened yet: use current swings
pdHi = not na(pdRefHigh) ? pdRefHigh : lastSH
pdLo = not na(pdRefLow)  ? pdRefLow  : lastSL
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
    if not na(discountLabel)
        label.delete(discountLabel)
    if not na(eqLabel)
        label.delete(eqLabel)

    pdRightX = bar_index + 8
    premiumBox      := box.new(pdAnchorBar, pdHi, pdRightX, mid, bgcolor=color.new(C_BEAR, 93), border_color=color.new(C_BEAR, 50), border_width=1)
    discountBox     := box.new(pdAnchorBar, mid, pdRightX, pdLo, bgcolor=color.new(C_BULL, 93), border_color=color.new(C_BULL, 50), border_width=1)
    equilibriumLine := line.new(pdAnchorBar, mid, pdRightX, mid, color=color.new(C_NEUTRAL, 30), style=line.style_dashed, width=1)

    if cleanMode
        premiumLabel  := label.new(pdAnchorBar, (pdHi + mid) / 2, " ▼ Premium ", color=color.new(C_LBL_BEAR, 30), textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_tiny)
        discountLabel := label.new(pdAnchorBar, (mid + pdLo) / 2, " ▲ Discount ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_tiny)
        eqLabel       := label.new(pdAnchorBar, mid, " EQ ", color=color.new(C_LBL_DARK, 30), textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_tiny)
    else
        premiumLabel  := label.new(pdAnchorBar, (pdHi + mid) / 2, " ▼ PREMIUM \n Sell Zone ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_normal)
        discountLabel := label.new(pdAnchorBar, (mid + pdLo) / 2, " ▲ DISCOUNT \n Buy Zone ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_normal)
        eqLabel       := label.new(pdAnchorBar, mid, " EQ 50% ", color=C_LBL_DARK, textcolor=C_TEXT_WHITE, style=label.style_label_right, size=sz_small)


// ═══════════════════════════════════════════════════════════════
// LIQUIDITY + SWEEPS
// ═══════════════════════════════════════════════════════════════
var bool hasBSL = false
var bool hasSSL = false
var float lastBSLLabeled = na
var float lastSSLLabeled = na

// v12 #28: extLen now actually differs between modes (was a no-op ternary in v11)
extLen = cleanMode ? math.max(2, shortExtensionLines - 2) : shortExtensionLines

f_isEqualLevel(_a, _b) =>
    if liqToleranceMode == "ATR fraction"
        math.abs(_a - _b) <= atrVal * liqToleranceAtr
    else
        math.abs(_a - _b) / _a * 100 < liqTolerance

if showLiq and not na(lastSH) and not na(prevSH)
    if f_isEqualLevel(lastSH, prevSH)
        if na(lastBSLLabeled) or not f_isEqualLevel(lastSH, lastBSLLabeled)
            line.new(lastSHIdx, lastSH, bar_index + extLen, lastSH, color=color.new(C_BEAR, 30), style=line.style_dotted, width=1)
            label.new(bar_index + extLen, lastSH, " 💧 BSL ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
            lastBSLLabeled := lastSH
        hasBSL := true

if showLiq and not na(lastSL) and not na(prevSL)
    if f_isEqualLevel(lastSL, prevSL)
        if na(lastSSLLabeled) or not f_isEqualLevel(lastSL, lastSSLLabeled)
            line.new(lastSLIdx, lastSL, bar_index + extLen, lastSL, color=color.new(C_BULL, 30), style=line.style_dotted, width=1)
            label.new(bar_index + extLen, lastSL, " 💧 SSL ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_tiny)
            lastSSLLabeled := lastSL
        hasSSL := true

swingRangeSL = not na(lastSL) and not na(lastSH) ? lastSH - lastSL : 0
swingSignificant = swingRangeSL >= atrVal * sweepMinRange

// v13 R4: Sweep must be on confirmed bar to avoid intra-bar flip
_sweepConfirmed = barstate.isconfirmed
bullSweep_raw = _sweepConfirmed and detectSweeps and swingSignificant and not na(lastSL) and low < lastSL and close > lastSL and (close > open or close > close[1])
bearSweep_raw = _sweepConfirmed and detectSweeps and swingSignificant and not na(lastSH) and high > lastSH and close < lastSH and (close < open or close < close[1])

var int lastBullSweepSwingIdx = na
var int lastBearSweepSwingIdx = na

bullSweep = bullSweep_raw and (not dedupeSweepLabels or na(lastBullSweepSwingIdx) or lastBullSweepSwingIdx != lastSLIdx)
bearSweep = bearSweep_raw and (not dedupeSweepLabels or na(lastBearSweepSwingIdx) or lastBearSweepSwingIdx != lastSHIdx)

if bullSweep
    lastBullSweepSwingIdx := lastSLIdx
    if sweepMarkerStyle == "Full label"
        label.new(bar_index, low, " 💎 SWEEP ▲ ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small, yloc=yloc.belowbar)
    else if sweepMarkerStyle == "Compact triangle"
        label.new(bar_index, low, "▲", color=C_BULL, textcolor=C_TEXT_WHITE, style=label.style_triangleup, size=sz_tiny, yloc=yloc.belowbar)
    else
        label.new(bar_index, low, "◆", color=color.new(C_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_diamond, size=sz_tiny, yloc=yloc.belowbar)

if bearSweep
    lastBearSweepSwingIdx := lastSHIdx
    if sweepMarkerStyle == "Full label"
        label.new(bar_index, high, " 💎 SWEEP ▼ ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
    else if sweepMarkerStyle == "Compact triangle"
        label.new(bar_index, high, "▼", color=C_BEAR, textcolor=C_TEXT_WHITE, style=label.style_triangledown, size=sz_tiny, yloc=yloc.abovebar)
    else
        label.new(bar_index, high, "◆", color=color.new(C_BEAR, 20), textcolor=C_TEXT_WHITE, style=label.style_diamond, size=sz_tiny, yloc=yloc.abovebar)

// v12 #25: Liquidity GRAB — wick takes liquidity AND price continues through (no reversal)
// Bear grab: high > lastSH AND close > lastSH (price stayed above) — bullish continuation
// Bull grab: low < lastSL AND close < lastSL (price stayed below) — bearish continuation
// v13 R4: Grabs gated by bar close
bearLiqGrab = _sweepConfirmed and detectLiqGrabs and swingSignificant and not na(lastSH) and high > lastSH and close > lastSH and close > open
bullLiqGrab = _sweepConfirmed and detectLiqGrabs and swingSignificant and not na(lastSL) and low < lastSL and close < lastSL and close < open

// v12.1 BUG#5: Grabs have their own dedup tracker so they aren't suppressed by recent sweeps
var int lastBullGrabSwingIdx = na
var int lastBearGrabSwingIdx = na

if bearLiqGrab and (na(lastBearGrabSwingIdx) or lastBearGrabSwingIdx != lastSHIdx)
    lastBearGrabSwingIdx := lastSHIdx
    _lg1 = label.new(bar_index, high, "⬆", color=color.new(C_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny, yloc=yloc.abovebar)
    f_pushMisc(_lg1)
if bullLiqGrab and (na(lastBullGrabSwingIdx) or lastBullGrabSwingIdx != lastSLIdx)
    lastBullGrabSwingIdx := lastSLIdx
    _lg2 = label.new(bar_index, low, "⬇", color=color.new(C_BEAR, 20), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny, yloc=yloc.belowbar)
    f_pushMisc(_lg2)

// ═══════════════════════════════════════════════════════════════
// AMD / POWER OF 3 — v12 #14 (v12.1 BUG#2 fixed)
// ═══════════════════════════════════════════════════════════════
// Asia accumulates → London manipulates (sweeps Asia H/L) → NY distributes (trends).
// v12.1: snapshot Asia high/low at END of Asia session, not on every Asia bar.
// This separates yesterday's Asia (frozen) from today's Asia (still building).
var float amdAsiaHi = na, var float amdAsiaLo = na           // FROZEN snapshot from last Asia close
var float amdAsiaHiBuilding = na, var float amdAsiaLoBuilding = na  // Current Asia in-progress
var bool  amdAsiaBuilt = false
var int   amdAsiaEndBar = na
var bool  amdSweptToday = false  // prevents duplicate AMD labels on same day

// During Asia: build current session H/L
if inAsia
    if not inAsia[1]
        // New Asia session — reset building
        amdAsiaHiBuilding := high
        amdAsiaLoBuilding := low
        amdSweptToday := false  // reset for new day
    else
        amdAsiaHiBuilding := math.max(amdAsiaHiBuilding, high)
        amdAsiaLoBuilding := math.min(amdAsiaLoBuilding, low)

// Asia just ended — snapshot the range if it's significant enough
if not inAsia and inAsia[1] and not na(amdAsiaHiBuilding) and not na(amdAsiaLoBuilding)
    asiaRng = amdAsiaHiBuilding - amdAsiaLoBuilding
    if not na(atrVal) and asiaRng >= atrVal * amdMinRangeATR
        amdAsiaHi := amdAsiaHiBuilding
        amdAsiaLo := amdAsiaLoBuilding
        amdAsiaBuilt := true
        amdAsiaEndBar := bar_index

amdLondonSweepHi = detectAMD and amdAsiaBuilt and inLondon and not amdSweptToday and not na(amdAsiaHi) and high > amdAsiaHi and close < amdAsiaHi
amdLondonSweepLo = detectAMD and amdAsiaBuilt and inLondon and not amdSweptToday and not na(amdAsiaLo) and low < amdAsiaLo and close > amdAsiaLo

if amdLondonSweepHi or amdLondonSweepLo
    amdSweptToday := true

if amdLondonSweepHi
    _aml1 = label.new(bar_index, high, " 🌀 AMD ▼ ", color=color.new(C_LBL_BEAR, 20), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
    f_pushMisc(_aml1)
if amdLondonSweepLo
    _aml2 = label.new(bar_index, low, " 🌀 AMD ▲ ", color=color.new(C_LBL_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small, yloc=yloc.belowbar)
    f_pushMisc(_aml2)

// ═══════════════════════════════════════════════════════════════
// TURTLE SOUP — v12 #15 — N-bar false break
// ═══════════════════════════════════════════════════════════════
nBarHi = ta.highest(high[1], turtleSoupLookback)
nBarLo = ta.lowest(low[1], turtleSoupLookback)

turtleSoupBull = showTurtleSoup and not na(nBarLo) and low < nBarLo and close > nBarLo and close > open
turtleSoupBear = showTurtleSoup and not na(nBarHi) and high > nBarHi and close < nBarHi and close < open

if turtleSoupBull
    _ts1 = label.new(bar_index, low, " 🐢 TS ▲ ", color=color.new(C_GOLD, 20), textcolor=C_TEXT_BLACK, style=label.style_label_up, size=sz_tiny, yloc=yloc.belowbar)
    f_pushMisc(_ts1)
if turtleSoupBear
    _ts2 = label.new(bar_index, high, " 🐢 TS ▼ ", color=color.new(C_GOLD, 20), textcolor=C_TEXT_BLACK, style=label.style_label_down, size=sz_tiny, yloc=yloc.abovebar)
    f_pushMisc(_ts2)


// ═══════════════════════════════════════════════════════════════
// PATTERNS
// ═══════════════════════════════════════════════════════════════
candleBody  = math.abs(close - open)
candleRange = high - low
upperWick   = high - math.max(close, open)
lowerWick   = math.min(close, open) - low

// v14 B5: Pin bar min body — kills doji false pins
_pinMinBody = atrVal * 0.10
bullPin = showPinBar and showPatterns and candleRange > 0 and candleBody >= _pinMinBody and lowerWick >= candleBody * pinBarRatio and lowerWick >= candleRange * 0.55 and upperWick <= candleBody * 0.5 and close > open
bearPin = showPinBar and showPatterns and candleRange > 0 and candleBody >= _pinMinBody and upperWick >= candleBody * pinBarRatio and upperWick >= candleRange * 0.55 and lowerWick <= candleBody * 0.5 and close < open

if bullPin
    _pl = label.new(bar_index, low, " 🔨 ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small, yloc=yloc.belowbar)
    f_pushMisc(_pl)
if bearPin
    _pl2 = label.new(bar_index, high, " ⭐ ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small, yloc=yloc.abovebar)
    f_pushMisc(_pl2)

doubleTopWindow = swingLen + 5
// v14 B3: ATR-relative tolerance (was hardcoded 0.3%)
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

// v12.1 BUG#4: All pattern labels now go through f_pushMisc for cleanup

if doubleTop
    _dtLn = line.new(prevSHIdx, prevSH, lastSHIdx, lastSH, color=color.new(C_BEAR, 40), width=1, style=line.style_dotted)
    f_pushMiscLine(_dtLn)
    _dtLbl = cleanMode ? label.new(lastSHIdx, lastSH, "  =H ", color=color.new(C_LBL_BEAR, 30), textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_tiny) : label.new(lastSHIdx, lastSH, " 🔻 DT ", color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sz_small)
    f_pushMisc(_dtLbl)
if doubleBot
    _dbLn = line.new(prevSLIdx, prevSL, lastSLIdx, lastSL, color=color.new(C_BULL, 40), width=1, style=line.style_dotted)
    f_pushMiscLine(_dbLn)
    _dbLbl = cleanMode ? label.new(lastSLIdx, lastSL, "  =L ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_tiny) : label.new(lastSLIdx, lastSL, " 🔺 DB ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sz_small)
    f_pushMisc(_dbLbl)

// ═══════════════════════════════════════════════════════════════
// CONFLUENCE — WEIGHTED SCORING (v12: expanded with HTF POI, breakers, volume, AMD, TS)
// ═══════════════════════════════════════════════════════════════
bullEngulf = isBullC and isBearC[1] and open <= close[1] and close >= open[1] and (close - open) > (open[1] - close[1])
bearEngulf = isBearC and isBullC[1] and open >= close[1] and close <= open[1] and (open - close) > (close[1] - open[1])

mid_ = not na(lastSH) and not na(lastSL) ? (lastSH + lastSL) / 2 : close

// v12 helper: is current bar inside any active Breaker box?
f_priceInBreaker(_brArr) =>
    inside = false
    if array.size(_brArr) > 0
        for i = 0 to array.size(_brArr) - 1
            b = array.get(_brArr, i)
            if low <= box.get_top(b) and high >= box.get_bottom(b)
                inside := true
                break
    inside

priceInBullBreaker = f_priceInBreaker(bullBreakers)
priceInBearBreaker = f_priceInBreaker(bearBreakers)
priceInBullInverted = f_priceInBreaker(bullInverted)
priceInBearInverted = f_priceInBreaker(bearInverted)

// v14 B2: Use FROZEN PD reference mid for zone consistency (matches displayed PD box)
_zoneMid = not na(pdRefHigh) and not na(pdRefLow) ? (pdRefHigh + pdRefLow) / 2 : mid_

// v14 B7: POI confluence OR-collapsed. LTF POI (OB/FVG/Breaker/iFVG) counts ONCE (+2).
//         HTF POI separate (+htfPOIWeight). Prevents double-counting same zone.
ltfBullPOI = priceInBullOB or priceInBullFVG or bullFVG or priceInBullBreaker or priceInBullInverted
ltfBearPOI = priceInBearOB or priceInBearFVG or bearFVG or priceInBearBreaker or priceInBearInverted

bullScore = 0
bullScore := bullScore + (mtfBullBias ? 3 : trendHTF1 == 1 ? 2 : 0)
bullScore := bullScore + (internalTrend == 1 ? 2 : 0)
bullScore := bullScore + (intTrend == 1 ? 1 : 0)
bullScore := bullScore + (close < _zoneMid ? 2 : 0)
bullScore := bullScore + (ltfBullPOI ? 2 : 0)
bullScore := bullScore + (useHTFPOI and (priceInHTFBullFVG or priceInHTFBullOB) ? htfPOIWeight : 0)
bullScore := bullScore + (bullPin or doubleBot ? 1 : 0)
bullScore := bullScore + (hasSSL or bullSweep ? 2 : 0)
bullScore := bullScore + (killzoneBoostConfluence and inAnyKZ ? 1 : 0)
bullScore := bullScore + (volBoost ? 1 : 0)
bullScore := bullScore + (amdLondonSweepLo ? 1 : 0)
bullScore := bullScore + (turtleSoupBull ? 1 : 0)

bearScore = 0
bearScore := bearScore + (mtfBearBias ? 3 : trendHTF1 == -1 ? 2 : 0)
bearScore := bearScore + (internalTrend == -1 ? 2 : 0)
bearScore := bearScore + (intTrend == -1 ? 1 : 0)
bearScore := bearScore + (close > _zoneMid ? 2 : 0)
bearScore := bearScore + (ltfBearPOI ? 2 : 0)
bearScore := bearScore + (useHTFPOI and (priceInHTFBearFVG or priceInHTFBearOB) ? htfPOIWeight : 0)
bearScore := bearScore + (bearPin or doubleTop ? 1 : 0)
bearScore := bearScore + (hasBSL or bearSweep ? 2 : 0)
bearScore := bearScore + (killzoneBoostConfluence and inAnyKZ ? 1 : 0)
bearScore := bearScore + (volBoost ? 1 : 0)
bearScore := bearScore + (amdLondonSweepHi ? 1 : 0)
bearScore := bearScore + (turtleSoupBear ? 1 : 0)

// v14 maxScore: 3+2+1+2+2+htfPOIWeight+1+2+1+1+1+1 = 17 + htfPOIWeight
maxScore_v12 = 3 + 2 + 1 + 2 + 2 + htfPOIWeight + 1 + 2 + 1 + 1 + 1 + 1

canEnterByKZ = not killzoneOnly or inAnyKZ

var int lastBullSignalBar = -1000
var int lastBearSignalBar = -1000

cooldownOkBull = useGlobalCooldown ? (bar_index - math.max(lastBullSignalBar, lastBearSignalBar)) >= signalCooldownBars : (bar_index - lastBullSignalBar) >= signalCooldownBars
cooldownOkBear = useGlobalCooldown ? (bar_index - math.max(lastBullSignalBar, lastBearSignalBar)) >= signalCooldownBars : (bar_index - lastBearSignalBar) >= signalCooldownBars

// v14 B14: Displacement gate at trigger candle
_bodyAbs = math.abs(close - open)
dispOkBull = not useDisplacement or (not na(atrVal) and _bodyAbs >= atrVal * dispBodyAtr and close > open)
dispOkBear = not useDisplacement or (not na(atrVal) and _bodyAbs >= atrVal * dispBodyAtr and close < open)

bullTrigger = (bullEngulf or (includePinBarSignals and bullPin) or (includeSweepSignals and bullSweep)) and dispOkBull
bearTrigger = (bearEngulf or (includePinBarSignals and bearPin) or (includeSweepSignals and bearSweep)) and dispOkBear

// v14 B8: Internal MSS in trade direction (optional)
mssOkBull = not useInternalMSS or intMssBull or intTrend == 1
mssOkBear = not useInternalMSS or intMssBear or intTrend == -1

validBullEntryRaw = bullTrigger and mssOkBull and (requireConfluence ? bullScore >= minConfluence : true) and canEnterByKZ
validBearEntryRaw = bearTrigger and mssOkBear and (requireConfluence ? bearScore >= minConfluence : true) and canEnterByKZ

// v11.1 Fix #7: Bar-close gate to prevent repainting
_barOk = not waitForBarClose or barstate.isconfirmed

// v13 F2: Mandatory hard-filter gate
// HTF alignment: ≥2 of 3 HTFs same direction as trade
_htfBullCount = (trendHTF1 == 1 ? 1 : 0) + (trendHTF2 == 1 ? 1 : 0) + (trendHTF3 == 1 ? 1 : 0)
_htfBearCount = (trendHTF1 == -1 ? 1 : 0) + (trendHTF2 == -1 ? 1 : 0) + (trendHTF3 == -1 ? 1 : 0)
htfAlignedBull = not hgRequireHTF or _htfBullCount >= 2
htfAlignedBear = not hgRequireHTF or _htfBearCount >= 2

// v14 B2: Zone uses FROZEN PD mid (matches displayed PD box)
zoneOkBull = not hgRequireZone or (not na(_zoneMid) and close < _zoneMid)
zoneOkBear = not hgRequireZone or (not na(_zoneMid) and close > _zoneMid)

// v14 B13: OTC disables KZ-gate (broker synthetic sessions don't match)
_kzGateActive = hgRequireKZ and not _isOTC
kzOkHard = not _kzGateActive or inAnyKZ

// Recent liquidity event tracker (sweep, grab, AMD)
var int lastBullLiqBar = -1000
var int lastBearLiqBar = -1000
if bullSweep or bullLiqGrab or amdLondonSweepLo or turtleSoupBull
    lastBullLiqBar := bar_index
if bearSweep or bearLiqGrab or amdLondonSweepHi or turtleSoupBear
    lastBearLiqBar := bar_index
liqOkBull = not hgRequireLiq or (bar_index - lastBullLiqBar) <= hgLiqLookback
liqOkBear = not hgRequireLiq or (bar_index - lastBearLiqBar) <= hgLiqLookback

// Volatility healthy
volOkHard = not hgRequireVol or volatilityHealthy

hardGateBull = not useHardGate or (htfAlignedBull and zoneOkBull and kzOkHard and liqOkBull and volOkHard)
hardGateBear = not useHardGate or (htfAlignedBear and zoneOkBear and kzOkHard and liqOkBear and volOkHard)

// v14 B9: News blocker
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

// v14 B15: Daily loss cap + max trades per KZ
var float dayRealizedR = 0.0
var int   dayBar = na
isNewTradingDay = na(dayBar) or ta.change(time("D")) != 0
if isNewTradingDay
    dayRealizedR := 0.0
    dayBar := bar_index
var int   tradesThisKZ = 0
var bool  inAnyKZ_prev = false
if inAnyKZ and not inAnyKZ_prev
    tradesThisKZ := 0
inAnyKZ_prev := inAnyKZ

dailyOk = not useDailyLossCap or dayRealizedR > dailyLossR
kzTradeCapOk = not useMaxTradesKZ or not inAnyKZ or tradesThisKZ < maxTradesPerKZ

validBullEntry = validBullEntryRaw and cooldownOkBull and _barOk and hardGateBull and not newsBlocked and dailyOk and kzTradeCapOk
validBearEntry = validBearEntryRaw and cooldownOkBear and _barOk and hardGateBear and not newsBlocked and dailyOk and kzTradeCapOk

if validBullEntry
    lastBullSignalBar := bar_index
    tradesThisKZ := tradesThisKZ + 1
    if not useGlobalCooldown
        lastBearSignalBar := math.max(lastBearSignalBar, bar_index - signalCooldownBars + 3)
if validBearEntry
    lastBearSignalBar := bar_index
    tradesThisKZ := tradesThisKZ + 1
    if not useGlobalCooldown
        lastBullSignalBar := math.max(lastBullSignalBar, bar_index - signalCooldownBars + 3)

sigSize_sig = signalLabelSize == "Tiny" ? size.tiny : signalLabelSize == "Small" ? size.small : signalLabelSize == "Normal" ? size.normal : size.large
sigBullText = signalLabelStyle == "Compact" ? "▲" : "▲ LONG"
sigBearText = signalLabelStyle == "Compact" ? "▼" : "▼ SHORT"

if showEngulf and validBullEntry
    label.new(bar_index, low, sigBullText, color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_up, size=sigSize_sig, yloc=yloc.belowbar)

if showEngulf and validBearEntry
    label.new(bar_index, high, sigBearText, color=C_LBL_BEAR, textcolor=C_TEXT_WHITE, style=label.style_label_down, size=sigSize_sig, yloc=yloc.abovebar)

plotshape(validBullEntry, title="LONG Signal", location=location.belowbar, style=shape.triangleup,   color=color.new(C_BULL, 100), size=size.tiny, display=display.none)
plotshape(validBearEntry, title="SHORT Signal", location=location.abovebar, style=shape.triangledown, color=color.new(C_BEAR, 100), size=size.tiny, display=display.none)

// ═══════════════════════════════════════════════════════════════
// POSITION MANAGEMENT — v11.1 Fixes #4 (fractions) + #6 (TP2 ambiguity)
// ═══════════════════════════════════════════════════════════════
var int   posDirection      = 0
var float posEntry          = na
var float posSL             = na
var float posOrigSL         = na
var float posTP1            = na
var float posTP2            = na
var float posTP3            = na
var bool  posTP1Hit         = false
var bool  posTP2Hit         = false
// v11.1 Fix #4: Size as FRACTION (0.0-1.0). Realized P&L in price-points × fraction-closed.
var float posSizeRemaining  = 1.0
var float posRealizedPnL    = 0.0
var int   posOpenBar        = na
var int   posOpenScore      = 0
var line  posEntryLine      = na, var line posSLLine = na
var line  posTP1Line        = na, var line posTP2Line = na, var line posTP3Line = na
var label posEntryLbl       = na, var label posSLLbl = na
var label posTP1Lbl         = na, var label posTP2Lbl = na, var label posTP3Lbl = na
var label posPnLLbl         = na
var box   rewardBox         = na, var box riskBox = na

// v11.1 Fix #5: Cache last-drawn state. Only recreate viz if these change.
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

f_calcSL(_isLong) =>
    if slMode == "ATR-based"
        _isLong ? low[1] - atrVal * atrMult : high[1] + atrVal * atrMult
    else if slMode == "Swing-based" and not na(lastSL) and not na(lastSH)
        _isLong ? math.min(low[1], lastSL) - slBuffer : math.max(high[1], lastSH) + slBuffer
    else
        _isLong ? low[1] - slBuffer : high[1] + slBuffer

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

// v11.1 Fix #4: Fractions throughout.
f_totalPnLPct(_currentPrice) =>
    unrealizedPnL = posDirection == 1 ? (_currentPrice - posEntry) * posSizeRemaining : (posEntry - _currentPrice) * posSizeRemaining
    totalPnL = posRealizedPnL + unrealizedPnL
    (totalPnL / posEntry) * 100

f_rMultiple(_currentPrice) =>
    unrealizedPnL = posDirection == 1 ? (_currentPrice - posEntry) * posSizeRemaining : (posEntry - _currentPrice) * posSizeRemaining
    totalPnL = posRealizedPnL + unrealizedPnL
    risk_per_unit = math.abs(posEntry - posOrigSL)
    risk_per_unit > 0 ? totalPnL / risk_per_unit : 0

// v12 #7: Flip slippage — track pending flips for next-bar-open fill
var bool  pendingFlipToLong  = false
var bool  pendingFlipToShort = false

// Execute deferred flips on this bar's open (if we set pending last bar)
if pendingFlipToLong and flipUseNextBarOpen
    posDirection := 1
    posEntry := open
    posSL := f_calcSL(true)
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
    pendingFlipToLong := false

if pendingFlipToShort and flipUseNextBarOpen
    posDirection := -1
    posEntry := open
    posSL := f_calcSL(false)
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
        label.new(bar_index, close, flipText_flip, color=flipColor_flip, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=flipSize_flip)
    f_clearPositionViz()
    // v12 #7: If slippage simulation is on, defer the new entry to next bar's open
    if flipUseNextBarOpen
        posDirection := 0  // flatten now; pending will reopen next bar at open
        pendingFlipToLong := true
        // Don't run the immediate-fill block below
        doOpenLong := false
        doFlipToLong := false

if doOpenLong or doFlipToLong
    posDirection := 1
    posEntry := close
    posSL := f_calcSL(true)
    posOrigSL := posSL
    riskL_open = posEntry - posSL
    // v14 B11: TP cascade sanity
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
        label.new(bar_index, close, flipText_flip2, color=flipColor_flip2, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=flipSize_flip2)
    f_clearPositionViz()
    // v12 #7: Defer flip fill to next bar's open if slippage simulation is on
    if flipUseNextBarOpen
        posDirection := 0
        pendingFlipToShort := true
        doOpenShort := false
        doFlipToShort := false

if doOpenShort or doFlipToShort
    posDirection := -1
    posEntry := close
    posSL := f_calcSL(false)
    posOrigSL := posSL
    riskS_open = posSL - posEntry
    // v14 B11: TP cascade sanity
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

// LONG EXITS
if enablePositions and posDirection == 1
    // Same-bar ambiguity rules
    slTouched_long = low <= posSL
    tp1Touched_long = useMultiTP and not posTP1Hit and high >= posTP1
    slFirstWins_long = slTouched_long and tp1Touched_long

    if useMultiTP and not posTP1Hit and high >= posTP1 and not slFirstWins_long
        posTP1Hit := true
        realizedAtTP1 = (posTP1 - posEntry) * tp1Frac
        posRealizedPnL := posRealizedPnL + realizedAtTP1
        posSizeRemaining := posSizeRemaining - tp1Frac
        label.new(bar_index, posTP1, cleanMode ? " ✓1 " : " ✓ TP1 -" + str.tostring(partialTP1, "#") + "% ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=cleanMode ? sz_tiny : sz_small)
        if moveToBreakeven
            // v13 M2: BE+buffer for long
            posSL := posEntry + atrVal * beBufferAtr

    // v11.1 Fix #6: TP2 must also respect same-bar SL ambiguity
    tp2Touched_long = useMultiTP and posTP1Hit and not posTP2Hit and high >= posTP2
    slTouched_long_tp2 = low <= posSL
    slFirstWinsTP2_long = slTouched_long_tp2 and tp2Touched_long
    if tp2Touched_long and not slFirstWinsTP2_long
        posTP2Hit := true
        realizedAtTP2 = (posTP2 - posEntry) * tp2Frac
        posRealizedPnL := posRealizedPnL + realizedAtTP2
        posSizeRemaining := posSizeRemaining - tp2Frac
        label.new(bar_index, posTP2, cleanMode ? " ✓2 " : " ✓ TP2 -" + str.tostring(partialTP2, "#") + "% ", color=color.new(C_LBL_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=cleanMode ? sz_tiny : sz_small)

    // v14 B10: structure trail SL after TP2 — pull SL to last internal low if higher than current SL
    if posTP2Hit and useStructTrail and not na(intLastLo) and intLastLo > posSL and intLastLo < close
        posSL := intLastLo

    if low <= posSL
        finalRealized = (posSL - posEntry) * posSizeRemaining
        totalRealized = posRealizedPnL + finalRealized
        totalPct = (totalRealized / posEntry) * 100
        // v14 B15: daily R tally
        _riskPerUnit = math.abs(posEntry - posOrigSL)
        if _riskPerUnit > 0
            dayRealizedR := dayRealizedR + (totalRealized / _riskPerUnit)
        slColor = totalRealized >= 0 ? C_LBL_BULL : C_LBL_BEAR
        slIcon = totalRealized >= 0 ? "🛡️" : "🛑"
        if compactExitLabels
            label.new(bar_index, posSL, " " + slIcon + " " + str.tostring(totalPct, "#.##") + "% ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
        else
            label.new(bar_index, posSL, " " + slIcon + " SL " + str.tostring(totalPct, "#.##") + "% ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)
        f_clearPositionViz()
        posDirection := 0
    else if high >= posTP3
        finalRealized = (posTP3 - posEntry) * posSizeRemaining
        totalRealized = posRealizedPnL + finalRealized
        totalPct = (totalRealized / posEntry) * 100
        _riskPerUnit = math.abs(posEntry - posOrigSL)
        if _riskPerUnit > 0
            dayRealizedR := dayRealizedR + (totalRealized / _riskPerUnit)
        if compactExitLabels
            label.new(bar_index, posTP3, " 🎯 " + str.tostring(totalPct, "#.##") + "% ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
        else
            label.new(bar_index, posTP3, " 🎯 TP " + str.tostring(rrRatio, "#.#") + "R " + str.tostring(totalPct, "#.##") + "% ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)
        f_clearPositionViz()
        posDirection := 0

// SHORT EXITS
if enablePositions and posDirection == -1
    slTouched_short = high >= posSL
    tp1Touched_short = useMultiTP and not posTP1Hit and low <= posTP1
    slFirstWins_short = slTouched_short and tp1Touched_short

    if useMultiTP and not posTP1Hit and low <= posTP1 and not slFirstWins_short
        posTP1Hit := true
        realizedAtTP1 = (posEntry - posTP1) * tp1Frac
        posRealizedPnL := posRealizedPnL + realizedAtTP1
        posSizeRemaining := posSizeRemaining - tp1Frac
        label.new(bar_index, posTP1, cleanMode ? " ✓1 " : " ✓ TP1 -" + str.tostring(partialTP1, "#") + "% ", color=color.new(C_LBL_BULL, 30), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=cleanMode ? sz_tiny : sz_small)
        if moveToBreakeven
            // v13 M2: BE+buffer for short
            posSL := posEntry - atrVal * beBufferAtr

    // v11.1 Fix #6: TP2 must also respect same-bar SL ambiguity
    tp2Touched_short = useMultiTP and posTP1Hit and not posTP2Hit and low <= posTP2
    slTouched_short_tp2 = high >= posSL
    slFirstWinsTP2_short = slTouched_short_tp2 and tp2Touched_short
    if tp2Touched_short and not slFirstWinsTP2_short
        posTP2Hit := true
        realizedAtTP2 = (posEntry - posTP2) * tp2Frac
        posRealizedPnL := posRealizedPnL + realizedAtTP2
        posSizeRemaining := posSizeRemaining - tp2Frac
        label.new(bar_index, posTP2, cleanMode ? " ✓2 " : " ✓ TP2 -" + str.tostring(partialTP2, "#") + "% ", color=color.new(C_LBL_BULL, 20), textcolor=C_TEXT_WHITE, style=label.style_label_left, size=cleanMode ? sz_tiny : sz_small)

    // v14 B10: structure trail SL after TP2 — pull SL to last internal high if lower than current SL
    if posTP2Hit and useStructTrail and not na(intLastHi) and intLastHi < posSL and intLastHi > close
        posSL := intLastHi

    if high >= posSL
        finalRealized = (posEntry - posSL) * posSizeRemaining
        totalRealized = posRealizedPnL + finalRealized
        totalPct = (totalRealized / posEntry) * 100
        _riskPerUnitS = math.abs(posEntry - posOrigSL)
        if _riskPerUnitS > 0
            dayRealizedR := dayRealizedR + (totalRealized / _riskPerUnitS)
        slColor = totalRealized >= 0 ? C_LBL_BULL : C_LBL_BEAR
        slIcon = totalRealized >= 0 ? "🛡️" : "🛑"
        if compactExitLabels
            label.new(bar_index, posSL, " " + slIcon + " " + str.tostring(totalPct, "#.##") + "% ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
        else
            label.new(bar_index, posSL, " " + slIcon + " SL " + str.tostring(totalPct, "#.##") + "% ", color=slColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)
        f_clearPositionViz()
        posDirection := 0
    else if low <= posTP3
        finalRealized = (posEntry - posTP3) * posSizeRemaining
        totalRealized = posRealizedPnL + finalRealized
        totalPct = (totalRealized / posEntry) * 100
        _riskPerUnitS = math.abs(posEntry - posOrigSL)
        if _riskPerUnitS > 0
            dayRealizedR := dayRealizedR + (totalRealized / _riskPerUnitS)
        if compactExitLabels
            label.new(bar_index, posTP3, " 🎯 " + str.tostring(totalPct, "#.##") + "% ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_small)
        else
            label.new(bar_index, posTP3, " 🎯 TP " + str.tostring(rrRatio, "#.#") + "R " + str.tostring(totalPct, "#.##") + "% ", color=C_LBL_BULL, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)
        f_clearPositionViz()
        posDirection := 0

// ═══════════════════════════════════════════════════════════════
// LIVE TRADE LINES — v11.1 Fix #5: State cache, only recreate on change
// ═══════════════════════════════════════════════════════════════
if showPositionLines and enablePositions and posDirection != 0 and barstate.islast
    rightX = bar_index + rightLabelOffset

    structuralChange = vizLastDir != posDirection or vizLastSL != posSL or vizLastTP1 != posTP1 or vizLastTP2 != posTP2 or vizLastTP3 != posTP3 or vizLastEntry != posEntry or vizLastTP1Hit != posTP1Hit or vizLastTP2Hit != posTP2Hit

    if structuralChange
        f_clearPositionViz()
        dirText = posDirection == 1 ? "LONG" : "SHORT"
        dirIcon = posDirection == 1 ? "▲" : "▼"
        dirColor = posDirection == 1 ? C_LBL_BULL : C_LBL_BEAR

        if shadeRRZones
            rewardBox := box.new(posOpenBar, posEntry, rightX, posTP3, bgcolor=color.new(C_BULL, 94), border_color=na)
            riskBox   := box.new(posOpenBar, posEntry, rightX, posSL,  bgcolor=color.new(C_BEAR, 94), border_color=na)

        posEntryLine := line.new(posOpenBar, posEntry, rightX, posEntry, color=C_BLUE, width=3)
        posEntryLbl  := label.new(rightX, posEntry, " ● ENTRY " + str.tostring(posEntry, format.mintick) + " (" + str.tostring(posSizeRemaining * 100, "#") + "%) ", color=C_BLUE, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_normal)

        // v13 M2: posTP1Hit indicates SL has been BE-moved (entry + buffer)
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

    // Right-edge follows the current bar — cheap to update
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

    // P&L label: always dynamic; mutate via set_*
    if showPnL
        dirText_pnl = posDirection == 1 ? "LONG" : "SHORT"
        dirIcon_pnl = posDirection == 1 ? "▲" : "▼"
        totalPct = trackRealizedPnL ? f_totalPnLPct(close) : (posDirection == 1 ? (close - posEntry) / posEntry * 100 : (posEntry - close) / posEntry * 100)
        rMultiple = trackRealizedPnL ? f_rMultiple(close) : (math.abs(posEntry - posOrigSL) > 0 ? (posDirection == 1 ? (close - posEntry) : (posEntry - close)) / math.abs(posEntry - posOrigSL) : 0)
        pnlColor = totalPct >= 0 ? C_LBL_BULL : C_LBL_BEAR
        pnlText = " " + dirIcon_pnl + " " + dirText_pnl + " ACTIVE \n P&L: " + str.tostring(totalPct, "#.##") + "% (" + str.tostring(rMultiple, "#.##") + "R) \n Size: " + str.tostring(posSizeRemaining * 100, "#") + "% | Realized: " + str.tostring((posRealizedPnL / posEntry) * 100, "#.##") + "% "

        if na(posPnLLbl)
            posPnLLbl := label.new(rightX, (posEntry + close) / 2, pnlText, color=pnlColor, textcolor=C_TEXT_WHITE, style=label.style_label_left, size=sz_large)
        else
            label.set_xy(posPnLLbl, rightX, (posEntry + close) / 2)
            label.set_text(posPnLLbl, pnlText)
            label.set_color(posPnLLbl, pnlColor)

// Reset viz cache when position closes
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

var table mtfTable = table.new(f_tablePos(tablePosition), 3, 13, bgcolor=C_BG_TABLE, border_width=1, border_color=C_BORDER_TBL, frame_color=C_GOLD, frame_width=2)

f_trendBadge(_t) => _t == 1 ? "▲ BULL" : _t == -1 ? "▼ BEAR" : "● NEUT"
f_trendBg(_t)    => _t == 1 ? C_LBL_BULL : _t == -1 ? C_LBL_BEAR : C_NEUTRAL

if showMTFTable and barstate.islast
    modeText = isMinimal ? "Minimal" : isTrading ? "Trading" : "Full"
    table.cell(mtfTable, 0, 0, " ⚡ SMC MASTER PRO ", text_color=C_GOLD, bgcolor=C_BG_HEADER, text_size=size.normal)
    table.cell(mtfTable, 1, 0, "", bgcolor=C_BG_HEADER)
    table.cell(mtfTable, 2, 0, " v14 " + modeText + " ", text_color=C_TEXT_WHITE, bgcolor=C_BG_HEADER, text_size=size.small)

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

    inPremium  = not na(lastSH) and not na(lastSL) and close > (lastSH + lastSL)/2
    inDiscount = not na(lastSH) and not na(lastSL) and close <= (lastSH + lastSL)/2
    zoneText = inPremium ? "▼ Premium" : inDiscount ? "▲ Discount" : "—"
    zoneBg = inPremium ? C_LBL_BEAR : inDiscount ? C_LBL_BULL : C_NEUTRAL
    table.cell(mtfTable, 0, 9, " 💎 PD Zone ", text_color=C_TEXT_MAIN, bgcolor=C_BG_TABLE, text_size=size.normal)
    table.cell(mtfTable, 1, 9, " Price ",    text_color=C_TEXT_MAIN, bgcolor=C_BG_TABLE, text_size=size.normal)
    table.cell(mtfTable, 2, 9, " " + zoneText + " ", text_color=C_TEXT_WHITE, bgcolor=zoneBg, text_size=size.normal)

    maxScore = maxScore_v12
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
        table.cell(mtfTable, 0, 12, " " + pnlIcon + " P&L ", text_color=C_TEXT_WHITE, bgcolor=pnlBg, text_size=size.normal)
        table.cell(mtfTable, 1, 12, " " + str.tostring(totalPct, "#.##") + "% ", text_color=C_TEXT_WHITE, bgcolor=pnlBg, text_size=size.normal)
        table.cell(mtfTable, 2, 12, " " + str.tostring(rMult, "#.##") + "R ", text_color=C_TEXT_WHITE, bgcolor=pnlBg, text_size=size.normal)
    else
        table.cell(mtfTable, 0, 12, " 💤 Awaiting ", text_color=C_TEXT_DIM, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)
        table.cell(mtfTable, 1, 12, " Signal ",     text_color=C_TEXT_DIM, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)
        table.cell(mtfTable, 2, 12, " — ",          text_color=C_TEXT_DIM, bgcolor=C_BG_TABLE_ALT, text_size=size.normal)

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
// v12 NEW ALERTS
alertcondition(priceInHTFBullFVG and not priceInHTFBullFVG[1], "HTF Bull POI Tap", "Price entered HTF bullish FVG")
alertcondition(priceInHTFBearFVG and not priceInHTFBearFVG[1], "HTF Bear POI Tap", "Price entered HTF bearish FVG")
alertcondition(amdLondonSweepHi, "AMD Bear Setup", "London swept Asia high — bearish AMD")
alertcondition(amdLondonSweepLo, "AMD Bull Setup", "London swept Asia low — bullish AMD")
alertcondition(turtleSoupBull, "Turtle Soup Bull", "False break below N-bar low")
alertcondition(turtleSoupBear, "Turtle Soup Bear", "False break above N-bar high")
alertcondition(bullLiqGrab, "Bull Liq Grab", "Bullish liquidity grabbed — bearish continuation")
alertcondition(bearLiqGrab, "Bear Liq Grab", "Bearish liquidity grabbed — bullish continuation")
