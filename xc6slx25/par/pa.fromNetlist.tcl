
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name scope -dir "/home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/par/planAhead_run_1" -part xc6slx25ftg256-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/par/main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/par} {../ipcore_dir} }
set_param project.pinAheadLayout  yes
set_param project.paUcfFile  "/home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/main.ucf"
add_files "/home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/main.ucf" -fileset [get_property constrset [current_run]]
open_netlist_design
