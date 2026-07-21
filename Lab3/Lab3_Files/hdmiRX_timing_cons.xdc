## HDMI RX - TIMING constraints - PYNQ-Z2 (TUL)

## System clock (125 MHz on H16). Clock and port share the name "sysclk"
## (different namespaces: get_ports vs get_clocks - no ambiguity for the tool).
create_clock -add -name sysclk -period 8.00 -waveform {0 4} [get_ports { sysclk }]

## Recovered TMDS pixel clock from the incoming HDMI stream.
## 13.468 ns ~= 74.25 MHz (720p60). The commented line is for 1080p.
create_clock -period 13.468 -waveform {0.000 6.734} [get_ports TMDS_Clk_n_1]
#create_clock -period 9.259 -waveform {0.000 4.630} [get_ports TMDS_Clk_n_1]

## Asynchronous crossings: the incoming video clock is unrelated to the PS
## fabric clock; BTN0 reset is asynchronous. Declared as false paths.
set_false_path -from [get_ports async_reset_i]
set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks -of_objects [get_pins design_1_i/dvi2rgb_*/U0/TMDS_ClockingX/PixelClkBuffer/O]]
