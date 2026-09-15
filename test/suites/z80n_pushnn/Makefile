# z80n PUSH NNNN storage-order probe (standalone; NOT linked into test/suites).
include ../make.config


all: pushnn.bin


pushnn.bin: pushnn.c pushnn.asm
	$(compile_z80n)
	$(runtest_z80n)

# ZX Next executable (hardware run)
nex: pushnn.nex

pushnn.nex: pushnn.c pushnn.asm
	zcc +zxn -subtype=nex -vn pushnn.c pushnn.asm -o pushnn.nex -create-app

clean:
	$(RM) pushnn.bin pushnn.o pushnn.nex pushnn_CODE.bin *.err

.PHONY: all nex clean
