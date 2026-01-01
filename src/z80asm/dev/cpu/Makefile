#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

OPCODES = opcodes.dat

all: $(OPCODES)
$(OPCODES): make_opcodes.pl Opcodes.pm $(wildcard opcodes_*.pl) Makefile
	perl make_opcodes.pl $(OPCODES) && dos2unix $(OPCODES) 2> /dev/null

all: opcodes.txt
opcodes.txt: $(OPCODES) dump_opcodes.pl Opcodes.pm Makefile
	perl dump_opcodes.pl $(OPCODES) opcodes.txt && dos2unix opcodes.txt 2> /dev/null

all: cpu_test_z80_ok.asm
cpu_test_z80_ok.asm: $(OPCODES) make_cpu_test.pl Opcodes.pm Makefile
	perl make_cpu_test.pl $(OPCODES) cpu_test && dos2unix cpu_test_*.asm 2> /dev/null

all: cpu_rules.h
cpu_rules.h: $(OPCODES) make_cpu_rules.pl Opcodes.pm Makefile
	perl make_cpu_rules.pl $(OPCODES) cpu_rules.h && dos2unix cpu_rules.h 2> /dev/null
