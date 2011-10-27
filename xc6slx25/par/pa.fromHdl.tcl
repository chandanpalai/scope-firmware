
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name scope -dir "/home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/par/planAhead_run_1" -part xc6slx25ftg256-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property top main $srcset
set_param project.paUcfFile  "/home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/ipcore_dir/mig_38/user_design/par/mig_38.ucf"
set hdlfile [add_files [list {../src/pkt16fifo.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../cores/muart/serial.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/think.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/ibctrl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/fx2ctrl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/adcctrl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../cores/muart/BRG.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/main.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files "/home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/ipcore_dir/mig_38/user_design/par/mig_38.ucf" -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx25ftg256-3
