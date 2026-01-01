#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

all: opcodes.dat opcodes.txt ../opcodes_tables.cpp

opcodes.dat: make_opcodes.pl Opcodes.pm $(wildcard opcodes*.pl) Makefile
	perl make_opcodes.pl opcodes.dat
	dos2unix opcodes.dat

opcodes.txt: dump_opcodes.pl opcodes.dat Makefile
	perl dump_opcodes.pl opcodes.dat opcodes.txt
	dos2unix opcodes.txt

../opcodes_tables.cpp ../opcodes_tables.h ../opcodes_tables.def: \
		make_dfa.pl $(wildcard *.pm) opcodes.dat ../keywords.def ../lexer.h ../cpu.def Makefile
	perl make_dfa.pl opcodes.dat ../keywords.def ../lexer.h ../cpu.def ../opcodes_tables.cpp
	dos2unix ../opcodes_tables.cpp ../opcodes_tables.h ../opcodes_tables.def
