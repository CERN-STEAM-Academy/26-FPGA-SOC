create_bd_port -dir I btn3
create_bd_port -dir I btn2
create_bd_port -dir I btn1
create_bd_port -dir I btn0
create_bd_port -dir O LED5_RED
create_bd_port -dir O LED5_GREEN
create_bd_port -dir O LED5_BLUE
create_bd_port -dir O LED4_RED
create_bd_port -dir O LED4_GREEN
create_bd_port -dir O LED4_BLUE
startgroup
create_bd_port -dir I -type clk sysclk
set_property CONFIG.FREQ_HZ 125000000 [get_bd_ports sysclk]
endgroup
