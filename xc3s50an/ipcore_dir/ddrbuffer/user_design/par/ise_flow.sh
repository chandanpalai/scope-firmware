./rem_files.sh

coregen -b makeproj.sh
coregen -p . -b ila_coregen.xco
coregen -p . -b icon_coregen.xco
coregen -p . -b vio_coregen.xco

echo Synthesis Tool: XST

mkdir "../synth/__projnav" > ise_flow_results.txt
mkdir "../synth/xst" >> ise_flow_results.txt
mkdir "../synth/xst/work" >> ise_flow_results.txt

xst -ifn ise_run.txt -ofn mem_interface_top.syr -intstyle ise >> ise_flow_results.txt
ngdbuild -intstyle ise -dd ../synth/_ngo -uc ddrbuffer.ucf -p xc3s50antqg144-4 ddrbuffer.ngc ddrbuffer.ngd >> ise_flow_results.txt

map -intstyle ise -detail -cm speed -pr off -c 100 -o ddrbuffer_map.ncd ddrbuffer.ngd ddrbuffer.pcf >> ise_flow_results.txt
par -w -intstyle ise -ol std -t 1 ddrbuffer_map.ncd ddrbuffer.ncd ddrbuffer.pcf >> ise_flow_results.txt
trce -e 100 ddrbuffer.ncd ddrbuffer.pcf >> ise_flow_results.txt
bitgen -intstyle ise -f mem_interface_top.ut ddrbuffer.ncd >> ise_flow_results.txt

echo done!
