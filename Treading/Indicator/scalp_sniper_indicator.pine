//@version=6
// =============================================================================
// Scalp Sniper Confluence — Indicator (Forex 1m / 5m)
// =============================================================================
// Multi-factor confluence engine: SMC + ICT + Auto-Trendline + Gann Box + Fib.
// Signal fires when N of 5 modules agree (equal-weight, configurable).
//
// Companion file: scalp_sniper_strategy.pine (identical logic in strategy{} for backtest)
// Keep the block between SHARED START / SHARED END in sync across both files.
// =============================================================================
indicator("Scalp Sniper Confluence",
     shorttitle="SnipeScalp",
     overlay=true,
     max_lines_count=500,
     max_labels_count=500,
     max_boxes_count=500)

// =============================================================================
// === SHARED START ============================================================
// =============================================================================

// -----------------------------------------------------------------------------
// Inputs — Scoring
// -----------------------------------------------------------------------------
grpScore = "Scoring Engine"
minScore = input.int(3, "Min Score to Fire (of 5)", minval=1, maxval=5, group=grpScore,
     tooltip="Number of modules that must agree before a signal fires. 3 = balanced, 4 = sniper-only.")
wSMC  = input.float(1.0, "SMC weight",  minval=0, step=0.5, group=grpScore)
wICT  = input.float(1.0, "ICT weight",  minval=0, step=0.5, group=grpScore)
wTL   = input.float(1.0, "Trendline weight", minval=0, step=0.5, group=grpScore)
wGann = input.float(1.0, "Gann weight", minval=0, step=0.5, group=grpScore)
wFib  = input.float(1.0, "Fib weight",  minval=0, step=0.5, group=grpScore)

// -----------------------------------------------------------------------------
// Inputs — Risk
// -----------------------------------------------------------------------------
grpRisk = "Risk"
slPips = input.float(10.0, "Stop Loss (pips)", minval=1, step=0.5, group=grpRisk)
tpRR   = input.float(2.0,  "Take Profit (R multiple)", minval=0.1, step=0.1, group=grpRisk)

// -----------------------------------------------------------------------------
// Inputs — Sessions (ICT killzones, NY time)
// -----------------------------------------------------------------------------
grpSess = "Sessions (NY Time)"
useKillzone   = input.bool(true, "Restrict to Killzones", group=grpSess)
londonSession = input.session("0200-0500", "London Killzone", group=grpSess)
nySession     = input.session("0700-1000", "NY Killzone",     group=grpSess)
sessionTZ     = "America/New_York"

// -----------------------------------------------------------------------------
// Inputs — SMC
// -----------------------------------------------------------------------------
grpSMC = "SMC"
enSMC      = input.bool(true, "Enable SMC", group=grpSMC)
swingLen   = input.int(5,  "Swing pivot length", minval=2, group=grpSMC)
obLookback = input.int(50, "Order Block lookback bars", minval=10, group=grpSMC)
showOB     = input.bool(true, "Show Order Blocks", group=grpSMC)
showFVG    = input.bool(true, "Show FVG", group=grpSMC)

// -----------------------------------------------------------------------------
// Inputs — Trendline
// -----------------------------------------------------------------------------
grpTL = "Trendline"
enTL    = input.bool(true, "Enable Auto-Trendline", group=grpTL)
showTL  = input.bool(true, "Show Trendlines", group=grpTL)

// -----------------------------------------------------------------------------
// Inputs — Gann
// -----------------------------------------------------------------------------
grpGann = "Gann"
enGann      = input.bool(true, "Enable Gann Box", group=grpGann)
gannLookback = input.int(100, "Gann anchor lookback", minval=20, group=grpGann)
showGann    = input.bool(true, "Show Gann Box", group=grpGann)

// -----------------------------------------------------------------------------
// Inputs — Fib
// -----------------------------------------------------------------------------
grpFib = "Fibonacci"
enFib   = input.bool(true, "Enable Fib", group=grpFib)
showFib = input.bool(true, "Show Fib Levels", group=grpFib)

// -----------------------------------------------------------------------------
// Pip helpers (JPY pairs aware)
// -----------------------------------------------------------------------------
isJPY = str.contains(syminfo.ticker, "JPY")
pipSize = syminfo.mintick * (isJPY ? 100 : 10)

// -----------------------------------------------------------------------------
// Killzone gate
// -----------------------------------------------------------------------------
inLondon = not na(time(timeframe.period, londonSession, sessionTZ))
inNY     = not na(time(timeframe.period, nySession,     sessionTZ))
killzoneOK = not useKillzone or inLondon or inNY

// -----------------------------------------------------------------------------
// Pivots (shared across modules)
// -----------------------------------------------------------------------------
ph = ta.pivothigh(swingLen, swingLen)
pl = ta.pivotlow(swingLen, swingLen)

var float lastPH       = na
var float lastPL       = na
var int   lastPHBar    = na
var int   lastPLBar    = na
var float prevPH       = na
var float prevPL       = na
var int   prevPHBar    = na
var int   prevPLBar    = na

if not na(ph)
    prevPH    := lastPH
    prevPHBar := lastPHBar
    lastPH    := ph
    lastPHBar := bar_index - swingLen
if not na(pl)
    prevPL    := lastPL
    prevPLBar := lastPLBar
    lastPL    := pl
    lastPLBar := bar_index - swingLen

// =============================================================================
// Module 1 — SMC (Break of Structure, FVG, Order Blocks, Liquidity Sweep)
// =============================================================================
// Structure state machine
var int structureDir = 0   // +1 bullish, -1 bearish, 0 neutral
var bool bosBull = false
var bool bosBear = false
var bool chochBull = false
var bool chochBear = false

bosBull   := false
bosBear   := false
chochBull := false
chochBear := false

if not na(lastPH) and close > lastPH and close[1] <= lastPH
    if structureDir == -1
        chochBull := true
    else
        bosBull := true
    structureDir := 1

if not na(lastPL) and close < lastPL and close[1] >= lastPL
    if structureDir == 1
        chochBear := true
    else
        bosBear := true
    structureDir := -1

// FVG: 3-bar imbalance — gap between high[2] and low[0] (bullish) or low[2] and high[0] (bearish)
bullFVG = low > high[2]
bearFVG = high < low[2]

var array<box> fvgBoxes = array.new<box>()
maxFVG = 20

pushFVG(box b) =>
    array.push(fvgBoxes, b)
    if array.size(fvgBoxes) > maxFVG
        box.delete(array.shift(fvgBoxes))

if showFVG and enSMC
    if bullFVG
        pushFVG(box.new(bar_index[2], high[2], bar_index, low, border_color=color.new(color.green, 70), bgcolor=color.new(color.green, 85)))
    if bearFVG
        pushFVG(box.new(bar_index[2], low[2], bar_index, high, border_color=color.new(color.red, 70), bgcolor=color.new(color.red, 85)))

// Order Block: last opposite-color candle before impulsive break
var array<box> obBoxes = array.new<box>()
maxOB = 5

drawOB(int barIdx, float top, float bot, color c) =>
    b = box.new(barIdx, top, barIdx + obLookback, bot,
         border_color=c, bgcolor=color.new(c, 80), extend=extend.none)
    array.push(obBoxes, b)
    if array.size(obBoxes) > maxOB
        box.delete(array.shift(obBoxes))

if showOB and enSMC and bosBull and not na(lastPLBar)
    // bullish OB = last red candle before the BOS leg
    for i = 0 to math.min(bar_index - lastPLBar, 30)
        if close[i] < open[i]
            drawOB(bar_index - i, high[i], low[i], color.lime)
            break

if showOB and enSMC and bosBear and not na(lastPHBar)
    for i = 0 to math.min(bar_index - lastPHBar, 30)
        if close[i] > open[i]
            drawOB(bar_index - i, high[i], low[i], color.red)
            break

// Liquidity sweep
sweepHigh = not na(lastPH) and high > lastPH and close < lastPH
sweepLow  = not na(lastPL) and low  < lastPL and close > lastPL

smcBias = 0
if enSMC
    bullScore = (bosBull ? 1 : 0) + (chochBull ? 1 : 0) + (bullFVG ? 1 : 0) + (sweepLow  ? 1 : 0)
    bearScore = (bosBear ? 1 : 0) + (chochBear ? 1 : 0) + (bearFVG ? 1 : 0) + (sweepHigh ? 1 : 0)
    smcBias := bullScore > bearScore ? 1 : bearScore > bullScore ? -1 : 0

// =============================================================================
// Module 2 — ICT (Killzone + OTE retracement bias)
// =============================================================================
enICT = input.bool(true, "Enable ICT (OTE + Killzone)", group="ICT")

bool oteBullZone = false
bool oteBearZone = false
if enICT and not na(lastPL) and not na(lastPH)
    legRange = lastPH - lastPL
    if lastPHBar > lastPLBar
        oteBullTop = lastPH - legRange * 0.62
        oteBullBot = lastPH - legRange * 0.79
        oteBullZone := low <= oteBullTop and low >= oteBullBot and close > oteBullBot
    else
        oteBearBot = lastPL + legRange * 0.62
        oteBearTop = lastPL + legRange * 0.79
        oteBearZone := high >= oteBearBot and high <= oteBearTop and close < oteBearTop

ictBias = oteBullZone and killzoneOK ? 1 : oteBearZone and killzoneOK ? -1 : 0

// =============================================================================
// Module 3 — Auto Trendline
// =============================================================================
var line tlResistance = na
var line tlSupport    = na

if not na(ph) and not na(prevPH) and showTL and enTL
    line.delete(tlResistance)
    tlResistance := line.new(prevPHBar, prevPH, lastPHBar, lastPH,
         extend=extend.right, color=color.red, width=1)

if not na(pl) and not na(prevPL) and showTL and enTL
    line.delete(tlSupport)
    tlSupport := line.new(prevPLBar, prevPL, lastPLBar, lastPL,
         extend=extend.right, color=color.green, width=1)

int tlBias = 0
if enTL
    if not na(tlResistance)
        x1r = line.get_x1(tlResistance)
        y1r = line.get_y1(tlResistance)
        x2r = line.get_x2(tlResistance)
        y2r = line.get_y2(tlResistance)
        slopeR = (y2r - y1r) / math.max(x2r - x1r, 1)
        projR = y2r + slopeR * (bar_index - x2r)
        if close > projR and close[1] <= projR
            tlBias := 1
    if not na(tlSupport)
        x1s = line.get_x1(tlSupport)
        y1s = line.get_y1(tlSupport)
        x2s = line.get_x2(tlSupport)
        y2s = line.get_y2(tlSupport)
        slopeS = (y2s - y1s) / math.max(x2s - x1s, 1)
        projS = y2s + slopeS * (bar_index - x2s)
        if close < projS and close[1] >= projS
            tlBias := -1

// =============================================================================
// Module 4 — Gann Box (auto anchor: highest-high to lowest-low in lookback)
// =============================================================================
gannHigh = ta.highest(high, gannLookback)
gannLow  = ta.lowest(low,  gannLookback)
gannMid  = (gannHigh + gannLow) / 2
gannQ1   = gannLow + (gannHigh - gannLow) * 0.25
gannQ3   = gannLow + (gannHigh - gannLow) * 0.75

var line gLineHigh = na
var line gLineMid  = na
var line gLineLow  = na
var line gLineQ1   = na
var line gLineQ3   = na

if showGann and enGann and barstate.islast
    line.delete(gLineHigh)
    line.delete(gLineMid)
    line.delete(gLineLow)
    line.delete(gLineQ1)
    line.delete(gLineQ3)
    gLineHigh := line.new(bar_index - gannLookback, gannHigh, bar_index, gannHigh, extend=extend.right, color=color.new(color.orange, 30), width=1)
    gLineMid  := line.new(bar_index - gannLookback, gannMid,  bar_index, gannMid,  extend=extend.right, color=color.new(color.yellow, 30), width=2, style=line.style_dashed)
    gLineLow  := line.new(bar_index - gannLookback, gannLow,  bar_index, gannLow,  extend=extend.right, color=color.new(color.orange, 30), width=1)
    gLineQ1   := line.new(bar_index - gannLookback, gannQ1,   bar_index, gannQ1,   extend=extend.right, color=color.new(color.gray, 50), width=1, style=line.style_dotted)
    gLineQ3   := line.new(bar_index - gannLookback, gannQ3,   bar_index, gannQ3,   extend=extend.right, color=color.new(color.gray, 50), width=1, style=line.style_dotted)

gannBias = 0
if enGann
    // mean-revert from equilibrium 50%
    if low <= gannMid and close > gannMid and close[1] < gannMid
        gannBias := 1
    if high >= gannMid and close < gannMid and close[1] > gannMid
        gannBias := -1

// =============================================================================
// Module 5 — Fibonacci (auto on last impulse leg)
// =============================================================================
fibBias = 0
var float fibHi = na
var float fibLo = na
var int   fibDir = 0   // +1 leg up, -1 leg down

if not na(lastPH) and not na(lastPL)
    if lastPHBar > lastPLBar
        fibHi := lastPH
        fibLo := lastPL
        fibDir := 1
    else
        fibHi := lastPH
        fibLo := lastPL
        fibDir := -1

if enFib and not na(fibHi) and not na(fibLo)
    fibRange = fibHi - fibLo
    fib618 = fibDir == 1 ? fibHi - fibRange * 0.618 : fibLo + fibRange * 0.618
    fib705 = fibDir == 1 ? fibHi - fibRange * 0.705 : fibLo + fibRange * 0.705
    fib786 = fibDir == 1 ? fibHi - fibRange * 0.786 : fibLo + fibRange * 0.786
    inGolden = fibDir == 1 ? (low <= fib618 and low >= fib786 and close > fib786) : (high >= fib618 and high <= fib786 and close < fib786)
    fibBias := inGolden and fibDir ==  1 ?  1 : inGolden and fibDir == -1 ? -1 : 0

var line fibLine618 = na
var line fibLine705 = na
var line fibLine786 = na
if showFib and enFib and not na(fibHi) and not na(fibLo) and barstate.islast
    fibRange2 = fibHi - fibLo
    f618 = fibDir == 1 ? fibHi - fibRange2 * 0.618 : fibLo + fibRange2 * 0.618
    f705 = fibDir == 1 ? fibHi - fibRange2 * 0.705 : fibLo + fibRange2 * 0.705
    f786 = fibDir == 1 ? fibHi - fibRange2 * 0.786 : fibLo + fibRange2 * 0.786
    line.delete(fibLine618)
    line.delete(fibLine705)
    line.delete(fibLine786)
    anchor = math.min(lastPHBar, lastPLBar)
    fibLine618 := line.new(anchor, f618, bar_index, f618, extend=extend.right, color=color.new(color.aqua,    30), width=1)
    fibLine705 := line.new(anchor, f705, bar_index, f705, extend=extend.right, color=color.new(color.fuchsia, 30), width=2)
    fibLine786 := line.new(anchor, f786, bar_index, f786, extend=extend.right, color=color.new(color.aqua,    30), width=1)

// =============================================================================
// Scoring Engine
// =============================================================================
longScore  = (smcBias  ==  1 ? wSMC  : 0.0) + (ictBias  ==  1 ? wICT  : 0.0) + (tlBias  ==  1 ? wTL   : 0.0) + (gannBias ==  1 ? wGann : 0.0) + (fibBias  ==  1 ? wFib  : 0.0)
shortScore = (smcBias  == -1 ? wSMC  : 0.0) + (ictBias  == -1 ? wICT  : 0.0) + (tlBias  == -1 ? wTL   : 0.0) + (gannBias == -1 ? wGann : 0.0) + (fibBias  == -1 ? wFib  : 0.0)

longSignal  = longScore  >= minScore and killzoneOK
shortSignal = shortScore >= minScore and killzoneOK and not longSignal

// SL / TP
slDist = slPips * pipSize
longSL  = close - slDist
longTP  = close + slDist * tpRR
shortSL = close + slDist
shortTP = close - slDist * tpRR

// =============================================================================
// === SHARED END ==============================================================
// =============================================================================

// -----------------------------------------------------------------------------
// Plot entries + SL/TP labels (indicator-only — strategy uses strategy.entry)
// -----------------------------------------------------------------------------
plotshape(longSignal,  title="LONG",  style=shape.triangleup,   location=location.belowbar, color=color.lime, size=size.small, text="LONG")
plotshape(shortSignal, title="SHORT", style=shape.triangledown, location=location.abovebar, color=color.red,  size=size.small, text="SHORT")

var line longSLLine  = na
var line longTPLine  = na
var line shortSLLine = na
var line shortTPLine = na

if longSignal
    line.delete(longSLLine)
    line.delete(longTPLine)
    longSLLine := line.new(bar_index, longSL, bar_index + 30, longSL, color=color.red,  width=1, style=line.style_dashed)
    longTPLine := line.new(bar_index, longTP, bar_index + 30, longTP, color=color.lime, width=1, style=line.style_dashed)
    label.new(bar_index, longSL, "SL " + str.tostring(longSL, format.mintick), color=color.new(color.red,  80), textcolor=color.white, size=size.tiny, style=label.style_label_left)
    label.new(bar_index, longTP, "TP " + str.tostring(longTP, format.mintick), color=color.new(color.lime, 80), textcolor=color.white, size=size.tiny, style=label.style_label_left)

if shortSignal
    line.delete(shortSLLine)
    line.delete(shortTPLine)
    shortSLLine := line.new(bar_index, shortSL, bar_index + 30, shortSL, color=color.red,  width=1, style=line.style_dashed)
    shortTPLine := line.new(bar_index, shortTP, bar_index + 30, shortTP, color=color.lime, width=1, style=line.style_dashed)
    label.new(bar_index, shortSL, "SL " + str.tostring(shortSL, format.mintick), color=color.new(color.red,  80), textcolor=color.white, size=size.tiny, style=label.style_label_left)
    label.new(bar_index, shortTP, "TP " + str.tostring(shortTP, format.mintick), color=color.new(color.lime, 80), textcolor=color.white, size=size.tiny, style=label.style_label_left)

// -----------------------------------------------------------------------------
// Dashboard
// -----------------------------------------------------------------------------
var table dash = table.new(position.top_right, 2, 11, border_width=1)

biasCell(int v) =>
    v ==  1 ? color.new(color.green, 30) :
     v == -1 ? color.new(color.red,   30) :
              color.new(color.gray,  60)

biasText(int v) =>
    v ==  1 ? "BULL" : v == -1 ? "BEAR" : "—"

if barstate.islast
    table.cell(dash, 0, 0,  "Pair",       bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 0,  syminfo.ticker, bgcolor=color.new(color.black, 30), text_color=color.yellow)
    table.cell(dash, 0, 1,  "TF",         bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 1,  timeframe.period, bgcolor=color.new(color.black, 30), text_color=color.yellow)
    table.cell(dash, 0, 2,  "Killzone",   bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 2,  killzoneOK ? "ACTIVE" : "off", bgcolor=killzoneOK ? color.new(color.green, 40) : color.new(color.gray, 60), text_color=color.white)
    table.cell(dash, 0, 3,  "SMC",        bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 3,  biasText(smcBias),  bgcolor=biasCell(smcBias),  text_color=color.white)
    table.cell(dash, 0, 4,  "ICT",        bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 4,  biasText(ictBias),  bgcolor=biasCell(ictBias),  text_color=color.white)
    table.cell(dash, 0, 5,  "Trendline",  bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 5,  biasText(tlBias),   bgcolor=biasCell(tlBias),   text_color=color.white)
    table.cell(dash, 0, 6,  "Gann",       bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 6,  biasText(gannBias), bgcolor=biasCell(gannBias), text_color=color.white)
    table.cell(dash, 0, 7,  "Fib",        bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 7,  biasText(fibBias),  bgcolor=biasCell(fibBias),  text_color=color.white)
    table.cell(dash, 0, 8,  "Long Score", bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 8,  str.tostring(longScore,  "#.#") + " / " + str.tostring(minScore), bgcolor=longSignal ? color.new(color.green, 30) : color.new(color.gray, 60), text_color=color.white)
    table.cell(dash, 0, 9,  "Short Score",bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 9,  str.tostring(shortScore, "#.#") + " / " + str.tostring(minScore), bgcolor=shortSignal ? color.new(color.red,   30) : color.new(color.gray, 60), text_color=color.white)
    table.cell(dash, 0, 10, "Signal",     bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 10, longSignal ? "LONG ENTRY" : shortSignal ? "SHORT ENTRY" : "wait",
         bgcolor=longSignal ? color.new(color.green, 20) : shortSignal ? color.new(color.red, 20) : color.new(color.gray, 60),
         text_color=color.white)

// -----------------------------------------------------------------------------
// Alerts (webhook-ready JSON)
// -----------------------------------------------------------------------------
longMsg  = '{"action":"buy","symbol":"{{ticker}}","tf":"{{interval}}","price":{{close}},"sl":' + str.tostring(longSL, format.mintick)  + ',"tp":' + str.tostring(longTP, format.mintick)  + ',"score":' + str.tostring(longScore,  "#.#") + '}'
shortMsg = '{"action":"sell","symbol":"{{ticker}}","tf":"{{interval}}","price":{{close}},"sl":' + str.tostring(shortSL, format.mintick) + ',"tp":' + str.tostring(shortTP, format.mintick) + ',"score":' + str.tostring(shortScore, "#.#") + '}'

alertcondition(longSignal,  title="Scalp Sniper LONG",  message='{"action":"buy","symbol":"{{ticker}}","tf":"{{interval}}","price":{{close}}}')
alertcondition(shortSignal, title="Scalp Sniper SHORT", message='{"action":"sell","symbol":"{{ticker}}","tf":"{{interval}}","price":{{close}}}')

if longSignal
    alert(longMsg, alert.freq_once_per_bar_close)
if shortSignal
    alert(shortMsg, alert.freq_once_per_bar_close)
