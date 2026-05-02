#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

all: opcodes.dat opcodes.txt
opcodes.dat: make_opcodes.pl Opcodes.pm $(wildcard opcodes*.pl) Makefile
	perl make_opcodes.pl opcodes.dat
	dos2unix opcodes.dat

opcodes.txt: dump_opcodes.pl opcodes.dat Opcodes.pm Makefile
	perl dump_opcodes.pl opcodes.dat opcodes.txt
	dos2unix opcodes.txt

all: cpu_test_z80_ok.asm
cpu_test_z80_ok.asm: opcodes.dat make_cpu_test.pl Opcodes.pm Makefile
	perl make_cpu_test.pl opcodes.dat cpu_test 
	dos2unix cpu_test_*.asm

all: cpu_rules.h
cpu_rules.h: opcodes.dat make_cpu_rules.pl Opcodes.pm Makefile
	perl make_cpu_rules.pl opcodes.dat cpu_rules.h 
	dos2unix cpu_rules.h
