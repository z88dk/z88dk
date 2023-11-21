#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2023
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

all: opcodes.yaml
opcodes.yaml: make_opcodes.pl Makefile
	perl make_opcodes.pl opcodes.yaml && dos2unix opcodes.yaml 2> /dev/null

all: opcodes.txt
opcodes.txt: opcodes.yaml dump_opcodes.pl Makefile
	perl dump_opcodes.pl opcodes.yaml opcodes.txt && dos2unix opcodes.txt 2> /dev/null

all: cpu_test_z80_ok.asm
cpu_test_z80_ok.asm: opcodes.yaml make_cpu_test.pl Makefile
	perl make_cpu_test.pl opcodes.yaml cpu_test && dos2unix cpu_test_*.asm 2> /dev/null

all: cpu_rules.h
cpu_rules.h: opcodes.yaml make_cpu_rules.pl Makefile
	perl make_cpu_rules.pl opcodes.yaml cpu_rules.h && dos2unix cpu_rules.h 2> /dev/null
