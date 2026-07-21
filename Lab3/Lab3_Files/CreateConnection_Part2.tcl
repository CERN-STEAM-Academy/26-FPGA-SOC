make_bd_intf_pins_external  [get_bd_intf_pins dvi2rgb_*/DDC]
connect_bd_net [get_bd_pins dvi2rgb_*/PixelClk] [get_bd_pins rgb2dvi_*/PixelClk] [get_bd_pins VideoProcessing*/clk_pix]
delete_bd_objs [get_bd_nets TMDS_Clk_p_1_1] [get_bd_ports TMDS_Clk_p_1]
delete_bd_objs [get_bd_nets TMDS_Clk_n_1_1] [get_bd_ports TMDS_Clk_n_1]
create_bd_port -dir I TMDS_Clk_p_1
connect_bd_net [get_bd_pins /dvi2rgb_0/TMDS_Clk_p] [get_bd_ports TMDS_Clk_p_1]
create_bd_port -dir I TMDS_Clk_n_1
connect_bd_net [get_bd_pins /dvi2rgb_0/TMDS_Clk_n] [get_bd_ports TMDS_Clk_n_1]

set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
set TMDS_hpd_o [ create_bd_port -dir O -from 0 -to 0 TMDS_hpd_o ]
connect_bd_net -net xlconstant_0_dout [get_bd_ports TMDS_hpd_o] [get_bd_pins xlconstant_0/dout]

set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
 set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_1
connect_bd_net -net xlconstant_1_dout [get_bd_pins dvi2rgb_*/pRst] [get_bd_pins xlconstant_1/dout]

# Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {109.241} \
   CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {5} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_IN_FREQ {125.000} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0
set sysclk [ create_bd_port -dir I -type clk sysclk ]
set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $sysclk
connect_bd_net -net clk_in1_0_1 [get_bd_ports sysclk] [get_bd_pins clk_wiz_0/clk_in1]
connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins dvi2rgb_*/RefClk]
set sw [ create_bd_port -dir I -from 1 -to 0 sw ]
connect_bd_net -net SELECTION_0_1 [get_bd_ports sw] [get_bd_pins VideoProcessing*/SELECTION]
set async_reset_i [ create_bd_port -dir I async_reset_i ]
connect_bd_net -net aRst_0_1 [get_bd_ports async_reset_i] [get_bd_pins dvi2rgb_*/aRst] [get_bd_pins rgb2dvi_*/aRst]


 