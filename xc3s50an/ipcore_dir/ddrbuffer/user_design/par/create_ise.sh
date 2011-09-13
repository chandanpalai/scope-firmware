./rem_files.sh

coregen -b makeproj.sh
coregen -p . -b ila_coregen.xco
coregen -p . -b icon_coregen.xco
coregen -p . -b vio_coregen.xco

xtclsh set_ise_prop.tcl
