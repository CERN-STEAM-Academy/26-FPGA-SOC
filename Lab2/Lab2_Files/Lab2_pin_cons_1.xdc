## Pin constraints for the PYNQ-Z2 board (TUL)

##Clock pin constraint to on board VCO
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sysclk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk

##RGB LEDs
set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { LED4_BLUE }]; #IO_L22N_T3_AD7N_35 Sch=LED4_BLUE
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { LED4_GREEN }]; #IO_L16P_T2_35 Sch=LED4_GREEN
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { LED4_RED }]; #IO_L21P_T3_DQS_AD14P_35 Sch=LED4_RED
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { LED5_BLUE }]; #IO_0_35 Sch=LED5_BLUE
set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { LED5_GREEN }]; #IO_L22P_T3_AD7P_35 Sch=LED5_GREEN
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { LED5_RED }]; #IO_L23N_T3_35 Sch=LED5_RED

##Buttons
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { btn0 }]; #IO_L4P_T0_35 Sch=btn[0]
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { btn1 }]; #IO_L4N_T0_35 Sch=btn[1]
set_property -dict { PACKAGE_PIN L20   IOSTANDARD LVCMOS33 } [get_ports { btn2 }]; #IO_L9N_T1_DQS_AD3N_35 Sch=btn[2]
##set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS33 } [get_ports { btn3 }]; #IO_L9P_T1_DQS_AD3P_35 Sch=btn[3]


##Switches
set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33 } [get_ports { LedOFF_0 }]; #IO_L7N_T1_AD2N_35 Sch=sw[0]
set_property -dict { PACKAGE_PIN M19   IOSTANDARD LVCMOS33 } [get_ports { LedOFF_1 }]; #IO_L7P_T1_AD2P_35 Sch=sw[1]