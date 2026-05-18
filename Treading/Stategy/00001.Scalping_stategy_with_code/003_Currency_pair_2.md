


```python
//@version=5

indicator("Sniper Strategy Pro V2", overlay=true, max_bars_back=1000, max_lines_count=100, max_labels_count=100)

  

// ============================================================

// INPUTS

// ============================================================

  

ema9_len       = input.int(9,     "EMA 9 Length",       minval=1,              group="EMA")

ema21_len      = input.int(21,    "EMA 21 Length",      minval=1,              group="EMA")

ema50_len      = input.int(50,    "EMA 50 Length",      minval=1,              group="EMA")

rsi_len        = input.int(14,    "RSI Length",         minval=1,  maxval=50,  group="RSI")

rsi_bull_level = input.float(55,  "RSI Bull Level",     minval=50, maxval=80,  group="RSI")

rsi_bear_level = input.float(45,  "RSI Bear Level",     minval=20, maxval=50,  group="RSI")

rsi_ob         = input.float(70,  "RSI Overbought",     minval=60, maxval=90,  group="RSI")

rsi_os         = input.float(30,  "RSI Oversold",       minval=10, maxval=40,  group="RSI")

body_ratio_min = input.float(0.65,"Min Body Ratio",     minval=0.1,maxval=1.0, group="Candle")

liq_lookback   = input.int(10,    "Liquidity Lookback", minval=5,  maxval=50,  group="Candle")

engulf_factor  = input.float(1.0, "Engulf Factor",      minval=0.5,maxval=2.0, group="Candle")

atr_len        = input.int(14,    "ATR Length",         minval=1,              group="ATR")

sl_atr_mul     = input.float(1.5, "SL ATR Multiple",   minval=0.5,maxval=5.0, group="ATR")

tp_rr          = input.float(2.0, "TP Risk Reward",     minval=1.0,maxval=5.0, group="ATR")

use_session    = input.bool(true,  "Enable Session Filter",                    group="Session")

london_open    = input.session("0700-1200", "London Session",                  group="Session")

newyork_open   = input.session("1200-1700", "New York Session",                group="Session")

overlap_ses    = input.session("1200-1600", "London NY Overlap",               group="Session")

htf            = input.timeframe("5",  "Higher Timeframe",                     group="HTF")

htf2           = input.timeframe("15", "Confluence Timeframe",                 group="HTF")

use_htf2       = input.bool(true,  "Use Second HTF",                           group="HTF")

min_score      = input.int(7,     "Minimum Score",      minval=1,  maxval=13,  group="Score")

show_emas      = input.bool(true,  "Show EMAs",                                group="Display")

show_signals   = input.bool(true,  "Show Signals",                             group="Display")

show_score     = input.bool(true,  "Show Score Labels",                        group="Display")

show_sl_tp     = input.bool(true,  "Show SL TP Lines",                         group="Display")

show_dashboard = input.bool(true,  "Show Dashboard",                           group="Display")

show_div       = input.bool(true,  "Show RSI Divergence",                      group="Display")

show_liq       = input.bool(true,  "Show Liquidity Sweeps",                    group="Display")

show_session   = input.bool(true,  "Show Session Shading",                     group="Display")

  

// ============================================================

// CORE INDICATORS

// ============================================================

  

ema9  = ta.ema(close, ema9_len)

ema21 = ta.ema(close, ema21_len)

ema50 = ta.ema(close, ema50_len)

atr   = ta.atr(atr_len)

rsi   = ta.rsi(close, rsi_len)

atr_ma = ta.sma(atr, 20)

  

// ============================================================

// SESSION

// ============================================================

  

in_london  = not na(time(timeframe.period, london_open,  "UTC+1"))

in_newyork = not na(time(timeframe.period, newyork_open, "UTC-4"))

in_overlap = not na(time(timeframe.period, overlap_ses,  "UTC"))

in_session = use_session ? (in_london or in_newyork or in_overlap) : true

  

// ============================================================

// HIGHER TIMEFRAME

// ============================================================

  

[htf_e9, htf_e21, htf_e50]   = request.security(syminfo.tickerid, htf,  [ta.ema(close, ema9_len), ta.ema(close, ema21_len), ta.ema(close, ema50_len)], lookahead=barmerge.lookahead_off)

[htf2_e9, htf2_e21, htf2_e50] = request.security(syminfo.tickerid, htf2, [ta.ema(close, ema9_len), ta.ema(close, ema21_len), ta.ema(close, ema50_len)], lookahead=barmerge.lookahead_off)

  

htf_bull  = htf_e9  > htf_e21  and htf_e21  > htf_e50

htf_bear  = htf_e9  < htf_e21  and htf_e21  < htf_e50

htf2_bull = htf2_e9 > htf2_e21 and htf2_e21 > htf2_e50

htf2_bear = htf2_e9 < htf2_e21 and htf2_e21 < htf2_e50

  

// ============================================================

// EMA ALIGNMENT

// ============================================================

  

ema_bull = ema9 > ema21 and ema21 > ema50

ema_bear = ema9 < ema21 and ema21 < ema50

  

// ============================================================

// CANDLE MEASUREMENTS

// ============================================================

  

body       = math.abs(close - open)

candle_rng = high - low

safe_rng   = candle_rng < 1e-10 ? 1e-10 : candle_rng

body_pct   = body / safe_rng

uw_pct     = (high - math.max(close, open)) / safe_rng

lw_pct     = (math.min(close, open) - low)  / safe_rng

  

is_strong_bull = close > open and body_pct >= body_ratio_min and uw_pct < 0.2

is_strong_bear = close < open and body_pct >= body_ratio_min and lw_pct < 0.2

is_doji        = body_pct < 0.1

  

// ============================================================

// ENGULFING

// ============================================================

  

prev_body   = math.abs(close[1] - open[1])

bull_engulf = close > open and close[1] < open[1] and body >= prev_body * engulf_factor and close > open[1] and open < close[1]

bear_engulf = close < open and close[1] > open[1] and body >= prev_body * engulf_factor and close < open[1] and open > close[1]

  

// ============================================================

// EMA21 RETEST

// ============================================================

  

ema21_tol         = atr * 0.3

ema21_bull_reject = low[1]  <= ema21[1] + ema21_tol and low[1]  >= ema21[1] - ema21_tol and close > ema21

ema21_bear_reject = high[1] >= ema21[1] - ema21_tol and high[1] <= ema21[1] + ema21_tol and close < ema21

  

// ============================================================

// LIQUIDITY SWEEP

// ============================================================

  

liq_high       = ta.highest(high, liq_lookback)

liq_low        = ta.lowest(low,   liq_lookback)

bull_liq_sweep = low[1]  < liq_low[2]  and close[1] > liq_low[2]  and close[1] > open[1]

bear_liq_sweep = high[1] > liq_high[2] and close[1] < liq_high[2] and close[1] < open[1]

  

// ============================================================

// RSI DIVERGENCE

// ============================================================

  

piv_lb         = 5

price_piv_low  = ta.pivotlow(low,   piv_lb, piv_lb)

price_piv_high = ta.pivothigh(high,  piv_lb, piv_lb)

rsi_at_plow    = ta.valuewhen(not na(price_piv_low),  rsi,  0)

rsi_at_plow1   = ta.valuewhen(not na(price_piv_low),  rsi,  1)

p_at_plow      = ta.valuewhen(not na(price_piv_low),  low,  0)

p_at_plow1     = ta.valuewhen(not na(price_piv_low),  low,  1)

rsi_at_phigh   = ta.valuewhen(not na(price_piv_high), rsi,  0)

rsi_at_phigh1  = ta.valuewhen(not na(price_piv_high), rsi,  1)

p_at_phigh     = ta.valuewhen(not na(price_piv_high), high, 0)

p_at_phigh1    = ta.valuewhen(not na(price_piv_high), high, 1)

bull_div       = not na(price_piv_low)  and p_at_plow  < p_at_plow1  and rsi_at_plow  > rsi_at_plow1

bear_div       = not na(price_piv_high) and p_at_phigh > p_at_phigh1 and rsi_at_phigh < rsi_at_phigh1

  

// ============================================================

// FILTERS

// ============================================================

  

breaks_prev_high = close > high[1]

breaks_prev_low  = close < low[1]

atr_ok           = atr > atr_ma * 0.5 and atr < atr_ma * 3.0

  

// ============================================================

// SCORE ENGINE

// ============================================================

  

buy_score  = (ema_bull ? 2 : 0) + (rsi >= rsi_bull_level ? 1 : 0) + (bull_liq_sweep ? 2 : 0) + (is_strong_bull ? 2 : 0) + (htf_bull ? 2 : 0) + (use_htf2 and htf2_bull ? 1 : 0) + (bull_engulf ? 1 : 0) + (bull_div ? 1 : 0) + (ema21_bull_reject ? 1 : 0)

sell_score = (ema_bear ? 2 : 0) + (rsi <= rsi_bear_level ? 1 : 0) + (bear_liq_sweep ? 2 : 0) + (is_strong_bear ? 2 : 0) + (htf_bear ? 2 : 0) + (use_htf2 and htf2_bear ? 1 : 0) + (bear_engulf ? 1 : 0) + (bear_div ? 1 : 0) + (ema21_bear_reject ? 1 : 0)

  

// ============================================================

// SIGNALS

// ============================================================

  

buy_signal  = ema_bull and is_strong_bull and breaks_prev_high and rsi < rsi_ob and not is_doji and atr_ok and in_session and buy_score  >= min_score

sell_signal = ema_bear and is_strong_bear and breaks_prev_low  and rsi > rsi_os and not is_doji and atr_ok and in_session and sell_score >= min_score

  

// ============================================================

// SL / TP

// ============================================================

  

buy_sl  = low  - atr * sl_atr_mul

buy_tp  = close + (close - buy_sl)  * tp_rr

sell_sl = high + atr * sl_atr_mul

sell_tp = close - (sell_sl - close) * tp_rr

  

// ============================================================

// PLOTS

// ============================================================

  

ema9_plot  = plot(show_emas ? ema9  : na, "EMA 9",  color=color.new(color.yellow, 0), linewidth=1)

ema21_plot = plot(show_emas ? ema21 : na, "EMA 21", color=color.new(color.aqua,   0), linewidth=2)

ema50_plot = plot(show_emas ? ema50 : na, "EMA 50", color=color.new(color.orange, 0), linewidth=2)

fill(ema9_plot, ema21_plot, color=ema_bull ? color.new(color.green, 88) : ema_bear ? color.new(color.red, 88) : color.new(color.gray, 95), title="EMA Cloud")

  

barcolor(is_strong_bull and ema_bull ? color.new(color.lime, 40) : is_strong_bear and ema_bear ? color.new(color.red, 40) : na)

  

// ============================================================

// SHAPES

// ============================================================

  

plotshape(show_signals and buy_signal,                   title="BUY",         location=location.belowbar, style=shape.triangleup,   color=color.new(color.lime,    0), size=size.normal)

plotshape(show_signals and sell_signal,                  title="SELL",        location=location.abovebar, style=shape.triangledown,  color=color.new(color.red,     0), size=size.normal)

plotshape(show_signals and bull_engulf and ema_bull,     title="Bull Engulf", location=location.belowbar, style=shape.circle,        color=color.new(color.green,  30), size=size.tiny)

plotshape(show_signals and bear_engulf and ema_bear,     title="Bear Engulf", location=location.abovebar, style=shape.circle,        color=color.new(color.red,    30), size=size.tiny)

plotshape(show_liq     and bull_liq_sweep,               title="Bull Sweep",  location=location.belowbar, style=shape.xcross,        color=color.new(color.yellow, 20), size=size.tiny)

plotshape(show_liq     and bear_liq_sweep,               title="Bear Sweep",  location=location.abovebar, style=shape.xcross,        color=color.new(color.fuchsia,20), size=size.tiny)

plotshape(show_div     and bull_div,                     title="Bull Div",    location=location.belowbar, style=shape.labelup,       color=color.new(color.teal,   20), textcolor=color.white, text="D", size=size.tiny)

plotshape(show_div     and bear_div,                     title="Bear Div",    location=location.abovebar, style=shape.labeldown,     color=color.new(color.maroon, 20), textcolor=color.white, text="D", size=size.tiny)

  

// ============================================================

// SL TP LINES

// ============================================================

  

if show_sl_tp and buy_signal

    line.new(bar_index, buy_sl,  bar_index + 8, buy_sl,  color=color.new(color.red,   10), width=2, style=line.style_dashed)

    line.new(bar_index, buy_tp,  bar_index + 8, buy_tp,  color=color.new(color.green, 10), width=2, style=line.style_dashed)

    line.new(bar_index, close,   bar_index + 8, close,   color=color.new(color.gray,  40), width=1, style=line.style_dotted)

  

if show_sl_tp and sell_signal

    line.new(bar_index, sell_sl, bar_index + 8, sell_sl, color=color.new(color.red,   10), width=2, style=line.style_dashed)

    line.new(bar_index, sell_tp, bar_index + 8, sell_tp, color=color.new(color.green, 10), width=2, style=line.style_dashed)

    line.new(bar_index, close,   bar_index + 8, close,   color=color.new(color.gray,  40), width=1, style=line.style_dotted)

  

// ============================================================

// LABELS

// ============================================================

  

if show_score and buy_signal

    label.new(bar_index, buy_sl - atr * 0.5, "BUY\nScore:" + str.tostring(buy_score) + "/13\nSL:" + str.tostring(math.round(buy_sl, 5)) + "\nTP:" + str.tostring(math.round(buy_tp, 5)), color=color.new(color.green, 20), textcolor=color.white, style=label.style_label_up, size=size.small)

  

if show_score and sell_signal

    label.new(bar_index, sell_sl + atr * 0.5, "SELL\nScore:" + str.tostring(sell_score) + "/13\nSL:" + str.tostring(math.round(sell_sl, 5)) + "\nTP:" + str.tostring(math.round(sell_tp, 5)), color=color.new(color.red, 20), textcolor=color.white, style=label.style_label_down, size=size.small)

  

// ============================================================

// SESSION BACKGROUND

// ============================================================

  

bgcolor(show_session and in_london  ? color.new(color.blue,  95) : na, title="London")

bgcolor(show_session and in_newyork ? color.new(color.green, 95) : na, title="New York")

bgcolor(show_session and in_overlap ? color.new(color.teal,  90) : na, title="Overlap")

  

// ============================================================

// DASHBOARD

// ============================================================

  

var table dash = table.new(position.top_right, 3, 16, bgcolor=color.new(#0a0a1a, 15), border_width=1, border_color=color.new(color.gray, 55), frame_width=2, frame_color=color.new(color.gray, 30))

  

c_green_bg  = color.new(#003300, 25)

c_red_bg    = color.new(#330000, 25)

c_gray_bg   = color.new(#1a1a2e, 45)

c_header_bg = color.new(#0d0d3a, 15)

  

if barstate.islast and show_dashboard

    table.cell(dash, 0, 0,  "SNIPER PRO V2",                                                                                                                                                            bgcolor=c_header_bg,                                          text_color=color.white,  text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 0,  "BUY",                                                                                                                                                                      bgcolor=c_header_bg,                                          text_color=color.lime,   text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 0,  "SELL",                                                                                                                                                                      bgcolor=c_header_bg,                                          text_color=color.red,    text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 1,  "CONDITION",                                                                                                                                                                 bgcolor=c_header_bg,                                          text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 1,  "STATUS",                                                                                                                                                                    bgcolor=c_header_bg,                                          text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 1,  "STATUS",                                                                                                                                                                    bgcolor=c_header_bg,                                          text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 2,  "EMA Align (+2)",                                                                                                                                                            bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 2,  ema_bull ? "YES +2" : "NO 0",                                                                                                                                               bgcolor=ema_bull ? c_green_bg : c_gray_bg,                     text_color=ema_bull ? color.lime : color.gray,   text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 2,  ema_bear ? "YES +2" : "NO 0",                                                                                                                                               bgcolor=ema_bear ? c_red_bg   : c_gray_bg,                     text_color=ema_bear ? color.red  : color.gray,   text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 3,  "RSI " + str.tostring(math.round(rsi, 1)) + " (+1)",                                                                                                                        bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 3,  rsi >= rsi_bull_level ? "YES +1" : "NO 0",                                                                                                                                  bgcolor=rsi >= rsi_bull_level ? c_green_bg : c_gray_bg,       text_color=rsi >= rsi_bull_level ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 3,  rsi <= rsi_bear_level ? "YES +1" : "NO 0",                                                                                                                                  bgcolor=rsi <= rsi_bear_level ? c_red_bg   : c_gray_bg,       text_color=rsi <= rsi_bear_level ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 4,  "Liq Sweep (+2)",                                                                                                                                                           bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 4,  bull_liq_sweep ? "YES +2" : "NO 0",                                                                                                                                        bgcolor=bull_liq_sweep ? c_green_bg : c_gray_bg,              text_color=bull_liq_sweep ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 4,  bear_liq_sweep ? "YES +2" : "NO 0",                                                                                                                                        bgcolor=bear_liq_sweep ? c_red_bg   : c_gray_bg,              text_color=bear_liq_sweep ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 5,  "Strong Candle (+2)",                                                                                                                                                       bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 5,  is_strong_bull ? "YES +2" : "NO 0",                                                                                                                                        bgcolor=is_strong_bull ? c_green_bg : c_gray_bg,              text_color=is_strong_bull ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 5,  is_strong_bear ? "YES +2" : "NO 0",                                                                                                                                        bgcolor=is_strong_bear ? c_red_bg   : c_gray_bg,              text_color=is_strong_bear ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 6,  "HTF " + htf + " (+2)",                                                                                                                                                    bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 6,  htf_bull ? "YES +2" : "NO 0",                                                                                                                                              bgcolor=htf_bull ? c_green_bg : c_gray_bg,                    text_color=htf_bull ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 6,  htf_bear ? "YES +2" : "NO 0",                                                                                                                                              bgcolor=htf_bear ? c_red_bg   : c_gray_bg,                    text_color=htf_bear ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 7,  "HTF " + htf2 + " (+1)",                                                                                                                                                   bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 7,  use_htf2 and htf2_bull ? "YES +1" : "NO 0",                                                                                                                                bgcolor=use_htf2 and htf2_bull ? c_green_bg : c_gray_bg,      text_color=use_htf2 and htf2_bull ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 7,  use_htf2 and htf2_bear ? "YES +1" : "NO 0",                                                                                                                                bgcolor=use_htf2 and htf2_bear ? c_red_bg   : c_gray_bg,      text_color=use_htf2 and htf2_bear ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 8,  "Engulfing (+1)",                                                                                                                                                           bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 8,  bull_engulf ? "YES +1" : "NO 0",                                                                                                                                           bgcolor=bull_engulf ? c_green_bg : c_gray_bg,                 text_color=bull_engulf ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 8,  bear_engulf ? "YES +1" : "NO 0",                                                                                                                                           bgcolor=bear_engulf ? c_red_bg   : c_gray_bg,                 text_color=bear_engulf ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 9,  "RSI Div (+1)",                                                                                                                                                             bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 9,  bull_div ? "YES +1" : "NO 0",                                                                                                                                              bgcolor=bull_div ? c_green_bg : c_gray_bg,                    text_color=bull_div ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 9,  bear_div ? "YES +1" : "NO 0",                                                                                                                                              bgcolor=bear_div ? c_red_bg   : c_gray_bg,                    text_color=bear_div ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 10, "EMA21 Retest (+1)",                                                                                                                                                        bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 10, ema21_bull_reject ? "YES +1" : "NO 0",                                                                                                                                     bgcolor=ema21_bull_reject ? c_green_bg : c_gray_bg,           text_color=ema21_bull_reject ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 10, ema21_bear_reject ? "YES +1" : "NO 0",                                                                                                                                     bgcolor=ema21_bear_reject ? c_red_bg   : c_gray_bg,           text_color=ema21_bear_reject ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 11, "Session",                                                                                                                                                                  bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 11, in_session ? "ACTIVE" : "OFF",                                                                                                                                             bgcolor=in_session ? c_green_bg : c_gray_bg,                  text_color=in_session ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 11, in_session ? "ACTIVE" : "OFF",                                                                                                                                             bgcolor=in_session ? c_red_bg   : c_gray_bg,                  text_color=in_session ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 12, "Volatility",                                                                                                                                                               bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 12, atr_ok ? "OK" : "SKIP",                                                                                                                                                    bgcolor=atr_ok ? c_green_bg : c_gray_bg,                      text_color=atr_ok ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 12, atr_ok ? "OK" : "SKIP",                                                                                                                                                    bgcolor=atr_ok ? c_red_bg   : c_gray_bg,                      text_color=atr_ok ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 13, "No Doji",                                                                                                                                                                  bgcolor=c_gray_bg,                                            text_color=color.silver, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 13, not is_doji ? "CLEAN" : "DOJI",                                                                                                                                            bgcolor=not is_doji ? c_green_bg : c_gray_bg,                 text_color=not is_doji ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 13, not is_doji ? "CLEAN" : "DOJI",                                                                                                                                            bgcolor=not is_doji ? c_red_bg   : c_gray_bg,                 text_color=not is_doji ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 14, "SCORE / 13",                                                                                                                                                               bgcolor=c_header_bg,                                          text_color=color.white,  text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 14, str.tostring(buy_score)  + " / 13",                                                                                                                                        bgcolor=buy_score  >= min_score ? c_green_bg : c_gray_bg,     text_color=buy_score  >= min_score ? color.lime : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 14, str.tostring(sell_score) + " / 13",                                                                                                                                        bgcolor=sell_score >= min_score ? c_red_bg   : c_gray_bg,     text_color=sell_score >= min_score ? color.red  : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 0, 15, "SIGNAL",                                                                                                                                                                   bgcolor=c_header_bg,                                          text_color=color.white,  text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 1, 15, buy_signal  ? "BUY"  : "WAIT",                                                                                                                                             bgcolor=buy_signal  ? color.new(color.green, 10) : c_gray_bg, text_color=buy_signal  ? color.white : color.gray, text_size=size.small, text_halign=text.align_center)

    table.cell(dash, 2, 15, sell_signal ? "SELL" : "WAIT",                                                                                                                                             bgcolor=sell_signal ? color.new(color.red,   10) : c_gray_bg, text_color=sell_signal ? color.white : color.gray, text_size=size.small, text_halign=text.align_center)

  

// ============================================================

// ALERTS

// ============================================================

  

alertcondition(buy_signal,     title="BUY Signal",          message="BUY | {{ticker}} | {{interval}} | {{close}}")

alertcondition(sell_signal,    title="SELL Signal",         message="SELL | {{ticker}} | {{interval}} | {{close}}")

alertcondition(bull_liq_sweep, title="Bull Liquidity Sweep",message="Bull Sweep | {{ticker}} | {{close}}")

alertcondition(bear_liq_sweep, title="Bear Liquidity Sweep",message="Bear Sweep | {{ticker}} | {{close}}")

alertcondition(bull_div,       title="Bull RSI Divergence", message="Bull Div | {{ticker}} | {{close}}")

alertcondition(bear_div,       title="Bear RSI Divergence", message="Bear Div | {{ticker}} | {{close}}")
```




# Sniper Strategy Pro V2 — Complete Documentation

---

## Table of Contents

```
1. Strategy Overview
2. Indicator Components
3. Signal Logic
4. Score Engine
5. Risk Management
6. Session Filter
7. Dashboard Guide
8. Input Parameters
9. Alert System
10. How To Use
11. Troubleshooting
12. Disclaimer
```

---

# 1. Strategy Overview

```
┌─────────────────────────────────────────────────────┐
│           SNIPER STRATEGY PRO V2                    │
│                                                     │
│  Type        : Multi-Confirmation Entry System      │
│  Style       : Trend Following + Momentum           │
│  Timeframes  : M1 / M5 (primary)                   │
│  Best Pairs  : EURUSD  GBPUSD  XAUUSD  USDJPY      │
│  Score Max   : 13 Points                            │
│  Min Score   : 7 Points (configurable)              │
│  Risk Reward : 1:2 (default, configurable)          │
└─────────────────────────────────────────────────────┘
```

### What This Strategy Does

```
The Sniper Strategy Pro V2 is a rule-based confluence
system that combines:

  ✅ Trend direction    (EMA alignment)
  ✅ Momentum           (RSI + Strong Candle)
  ✅ Liquidity          (Sweep detection)
  ✅ Pattern            (Engulfing candles)
  ✅ Structure          (EMA21 retest)
  ✅ Divergence         (RSI pivot divergence)
  ✅ Multi-timeframe    (HTF confirmation)
  ✅ Session timing     (London / New York)
  ✅ Volatility filter  (ATR-based)

A trade signal is only generated when enough
conditions align to reach the minimum score.
```

---

# 2. Indicator Components

---

## 2.1 EMA — Exponential Moving Average

```
┌──────────┬──────────┬────────────────────────────────┐
│ EMA      │ Period   │ Role                           │
├──────────┼──────────┼────────────────────────────────┤
│ EMA 9    │ 9 bars   │ Fast trend / momentum line     │
│ EMA 21   │ 21 bars  │ Mid trend / retest zone        │
│ EMA 50   │ 50 bars  │ Slow trend / bias filter       │
└──────────┴──────────┴────────────────────────────────┘

Bullish Alignment : EMA9 > EMA21 > EMA50
Bearish Alignment : EMA9 < EMA21 < EMA50

EMA Cloud:
  Green fill between EMA9 and EMA21 = bullish bias
  Red   fill between EMA9 and EMA21 = bearish bias
```

---

## 2.2 RSI — Relative Strength Index

```
┌──────────────┬────────────────────────────────────┐
│ Setting      │ Value                              │
├──────────────┼────────────────────────────────────┤
│ Period       │ 14                                 │
│ Bull Level   │ 55 (momentum is bullish)           │
│ Bear Level   │ 45 (momentum is bearish)           │
│ Overbought   │ 70 (block buy signals above this)  │
│ Oversold     │ 30 (block sell signals below this) │
└──────────────┴────────────────────────────────────┘

Rules:
  BUY  signal blocked if RSI >= 70  (overbought)
  SELL signal blocked if RSI <= 30  (oversold)
  RSI >= 55 adds +1 to buy  score
  RSI <= 45 adds +1 to sell score
```

---

## 2.3 ATR — Average True Range

```
┌──────────────┬────────────────────────────────────┐
│ Setting      │ Value                              │
├──────────────┼────────────────────────────────────┤
│ Period       │ 14                                 │
│ SL Multiple  │ 1.5x ATR                          │
│ TP RR Ratio  │ 2.0 (1:2 Risk Reward)             │
└──────────────┴────────────────────────────────────┘

Used for:
  • Dynamic Stop Loss placement
  • Dynamic Take Profit calculation
  • EMA21 retest tolerance zone
  • Volatility filter (skip dead markets)
```

---

## 2.4 Candle Analysis

```
Body Ratio Formula:

  Body Ratio = Candle Body / Total Candle Range

  Candle Body  = | Close - Open |
  Total Range  = High - Low

Strong Candle Rules:
  ┌─────────────────────────────────────────┐
  │ Body Ratio  >= 0.65  (65% of range)     │
  │ Opposite Wick < 20% of range           │
  │ Not a Doji  (body > 10% of range)      │
  └─────────────────────────────────────────┘

Doji Filter:
  If Body Ratio < 0.10 = Doji = signal blocked
```

---

# 3. Signal Logic

---

## 3.1 BUY Signal — All Must Be True

```
┌────┬────────────────────────────────────────────────┐
│ #  │ Condition                                      │
├────┼────────────────────────────────────────────────┤
│ 1  │ EMA9 > EMA21 > EMA50   (bullish alignment)    │
│ 2  │ Current candle is strong bullish               │
│    │   body >= 65% of range                        │
│    │   upper wick < 20% of range                   │
│ 3  │ Close breaks above previous candle high        │
│ 4  │ RSI is below 70   (not overbought)            │
│ 5  │ Candle is not a Doji                          │
│ 6  │ ATR is within normal volatility range          │
│ 7  │ Current bar is in active trading session       │
│ 8  │ Buy score >= minimum score setting             │
└────┴────────────────────────────────────────────────┘
```

---

## 3.2 SELL Signal — All Must Be True

```
┌────┬────────────────────────────────────────────────┐
│ #  │ Condition                                      │
├────┼────────────────────────────────────────────────┤
│ 1  │ EMA9 < EMA21 < EMA50   (bearish alignment)    │
│ 2  │ Current candle is strong bearish               │
│    │   body >= 65% of range                        │
│    │   lower wick < 20% of range                   │
│ 3  │ Close breaks below previous candle low         │
│ 4  │ RSI is above 30   (not oversold)              │
│ 5  │ Candle is not a Doji                          │
│ 6  │ ATR is within normal volatility range          │
│ 7  │ Current bar is in active trading session       │
│ 8  │ Sell score >= minimum score setting            │
└────┴────────────────────────────────────────────────┘
```

---

## 3.3 Engulfing Pattern

```
Bullish Engulfing:
  Previous candle = bearish
  Current  candle = bullish
  Current body >= Previous body × Engulf Factor
  Current close  > Previous open
  Current open   < Previous close

Bearish Engulfing:
  Previous candle = bullish
  Current  candle = bearish
  Current body >= Previous body × Engulf Factor
  Current close  < Previous open
  Current open   > Previous close

Adds +1 to score when detected
Shown as small circle on chart
```

---

## 3.4 Liquidity Sweep

```
Bull Sweep (Fake Breakdown):
  Previous candle low  < Recent lowest low
  Previous candle close > that level  (closed back above)
  Previous candle closed bullish
  = Smart money swept stops below support then reversed

Bear Sweep (Fake Breakout):
  Previous candle high  > Recent highest high
  Previous candle close < that level  (closed back below)
  Previous candle closed bearish
  = Smart money swept stops above resistance then reversed

Lookback period = 10 bars (configurable)
Adds +2 to score when detected
Shown as X cross on chart
```

---

## 3.5 EMA21 Retest

```
Tolerance Zone = ATR × 0.3

Bull Retest:
  Previous candle low touched EMA21 ± tolerance
  Current candle closed above EMA21
  = Price pulled back to EMA21 and bounced up

Bear Retest:
  Previous candle high touched EMA21 ± tolerance
  Current candle closed below EMA21
  = Price pulled back to EMA21 and rejected down

Adds +1 to score when detected
Dynamic tolerance adjusts to market volatility
```

---

## 3.6 RSI Divergence

```
Uses pivot-based detection (5 bar lookback each side)

Bullish Divergence:
  Price makes lower low at pivot
  RSI  makes higher low at same pivot
  = Momentum not confirming lower price = reversal likely

Bearish Divergence:
  Price makes higher high at pivot
  RSI  makes lower high at same pivot
  = Momentum not confirming higher price = reversal likely

Adds +1 to score when detected
Shown as D label on chart
```

---

# 4. Score Engine

---

## 4.1 Full Score Table

```
┌────┬──────────────────────────┬────────┬──────────────────────┐
│ #  │ Condition                │ Points │ Notes                │
├────┼──────────────────────────┼────────┼──────────────────────┤
│ 1  │ EMA Alignment            │  +2    │ 9 > 21 > 50          │
│ 2  │ RSI Confirmation         │  +1    │ >55 bull / <45 bear  │
│ 3  │ Liquidity Sweep          │  +2    │ Fake break detected  │
│ 4  │ Strong Candle            │  +2    │ Body ratio >= 65%    │
│ 5  │ HTF1 Trend Match         │  +2    │ 5M default           │
│ 6  │ HTF2 Confluence          │  +1    │ 15M default          │
│ 7  │ Engulfing Pattern        │  +1    │ Full body engulf     │
│ 8  │ RSI Divergence           │  +1    │ Pivot-based          │
│ 9  │ EMA21 Retest             │  +1    │ ATR tolerance zone   │
├────┼──────────────────────────┼────────┼──────────────────────┤
│    │ MAXIMUM SCORE            │  13    │                      │
│    │ DEFAULT MINIMUM          │   7    │ Configurable 1-13    │
└────┴──────────────────────────┴────────┴──────────────────────┘
```

---

## 4.2 Score Interpretation

```
┌──────────────┬────────────────────────────────────────┐
│ Score        │ Signal Quality                         │
├──────────────┼────────────────────────────────────────┤
│ 11 — 13      │ ELITE    — Very high confluence        │
│  9 — 10      │ STRONG   — High probability setup      │
│  7 —  8      │ VALID    — Minimum tradeable signal    │
│  5 —  6      │ WEAK     — Skip this trade             │
│  1 —  4      │ NOISE    — Do not trade                │
└──────────────┴────────────────────────────────────────┘
```

---

# 5. Risk Management

---

## 5.1 Stop Loss Calculation

```
BUY Stop Loss:
  SL = Candle Low − (ATR × SL Multiple)
  Default : SL = Low − (ATR × 1.5)

SELL Stop Loss:
  SL = Candle High + (ATR × SL Multiple)
  Default : SL = High + (ATR × 1.5)

Why ATR-based:
  Adapts to current volatility
  Wider SL in volatile markets
  Tighter SL in calm markets
  Avoids premature stop outs
```

---

## 5.2 Take Profit Calculation

```
BUY Take Profit:
  Risk   = Entry − Stop Loss
  TP     = Entry + (Risk × RR Ratio)
  Default: Entry + (Risk × 2.0)

SELL Take Profit:
  Risk   = Stop Loss − Entry
  TP     = Entry − (Risk × RR Ratio)
  Default: Entry − (Risk × 2.0)

Risk Reward Options:
  Conservative  : 1.5 RR
  Default       : 2.0 RR
  Aggressive    : 3.0 RR
```

---

## 5.3 Position Sizing Guide

```
Account Risk Per Trade = 1% to 2% maximum

Formula:
  Position Size = (Account × Risk%) / (SL in pips × Pip Value)

Example:
  Account      = $1000
  Risk         = 1%  = $10
  SL           = 10 pips
  Pip Value    = $1 per pip (standard lot)

  Position Size = $10 / (10 × $1) = 1 mini lot

Daily Loss Rules:
  Maximum 3 losing trades per day then stop
  Never martingale or double positions
  Never risk more than 5% total per day
```

---

# 6. Session Filter

---

## 6.1 Trading Sessions

```
┌─────────────────┬────────────────┬──────────────────────┐
│ Session         │ Time (UTC)     │ Chart Color          │
├─────────────────┼────────────────┼──────────────────────┤
│ London Open     │ 07:00 - 12:00  │ Light Blue           │
│ New York Open   │ 12:00 - 17:00  │ Light Green          │
│ London/NY Ovrlp │ 12:00 - 16:00  │ Light Teal           │
└─────────────────┴────────────────┴──────────────────────┘

Sessions use UTC offset per region
London  : UTC+1
New York: UTC-4

Highest probability windows:
  London Open     08:00 - 10:00 local
  NY Open         13:00 - 15:00 local
  Overlap         13:00 - 16:00 local
```

---

## 6.2 Avoid These Times

```
  ❌ Asian session (low volatility, choppy)
  ❌ Sunday open  (thin liquidity)
  ❌ Friday close (position squaring)
  ❌ 5 minutes before high-impact news
  ❌ 5 minutes after  high-impact news
  ❌ Major holidays
```

---

# 7. Dashboard Guide

---

## 7.1 Dashboard Layout

```
┌─────────────────────┬───────────┬───────────┐
│  SNIPER PRO V2      │    BUY    │   SELL    │
├─────────────────────┼───────────┼───────────┤
│  CONDITION          │  STATUS   │  STATUS   │
├─────────────────────┼───────────┼───────────┤
│  EMA Align    (+2)  │  YES +2   │  NO  0    │
│  RSI 58.3     (+1)  │  YES +1   │  NO  0    │
│  Liq Sweep    (+2)  │  NO  0    │  NO  0    │
│  Strong Candle(+2)  │  YES +2   │  NO  0    │
│  HTF 5        (+2)  │  YES +2   │  NO  0    │
│  HTF 15       (+1)  │  YES +1   │  NO  0    │
│  Engulfing    (+1)  │  NO  0    │  NO  0    │
│  RSI Div      (+1)  │  NO  0    │  NO  0    │
│  EMA21 Retest (+1)  │  YES +1   │  NO  0    │
│  Session            │  ACTIVE   │  ACTIVE   │
│  Volatility         │  OK       │  OK       │
│  No Doji            │  CLEAN    │  CLEAN    │
├─────────────────────┼───────────┼───────────┤
│  SCORE / 13         │  9 / 13   │  0 / 13   │
│  SIGNAL             │   BUY     │   WAIT    │
└─────────────────────┴───────────┴───────────┘
```

---

## 7.2 Dashboard Cell Colors

```
┌────────────────┬──────────────────────────────────┐
│ Color          │ Meaning                          │
├────────────────┼──────────────────────────────────┤
│ Green cell     │ Buy condition is met             │
│ Red cell       │ Sell condition is met            │
│ Dark gray cell │ Condition not met                │
│ Dark blue cell │ Header / label row               │
│ White text     │ Final signal row                 │
│ Lime text      │ Bullish condition active         │
│ Red text       │ Bearish condition active         │
│ Gray text      │ Condition inactive               │
└────────────────┴──────────────────────────────────┘
```

---

# 8. Input Parameters

---

## 8.1 Full Parameter Reference

```
┌──────────────────────┬──────────┬────────┬────────┬──────────────────────────────┐
│ Parameter            │ Default  │ Min    │ Max    │ Description                  │
├──────────────────────┼──────────┼────────┼────────┼──────────────────────────────┤
│ EMA GROUP            │          │        │        │                              │
│  EMA 9 Length        │ 9        │ 1      │ —      │ Fast EMA period              │
│  EMA 21 Length       │ 21       │ 1      │ —      │ Mid EMA period               │
│  EMA 50 Length       │ 50       │ 1      │ —      │ Slow EMA period              │
├──────────────────────┼──────────┼────────┼────────┼──────────────────────────────┤
│ RSI GROUP            │          │        │        │                              │
│  RSI Length          │ 14       │ 1      │ 50     │ RSI calculation period       │
│  RSI Bull Level      │ 55       │ 50     │ 80     │ Min RSI for buy score        │
│  RSI Bear Level      │ 45       │ 20     │ 50     │ Max RSI for sell score       │
│  RSI Overbought      │ 70       │ 60     │ 90     │ Blocks buy signals           │
│  RSI Oversold        │ 30       │ 10     │ 40     │ Blocks sell signals          │
├──────────────────────┼──────────┼────────┼────────┼──────────────────────────────┤
│ CANDLE GROUP         │          │        │        │                              │
│  Min Body Ratio      │ 0.65     │ 0.10   │ 1.00   │ Min body as % of range       │
│  Liquidity Lookback  │ 10       │ 5      │ 50     │ Bars to find sweep levels    │
│  Engulf Factor       │ 1.0      │ 0.50   │ 2.00   │ How much engulf needed       │
├──────────────────────┼──────────┼────────┼────────┼──────────────────────────────┤
│ ATR GROUP            │          │        │        │                              │
│  ATR Length          │ 14       │ 1      │ —      │ ATR calculation period       │
│  SL ATR Multiple     │ 1.5      │ 0.5    │ 5.0    │ SL distance in ATR units     │
│  TP Risk Reward      │ 2.0      │ 1.0    │ 5.0    │ TP as multiple of SL risk    │
├──────────────────────┼──────────┼────────┼────────┼──────────────────────────────┤
│ SESSION GROUP        │          │        │        │                              │
│  Enable Session      │ true     │ —      │ —      │ Filter by trading session    │
│  London Session      │ 0700-1200│ —      │ —      │ UTC+1 London hours           │
│  New York Session    │ 1200-1700│ —      │ —      │ UTC-4 NY hours               │
│  London NY Overlap   │ 1200-1600│ —      │ —      │ Peak liquidity window        │
├──────────────────────┼──────────┼────────┼────────┼──────────────────────────────┤
│ HTF GROUP            │          │        │        │                              │
│  Higher Timeframe    │ 5        │ —      │ —      │ Primary HTF confirmation     │
│  Confluence TF       │ 15       │ —      │ —      │ Secondary HTF confluence     │
│  Use Second HTF      │ true     │ —      │ —      │ Enable HTF2 score point      │
├──────────────────────┼──────────┼────────┼────────┼──────────────────────────────┤
│ SCORE GROUP          │          │        │        │                              │
│  Minimum Score       │ 7        │ 1      │ 13     │ Score required for signal    │
├──────────────────────┼──────────┼────────┼────────┼──────────────────────────────┤
│ DISPLAY GROUP        │          │        │        │                              │
│  Show EMAs           │ true     │ —      │ —      │ Toggle EMA lines             │
│  Show Signals        │ true     │ —      │ —      │ Toggle arrows + markers      │
│  Show Score Labels   │ true     │ —      │ —      │ Toggle signal labels         │
│  Show SL TP Lines    │ true     │ —      │ —      │ Toggle risk lines            │
│  Show Dashboard      │ true     │ —      │ —      │ Toggle info table            │
│  Show RSI Divergence │ true     │ —      │ —      │ Toggle D markers             │
│  Show Liq Sweeps     │ true     │ —      │ —      │ Toggle sweep markers         │
│  Show Session Shading│ true     │ —      │ —      │ Toggle background colors     │
└──────────────────────┴──────────┴────────┴────────┴──────────────────────────────┘
```

---

# 9. Alert System

---

## 9.1 Available Alerts

```
┌────┬──────────────────────────┬──────────────────────────────────────┐
│ #  │ Alert Name               │ Trigger                              │
├────┼──────────────────────────┼──────────────────────────────────────┤
│ 1  │ BUY Signal               │ Full buy signal confirmed            │
│ 2  │ SELL Signal              │ Full sell signal confirmed           │
│ 3  │ Bull Liquidity Sweep     │ Bullish sweep detected               │
│ 4  │ Bear Liquidity Sweep     │ Bearish sweep detected               │
│ 5  │ Bull RSI Divergence      │ Bullish divergence at pivot          │
│ 6  │ Bear RSI Divergence      │ Bearish divergence at pivot          │
└────┴──────────────────────────┴──────────────────────────────────────┘
```

---

## 9.2 How To Set Up Alerts

```
Step 1 : Add indicator to chart
Step 2 : Click the Alert button (clock icon) in TradingView
Step 3 : Set Condition = Sniper Strategy Pro V2
Step 4 : Choose alert type from dropdown
Step 5 : Set notification method
           Email
           Push notification
           Webhook
           Popup
Step 6 : Click Create
```

---

## 9.3 Alert Message Format

```
BUY  Alert : "BUY  | EURUSD | 5 | 1.08542"
SELL Alert : "SELL | EURUSD | 5 | 1.08321"

Variables used:
  {{ticker}}   = Symbol name
  {{interval}} = Chart timeframe
  {{close}}    = Current close price
```

---

# 10. How To Use

---

## 10.1 Setup Steps

```
┌────┬──────────────────────────────────────────────────┐
│ 1  │ Open TradingView                                 │
│ 2  │ Open Pine Script Editor (bottom panel)           │
│ 3  │ Delete all existing code                         │
│ 4  │ Paste full Sniper Pro V2 script                  │
│ 5  │ Click Save                                       │
│ 6  │ Click Add to Chart                               │
│ 7  │ Set chart timeframe to M1 or M5                  │
│ 8  │ Set HTF input to M5 or M15                       │
│ 9  │ Set HTF2 input to M15 or M30                     │
│ 10 │ Set minimum score to 7                           │
│ 11 │ Configure alerts as needed                       │
└────┴──────────────────────────────────────────────────┘
```

---

## 10.2 Recommended Timeframe Combinations

```
┌──────────────┬──────┬───────┬─────────────────────────┐
│ Chart TF     │ HTF1 │ HTF2  │ Best For                │
├──────────────┼──────┼───────┼─────────────────────────┤
│ M1           │ M5   │ M15   │ Scalping                │
│ M5           │ M15  │ H1    │ Short intraday          │
│ M15          │ H1   │ H4    │ Intraday swing          │
│ H1           │ H4   │ D1    │ Swing trading           │
└──────────────┴──────┴───────┴─────────────────────────┘
```

---

## 10.3 Step By Step Trade Execution

```
PRE-TRADE CHECKLIST
───────────────────
  □ Check HTF1 and HTF2 trend direction
  □ Are we in London or New York session?
  □ Check economic calendar for news events
  □ Is ATR volatility normal? (not too low/high)

ENTRY CHECKLIST
───────────────
  □ Dashboard score >= 7
  □ EMA alignment confirmed
  □ Liquidity sweep on previous candle?
  □ Strong engulfing candle formed?
  □ RSI not overbought / oversold?
  □ Signal arrow appeared?

TRADE MANAGEMENT
────────────────
  □ Enter at candle close
  □ Set SL at level shown on chart
  □ Set TP at level shown on chart
  □ Do not move SL against position
  □ Optional: close 50% at 1:1, let rest run
```

---

## 10.4 Chart Visual Guide

```
Signal Markers:
  ▲ Green triangle below bar  = BUY  signal
  ▼ Red   triangle above bar  = SELL signal
  ● Green circle below bar    = Bull engulfing
  ● Red   circle above bar    = Bear engulfing
  ✕ Yellow cross below bar    = Bull liq sweep
  ✕ Pink   cross above bar    = Bear liq sweep
  D Teal  label below bar     = Bull divergence
  D Maroon label above bar    = Bear divergence

Lines on Signal Bar:
  Green dashed line = Take Profit level
  Red   dashed line = Stop Loss level
  Gray  dotted line = Entry price level

Bar Colors:
  Bright lime bar  = Strong bull candle in uptrend
  Bright red  bar  = Strong bear candle in downtrend

EMA Lines:
  Yellow line  = EMA 9  (fastest)
  Aqua line    = EMA 21 (mid)
  Orange line  = EMA 50 (slowest)
  Green cloud  = Bullish EMA bias
  Red   cloud  = Bearish EMA bias

Background Colors:
  Light blue  = London session active
  Light green = New York session active
  Light teal  = London/NY overlap active
```

---

# 11. Troubleshooting

```
┌──────────────────────────────────┬───────────────────────────────────────┐
│ Problem                          │ Solution                              │
├──────────────────────────────────┼───────────────────────────────────────┤
│ No signals appearing             │ Lower minimum score to 5 or 6         │
│                                  │ Check session filter is not blocking  │
│                                  │ Verify chart TF matches HTF settings  │
├──────────────────────────────────┼───────────────────────────────────────┤
│ Too many signals                 │ Raise minimum score to 9 or 10        │
│                                  │ Enable session filter                 │
│                                  │ Raise body ratio to 0.70              │
├──────────────────────────────────┼───────────────────────────────────────┤
│ Dashboard not showing            │ Toggle Show Dashboard input to true   │
├──────────────────────────────────┼───────────────────────────────────────┤
│ Signals in wrong direction       │ Check HTF trend direction first       │
│                                  │ Ensure EMA alignment is correct       │
├──────────────────────────────────┼───────────────────────────────────────┤
│ SL too wide                      │ Reduce SL ATR Multiple to 1.0         │
├──────────────────────────────────┼───────────────────────────────────────┤
│ SL too tight                     │ Increase SL ATR Multiple to 2.0       │
├──────────────────────────────────┼───────────────────────────────────────┤
│ Script runs slow                 │ Reduce max_bars_back to 500           │
│                                  │ Disable unused display toggles        │
├──────────────────────────────────┼───────────────────────────────────────┤
│ Syntax error on paste            │ Paste into a fresh blank Pine editor  │
│                                  │ Ensure version tag is v5              │
└──────────────────────────────────┴───────────────────────────────────────┘
```

---

# 12. Disclaimer

```
╔══════════════════════════════════════════════════════════════╗
║                      IMPORTANT NOTICE                       ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  This script is provided for EDUCATIONAL purposes only.      ║
║                                                              ║
║  • Past performance does not guarantee future results        ║
║  • No trading system wins 100% of the time                   ║
║  • Forex and Gold trading involves significant risk          ║
║  • You can lose more than your initial investment            ║
║  • Always test on a DEMO account before going live           ║
║  • Always use proper position sizing and risk management      ║
║  • Never trade with money you cannot afford to lose          ║
║  • The authors accept no liability for trading losses        ║
║                                                              ║
║  ALWAYS backtest minimum 200 signals before live use         ║
║  ALWAYS forward test on demo for minimum 2 weeks             ║
║  ALWAYS follow your own trading plan and rules               ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Quick Reference Card

```
┌──────────────────────────────────────────────────────────────┐
│              SNIPER PRO V2 — QUICK REFERENCE                 │
├──────────────────┬───────────────────────────────────────────┤
│ Best Pairs       │ EURUSD  GBPUSD  XAUUSD  USDJPY           │
│ Best TF          │ M1  M5                                    │
│ HTF Setting      │ M5 / M15                                  │
│ Min Score        │ 7 out of 13                               │
│ Max Score        │ 13                                        │
│ Default SL       │ ATR × 1.5                                 │
│ Default TP       │ SL Risk × 2.0                             │
│ Session          │ London + New York + Overlap               │
│ Risk Per Trade   │ 1% to 2% of account                       │
│ Max Daily Loss   │ 3 losing trades then stop                 │
├──────────────────┴───────────────────────────────────────────┤
│ BUY  = Green Triangle ▲  below candle                       │
│ SELL = Red   Triangle ▼  above candle                       │
│ Green dashed = Take Profit                                   │
│ Red   dashed = Stop Loss                                     │
└──────────────────────────────────────────────────────────────┘
```