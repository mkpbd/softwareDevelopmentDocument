//@version=6
// =============================================================================
// Scalp Sniper Confluence — Strategy (backtest twin)
// =============================================================================
// Identical signal logic to scalp_sniper_indicator.pine but wired into
// strategy.entry / strategy.exit for win-rate, PF, DD stats.
//
// Keep the block between SHARED START / SHARED END in sync with the indicator.
// =============================================================================
strategy("Scalp Sniper Backtest",
     shorttitle="SnipeScalpBT",
     overlay=true,
     initial_capital=10000,
     default_qty_type=strategy.percent_of_equity,
     default_qty_value=2,
     pyramiding=0,
     commission_type=strategy.commission.percent,
     commission_value=0.002,
     slippage=2,
     max_lines_count=500,
     max_labels_count=500,
     max_boxes_count=500,
     process_orders_on_close=true,
     calc_on_every_tick=false)

// =============================================================================
// === SHARED START ============================================================
// =============================================================================

// -----------------------------------------------------------------------------
// Inputs — Scoring
// -----------------------------------------------------------------------------
grpScore = "Scoring Engine"
minScore = input.int(3, "Min Score to Fire (of 5)", minval=1, maxval=5, group=grpScore)
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
// Inputs — Sessions
// -----------------------------------------------------------------------------
grpSess = "Sessions (NY Time)"
useKillzone   = input.bool(true, "Restrict to Killzones", group=grpSess)
londonSession = input.session("0200-0500", "London Killzone", group=grpSess)
nySession     = input.session("0700-1000", "NY Killzone",     group=grpSess)
sessionTZ     = "America/New_York"

// -----------------------------------------------------------------------------
// Inputs — modules
// -----------------------------------------------------------------------------
grpSMC = "SMC"
enSMC      = input.bool(true, "Enable SMC", group=grpSMC)
swingLen   = input.int(5,  "Swing pivot length", minval=2, group=grpSMC)
obLookback = input.int(50, "Order Block lookback bars", minval=10, group=grpSMC)
showOB     = input.bool(true, "Show Order Blocks", group=grpSMC)
showFVG    = input.bool(true, "Show FVG", group=grpSMC)

enICT      = input.bool(true, "Enable ICT (OTE + Killzone)", group="ICT")

grpTL = "Trendline"
enTL    = input.bool(true, "Enable Auto-Trendline", group=grpTL)
showTL  = input.bool(true, "Show Trendlines", group=grpTL)

grpGann = "Gann"
enGann       = input.bool(true, "Enable Gann Box", group=grpGann)
gannLookback = input.int(100, "Gann anchor lookback", minval=20, group=grpGann)
showGann     = input.bool(true, "Show Gann Box", group=grpGann)

grpFib = "Fibonacci"
enFib   = input.bool(true, "Enable Fib", group=grpFib)
showFib = input.bool(true, "Show Fib Levels", group=grpFib)

// -----------------------------------------------------------------------------
// Pip math (JPY aware)
// -----------------------------------------------------------------------------
isJPY = str.contains(syminfo.ticker, "JPY")
pipSize = syminfo.mintick * (isJPY ? 100 : 10)

// -----------------------------------------------------------------------------
// Killzone
// -----------------------------------------------------------------------------
inLondon = not na(time(timeframe.period, londonSession, sessionTZ))
inNY     = not na(time(timeframe.period, nySession,     sessionTZ))
killzoneOK = not useKillzone or inLondon or inNY

// -----------------------------------------------------------------------------
// Pivots
// -----------------------------------------------------------------------------
ph = ta.pivothigh(swingLen, swingLen)
pl = ta.pivotlow(swingLen, swingLen)

var float lastPH    = na
var float lastPL    = na
var int   lastPHBar = na
var int   lastPLBar = na
var float prevPH    = na
var float prevPL    = na
var int   prevPHBar = na
var int   prevPLBar = na

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
// SMC
// =============================================================================
var int structureDir = 0
bool bosBull   = false
bool bosBear   = false
bool chochBull = false
bool chochBear = false

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

var array<box> obBoxes = array.new<box>()
maxOB = 5

drawOB(int barIdx, float top, float bot, color c) =>
    b = box.new(barIdx, top, barIdx + obLookback, bot,
         border_color=c, bgcolor=color.new(c, 80), extend=extend.none)
    array.push(obBoxes, b)
    if array.size(obBoxes) > maxOB
        box.delete(array.shift(obBoxes))

if showOB and enSMC and bosBull and not na(lastPLBar)
    for i = 0 to math.min(bar_index - lastPLBar, 30)
        if close[i] < open[i]
            drawOB(bar_index - i, high[i], low[i], color.lime)
            break

if showOB and enSMC and bosBear and not na(lastPHBar)
    for i = 0 to math.min(bar_index - lastPHBar, 30)
        if close[i] > open[i]
            drawOB(bar_index - i, high[i], low[i], color.red)
            break

sweepHigh = not na(lastPH) and high > lastPH and close < lastPH
sweepLow  = not na(lastPL) and low  < lastPL and close > lastPL

int smcBias = 0
if enSMC
    bullSc = (bosBull ? 1 : 0) + (chochBull ? 1 : 0) + (bullFVG ? 1 : 0) + (sweepLow  ? 1 : 0)
    bearSc = (bosBear ? 1 : 0) + (chochBear ? 1 : 0) + (bearFVG ? 1 : 0) + (sweepHigh ? 1 : 0)
    smcBias := bullSc > bearSc ? 1 : bearSc > bullSc ? -1 : 0

// =============================================================================
// ICT
// =============================================================================
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
// Trendline
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
// Gann
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

int gannBias = 0
if enGann
    if low <= gannMid and close > gannMid and close[1] < gannMid
        gannBias := 1
    if high >= gannMid and close < gannMid and close[1] > gannMid
        gannBias := -1

// =============================================================================
// Fib
// =============================================================================
int fibBias = 0
var float fibHi  = na
var float fibLo  = na
var int   fibDir = 0

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
    fib786 = fibDir == 1 ? fibHi - fibRange * 0.786 : fibLo + fibRange * 0.786
    inGolden = fibDir == 1 ? (low <= fib618 and low >= fib786 and close > fib786) : (high >= fib618 and high <= fib786 and close < fib786)
    fibBias := inGolden and fibDir ==  1 ?  1 : inGolden and fibDir == -1 ? -1 : 0

var line fibLine618 = na
var line fibLine786 = na
if showFib and enFib and not na(fibHi) and not na(fibLo) and barstate.islast
    fr = fibHi - fibLo
    f618 = fibDir == 1 ? fibHi - fr * 0.618 : fibLo + fr * 0.618
    f786 = fibDir == 1 ? fibHi - fr * 0.786 : fibLo + fr * 0.786
    line.delete(fibLine618)
    line.delete(fibLine786)
    anchor = math.min(lastPHBar, lastPLBar)
    fibLine618 := line.new(anchor, f618, bar_index, f618, extend=extend.right, color=color.new(color.aqua,    30), width=1)
    fibLine786 := line.new(anchor, f786, bar_index, f786, extend=extend.right, color=color.new(color.fuchsia, 30), width=2)

// =============================================================================
// Scoring
// =============================================================================
longScore  = (smcBias  ==  1 ? wSMC  : 0.0) + (ictBias  ==  1 ? wICT  : 0.0) + (tlBias  ==  1 ? wTL   : 0.0) + (gannBias ==  1 ? wGann : 0.0) + (fibBias  ==  1 ? wFib  : 0.0)
shortScore = (smcBias  == -1 ? wSMC  : 0.0) + (ictBias  == -1 ? wICT  : 0.0) + (tlBias  == -1 ? wTL   : 0.0) + (gannBias == -1 ? wGann : 0.0) + (fibBias  == -1 ? wFib  : 0.0)

longSignal  = longScore  >= minScore and killzoneOK
shortSignal = shortScore >= minScore and killzoneOK and not longSignal

slDist  = slPips * pipSize
longSL  = close - slDist
longTP  = close + slDist * tpRR
shortSL = close + slDist
shortTP = close - slDist * tpRR

// =============================================================================
// === SHARED END ==============================================================
// =============================================================================

// -----------------------------------------------------------------------------
// Strategy entries / exits
// -----------------------------------------------------------------------------
if longSignal and strategy.position_size == 0
    strategy.entry("LONG", strategy.long)
    strategy.exit("LONG-X", from_entry="LONG", stop=longSL, limit=longTP)

if shortSignal and strategy.position_size == 0
    strategy.entry("SHORT", strategy.short)
    strategy.exit("SHORT-X", from_entry="SHORT", stop=shortSL, limit=shortTP)

// -----------------------------------------------------------------------------
// Dashboard
// -----------------------------------------------------------------------------
var table dash = table.new(position.top_right, 2, 12, border_width=1)

biasCell(int v) =>
    v ==  1 ? color.new(color.green, 30) :
     v == -1 ? color.new(color.red,   30) :
              color.new(color.gray,  60)

biasText(int v) =>
    v ==  1 ? "BULL" : v == -1 ? "BEAR" : "—"

if barstate.islast
    table.cell(dash, 0, 0,  "Pair",        bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 0,  syminfo.ticker, bgcolor=color.new(color.black, 30), text_color=color.yellow)
    table.cell(dash, 0, 1,  "TF",          bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 1,  timeframe.period, bgcolor=color.new(color.black, 30), text_color=color.yellow)
    table.cell(dash, 0, 2,  "Killzone",    bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 2,  killzoneOK ? "ACTIVE" : "off", bgcolor=killzoneOK ? color.new(color.green, 40) : color.new(color.gray, 60), text_color=color.white)
    table.cell(dash, 0, 3,  "SMC",         bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 3,  biasText(smcBias),  bgcolor=biasCell(smcBias),  text_color=color.white)
    table.cell(dash, 0, 4,  "ICT",         bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 4,  biasText(ictBias),  bgcolor=biasCell(ictBias),  text_color=color.white)
    table.cell(dash, 0, 5,  "Trendline",   bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 5,  biasText(tlBias),   bgcolor=biasCell(tlBias),   text_color=color.white)
    table.cell(dash, 0, 6,  "Gann",        bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 6,  biasText(gannBias), bgcolor=biasCell(gannBias), text_color=color.white)
    table.cell(dash, 0, 7,  "Fib",         bgcolor=color.new(color.black, 60), text_color=color.white)
    table.cell(dash, 1, 7,  biasText(fibBias),  bgcolor=biasCell(fibBias),  text_color=color.white)
    table.cell(dash, 0, 8,  "Long Score",  bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 8,  str.tostring(longScore,  "#.#") + " / " + str.tostring(minScore), bgcolor=longSignal ? color.new(color.green, 30) : color.new(color.gray, 60), text_color=color.white)
    table.cell(dash, 0, 9,  "Short Score", bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 9,  str.tostring(shortScore, "#.#") + " / " + str.tostring(minScore), bgcolor=shortSignal ? color.new(color.red,   30) : color.new(color.gray, 60), text_color=color.white)
    table.cell(dash, 0, 10, "Position",    bgcolor=color.new(color.black, 30), text_color=color.white)
    posText = strategy.position_size > 0 ? "LONG x" + str.tostring(strategy.position_size, "#.##") : strategy.position_size < 0 ? "SHORT x" + str.tostring(math.abs(strategy.position_size), "#.##") : "flat"
    table.cell(dash, 1, 10, posText, bgcolor=strategy.position_size != 0 ? color.new(color.blue, 40) : color.new(color.gray, 60), text_color=color.white)
    table.cell(dash, 0, 11, "Net Profit",  bgcolor=color.new(color.black, 30), text_color=color.white)
    table.cell(dash, 1, 11, str.tostring(strategy.netprofit, "#.##"), bgcolor=strategy.netprofit >= 0 ? color.new(color.green, 30) : color.new(color.red, 30), text_color=color.white)
