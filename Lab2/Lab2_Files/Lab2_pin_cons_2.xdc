## Pin constraints for the PYNQ-Z2 board (TUL)

##RGB LEDs
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { LED4_BLUE }]; #IO_L22N_T3_AD7N_35 Sch=LED4_BLUE
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { LED4_GREEN }]; #IO_L16P_T2_35 Sch=LED4_GREEN
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { LED4_RED }]; #IO_L21P_T3_DQS_AD14P_35 Sch=LED4_RED
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { LED5_BLUE }]; #IO_0_35 Sch=LED5_BLUE
set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { LED5_GREEN }]; #IO_L22P_T3_AD7P_35 Sch=LED5_GREEN
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { LED5_RED }]; #IO_L23N_T3_35 Sch=LED5_RED

