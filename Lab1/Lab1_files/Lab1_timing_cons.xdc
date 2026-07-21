## FPGA SoCs: Unleashing the Next Generation of Embedded Systems
## Timing constraints - PYNQ-Z2

## System clock, 125 MHz on pin H16.
## The clock is named "sysclk", same as the port: clocks and ports live in
## separate namespaces, so get_clocks/get_ports disambiguate (no conflict).
create_clock -add -name sysclk -period 8.00 -waveform {0 4} [get_ports { sysclk }];

## The IP logic (sysclk domain) and the AXI GPIO (PS clk_fpga_0 domain) only
## exchange quasi-static single-bit signals (button pulses, CH2 outputs),
## driven from software at ms scale. The two clocks are asynchronous and
## unrelated: declare them so, otherwise Vivado times these crossings against
## a meaningless 2 ns requirement and reports false setup violations.
set_clock_groups -asynchronous -group [get_clocks sysclk] -group [get_clocks clk_fpga_0]
