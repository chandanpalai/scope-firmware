
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name scope -dir "/home/ali/Projects/Active/cur/usbscope/fw/xc6slx25/par/planAhead_run_1" -part xc6slx25ftg256-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property top main $srcset
set_param project.paUcfFile  "/home/ali/Projects/Active/cur/usbscope/fw/xc6slx25/ipcore_dir/mig_38/user_design/par/mig_38.ucf"
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/iodrp_mcb_controller.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/iodrp_controller.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/mcb_soft_calibration.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/mcb_soft_calibration_top.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/mcb_raw_wrapper.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/pkt16fifo.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/memc3_wrapper.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/memc3_infrastructure.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/memc1_wrapper.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/memc1_infrastructure.vhd}]]
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
set hdlfile [add_files [list {../ipcore_dir/mig_38/user_design/rtl/mig_38.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/maindcm.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/maindcm/example_design/maindcm_exdes.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../cores/muart/BRG.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/main.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files "/home/ali/Projects/Active/cur/usbscope/fw/xc6slx25/ipcore_dir/mig_38/user_design/par/mig_38.ucf" -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx25ftg256-3
