SOURCES=main.c process.c
A51_SOURCES=dscr.a51
BASENAME=cypress_scope

include ../../tools/cytools/fx2lib/lib/fx2.mk

.PHONY: run rerun
run: 
	fx2loader -v 0x16c0 -p 0x06ad build/${BASENAME}.ihx
rerun:
	fx2loader -v 0xaaaa -p 0x0200 build/${BASENAME}.ihx
