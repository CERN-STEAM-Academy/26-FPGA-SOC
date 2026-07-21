
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART tul.com.tw:pynq-z2:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:FPGA_SoCs:Debouncer:1.0\
xilinx.com:FPGA_SoCs:LED_CTRL:1.0\
xilinx.com:FPGA_SoCs:LEDoff:1.0\
xilinx.com:FPGA_SoCs:PWM:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set LED4_BLUE [ create_bd_port -dir O LED4_BLUE ]
  set LED4_GREEN [ create_bd_port -dir O LED4_GREEN ]
  set LED4_RED [ create_bd_port -dir O LED4_RED ]
  set LED5_BLUE [ create_bd_port -dir O LED5_BLUE ]
  set LED5_GREEN [ create_bd_port -dir O LED5_GREEN ]
  set LED5_RED [ create_bd_port -dir O LED5_RED ]
  set btn0 [ create_bd_port -dir I btn0 ]
  set btn1 [ create_bd_port -dir I btn1 ]
  set btn2 [ create_bd_port -dir I btn2 ]
  set btn3 [ create_bd_port -dir I btn3 ]
  set sysclk [ create_bd_port -dir I -type clk -freq_hz 125000000 sysclk ]

  # Create instance: Debouncer_BLUE, and set properties
  set Debouncer_BLUE [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:Debouncer:1.0 Debouncer_BLUE ]

  # Create instance: Debouncer_CTRL, and set properties
  set Debouncer_CTRL [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:Debouncer:1.0 Debouncer_CTRL ]

  # Create instance: Debouncer_GREEN, and set properties
  set Debouncer_GREEN [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:Debouncer:1.0 Debouncer_GREEN ]

  # Create instance: Debouncer_RED, and set properties
  set Debouncer_RED [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:Debouncer:1.0 Debouncer_RED ]

  # Create instance: LED_CTRL_0, and set properties
  set LED_CTRL_0 [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:LED_CTRL:1.0 LED_CTRL_0 ]

  # Create instance: LEDoff_0, and set properties
  set LEDoff_0 [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:LEDoff:1.0 LEDoff_0 ]

  # Create instance: LEDoff_1, and set properties
  set LEDoff_1 [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:LEDoff:1.0 LEDoff_1 ]

  # Create instance: PWM_BLUE, and set properties
  set PWM_BLUE [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:PWM:1.0 PWM_BLUE ]

  # Create instance: PWM_GREEN, and set properties
  set PWM_GREEN [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:PWM:1.0 PWM_GREEN ]

  # Create instance: PWM_RED, and set properties
  set PWM_RED [ create_bd_cell -type ip -vlnv xilinx.com:FPGA_SoCs:PWM:1.0 PWM_RED ]

  # Create port connections
  connect_bd_net -net Debouncer_BLUE_pls_o [get_bd_pins Debouncer_BLUE/pls_o] [get_bd_pins LED_CTRL_0/btn_blue]
  connect_bd_net -net Debouncer_CTRL_pls_o [get_bd_pins Debouncer_CTRL/pls_o] [get_bd_pins LED_CTRL_0/btn_ctrl]
  connect_bd_net -net Debouncer_GREEN_pls_o [get_bd_pins Debouncer_GREEN/pls_o] [get_bd_pins LED_CTRL_0/btn_green]
  connect_bd_net -net Debouncer_RED_pls_o [get_bd_pins Debouncer_RED/pls_o] [get_bd_pins LED_CTRL_0/btn_red]
  connect_bd_net -net LED_CTRL_0_blue [get_bd_pins LED_CTRL_0/blue] [get_bd_pins PWM_BLUE/data_i]
  connect_bd_net -net LED_CTRL_0_fLed4Off [get_bd_pins LED_CTRL_0/fLed4Off] [get_bd_pins LEDoff_0/LedOFF]
  connect_bd_net -net LED_CTRL_0_fLed5Off [get_bd_pins LED_CTRL_0/fLed5Off] [get_bd_pins LEDoff_1/LedOFF]
  connect_bd_net -net LED_CTRL_0_green [get_bd_pins LED_CTRL_0/green] [get_bd_pins PWM_GREEN/data_i]
  connect_bd_net -net LED_CTRL_0_red [get_bd_pins LED_CTRL_0/red] [get_bd_pins PWM_RED/data_i]
  connect_bd_net -net LEDoff_0_blue_o [get_bd_ports LED4_BLUE] [get_bd_pins LEDoff_0/blue_o]
  connect_bd_net -net LEDoff_0_green_o [get_bd_ports LED4_GREEN] [get_bd_pins LEDoff_0/green_o]
  connect_bd_net -net LEDoff_0_red_o [get_bd_ports LED4_RED] [get_bd_pins LEDoff_0/red_o]
  connect_bd_net -net LEDoff_1_blue_o [get_bd_ports LED5_BLUE] [get_bd_pins LEDoff_1/blue_o]
  connect_bd_net -net LEDoff_1_green_o [get_bd_ports LED5_GREEN] [get_bd_pins LEDoff_1/green_o]
  connect_bd_net -net LEDoff_1_red_o [get_bd_ports LED5_RED] [get_bd_pins LEDoff_1/red_o]
  connect_bd_net -net PWM_BLUE_pwm_o [get_bd_pins LEDoff_0/blue_i] [get_bd_pins LEDoff_1/blue_i] [get_bd_pins PWM_BLUE/pwm_o]
  connect_bd_net -net PWM_GREEN_pwm_o [get_bd_pins LEDoff_0/green_i] [get_bd_pins LEDoff_1/green_i] [get_bd_pins PWM_GREEN/pwm_o]
  connect_bd_net -net PWM_RED_pwm_o [get_bd_pins LEDoff_0/red_i] [get_bd_pins LEDoff_1/red_i] [get_bd_pins PWM_RED/pwm_o]
  connect_bd_net -net btn0_1 [get_bd_ports btn0] [get_bd_pins Debouncer_RED/sig_i]
  connect_bd_net -net btn1_1 [get_bd_ports btn1] [get_bd_pins Debouncer_GREEN/sig_i]
  connect_bd_net -net btn2_1 [get_bd_ports btn2] [get_bd_pins Debouncer_BLUE/sig_i]
  connect_bd_net -net btn3_1 [get_bd_ports btn3] [get_bd_pins Debouncer_CTRL/sig_i]
  connect_bd_net -net sysclk_1 [get_bd_ports sysclk] [get_bd_pins Debouncer_BLUE/clk_i] [get_bd_pins Debouncer_CTRL/clk_i] [get_bd_pins Debouncer_GREEN/clk_i] [get_bd_pins Debouncer_RED/clk_i] [get_bd_pins LED_CTRL_0/clk_i] [get_bd_pins PWM_BLUE/clk_i] [get_bd_pins PWM_GREEN/clk_i] [get_bd_pins PWM_RED/clk_i]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


