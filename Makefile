#Simple do-all script for the scope sw/fw system

#-----------------------------------------------------------#

FX2LP = fw/fx2lp
.PHONY: clean-fx2lp build-fx2lp ${FX2LP} fx2tools

build-fx2lp: fx2tools ${FX2LP}

${FX2LP}:
	${MAKE} -C $@

fx2tools:
	cd fw/tools/cytools/fx2tools/; \
			${MAKE} -f Makefile.linux


clean-fx2lp:
	for dir in ${FX2LP}; do \
			${MAKE} -C $$dir clean; \
			done
	cd fw/tools/cytools/fx2tools/; \
			${MAKE} -f Makefile.linux clean

#-----------------------------------------------------------#

.PHONY = prog-jtag prog-pld prog
CURDIR = /home/ali/Projects/Active/cur/usbscope
FX2TOOLS = fw/tools/cytools/fx2tools
prog: prog-fx2 prog-pld
prog-fx2: build-fx2lp
	${FX2TOOLS}/fx2loader/fx2loader -v 0xaaaa -p 0x0200 fw/fx2lp/build/scope.ihx
	sleep 2
prog-fx2-eeprom: build-fx2lp
	${FX2TOOLS}/fx2loader/fx2loader -v 0xaaaa -p 0x0200 ${FX2TOOLS}/firmware/firmware.hex
	sleep 2
	${FX2TOOLS}/fx2loader/fx2loader -v 0xaaaa -p 0x0200 fw/fx2lp/build/scope.ihx eeprom
	${FX2TOOLS}/fx2loader/fx2loader -v 0xaaaa -p 0x0200 fw/fx2lp/build/scope.ihx
prog-pld:
	(openocd -f fw/chain.cfg -l /tmp/openocd)&
	sleep 3
	(echo "spartan3 read_stat 0"; read; echo "pld load 0 \"${CURDIR}/fw/xc3s50an/par/main.bit\""; sleep 7; echo "shutdown" ) | telnet localhost 4444

#-----------------------------------------------------------#

.PHONY = run-sw-testing
run-sw-testing:
	cd sw/testing; \
			ruby usb-inf.rb


