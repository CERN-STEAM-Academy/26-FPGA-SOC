# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "NR_OF_CLKS" -parent ${Page_0}


}

proc update_PARAM_VALUE.NR_OF_CLKS { PARAM_VALUE.NR_OF_CLKS } {
	# Procedure called to update NR_OF_CLKS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NR_OF_CLKS { PARAM_VALUE.NR_OF_CLKS } {
	# Procedure called to validate NR_OF_CLKS
	return true
}


proc update_MODELPARAM_VALUE.NR_OF_CLKS { MODELPARAM_VALUE.NR_OF_CLKS PARAM_VALUE.NR_OF_CLKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NR_OF_CLKS}] ${MODELPARAM_VALUE.NR_OF_CLKS}
}

