
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name scope -dir "/home/ali/Projects/Active/cur/usbscope/fw/xc6slx25/par/planAhead_run_1" -part xc6slx25ftg256-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property top main $srcset
set_property target_constrs_file "/home/ali/Projects/Active/cur/usbscope/fw/xc6slx25/scope.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../ipcore_dir/clkmgr.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/clkmgr/example_design/clkmgr_exdes.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/iodrp_mcb_controller.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/iodrp_controller.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/mcb_soft_calibration.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/mcb_soft_calibration_top.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/mcb_raw_wrapper.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/scope/constants.vhd}]]
set_property file_type VHDL $hdlfile
set_property library scope $hdlfile
add_files [list {../ipcore_dir/pkt16buffer.ngc}]
set hdlfile [add_files [list {../ipcore_dir/pkt16buffer.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/memc3_wrapper.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/memc1_wrapper.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/memc13_infrastructure.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {../ipcore_dir/adcbuffer.ngc}]
set hdlfile [add_files [list {../ipcore_dir/adcbuffer.vhd}]]
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
set hdlfile [add_files [list {../ipcore_dir/dualmcb/user_design/rtl/dualmcb.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {../ipcore_dir/chipscope_ila_uart.ngc}]
set hdlfile [add_files [list {../ipcore_dir/chipscope_ila_uart.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {../ipcore_dir/chipscope_ila_fx2.ngc}]
set hdlfile [add_files [list {../ipcore_dir/chipscope_ila_fx2.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {../ipcore_dir/chipscope_icon.ngc}]
set hdlfile [add_files [list {../ipcore_dir/chipscope_icon.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../cores/muart/BRG.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../src/main.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {/home/ali/Projects/Active/cur/usbscope/fw/xc6slx25/scope.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx25ftg256-3
