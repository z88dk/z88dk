# z80n PUSH NNNN storage-order probe.
#
# Sources only are committed here.  The ZX Next executable is NOT committed:
#   make nex        builds pushnn.nex for a real-hardware run
#   make            builds + runs the +test harness under ticks (-mz80n)
#
# This suite directory is standalone; it is NOT linked into test/suites/Makefile.
include ../make.config


all: pushnn.bin


pushnn.bin: pushnn.c pushnn.asm
	$(compile_z80n)
	$(runtest_z80n)

nex: pushnn.nex

pushnn.nex: pushnn.c pushnn.asm
	zcc +zxn -subtype=nex -vn pushnn.c pushnn.asm -o pushnn.nex -create-app
	@$(RM) pushnn_CODE.bin

clean:
	$(RM) pushnn.bin pushnn.o pushnn.nex pushnn_CODE.bin *.err

.PHONY: all nex clean
