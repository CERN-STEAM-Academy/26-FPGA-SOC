## HDMI RX - PIN constraints - PYNQ-Z2 (TUL)

## Async reset (BTN0) and system clock
set_property -dict { PACKAGE_PIN D19  IOSTANDARD LVCMOS33 } [get_ports async_reset_i]
set_property -dict { PACKAGE_PIN H16  IOSTANDARD LVCMOS33 } [get_ports { sysclk }]; #Sch=sysclk

## HDMI RX - TMDS input (note the _1 suffix: input side, see instructions)
set_property -dict {PACKAGE_PIN P19 IOSTANDARD TMDS_33} [get_ports TMDS_Clk_n_1]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD TMDS_33} [get_ports TMDS_Clk_p_1]
set_property -dict {PACKAGE_PIN W20 IOSTANDARD TMDS_33} [get_ports {TMDS_Data_n_1[0]}]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD TMDS_33} [get_ports {TMDS_Data_p_1[0]}]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD TMDS_33} [get_ports {TMDS_Data_n_1[1]}]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD TMDS_33} [get_ports {TMDS_Data_p_1[1]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD TMDS_33} [get_ports {TMDS_Data_n_1[2]}]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD TMDS_33} [get_ports {TMDS_Data_p_1[2]}]

## Hot-plug detect (drive the source), DDC (EDID I2C to the source)
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports TMDS_hpd_o]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports DDC_0_scl_io]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports DDC_0_sda_io]

## Switches (effect selection)
set_property -dict { PACKAGE_PIN M20  IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #Sch=sw[0]
set_property -dict { PACKAGE_PIN M19  IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #Sch=sw[1]
