#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# windows portability layer
PERL     = perl
CP       = $(PERL) ../../tools/posix.pl cp
RM       = $(PERL) ../../tools/posix.pl rm
MV       = $(PERL) ../../tools/posix.pl mv
MKDIR    = $(PERL) ../../tools/posix.pl mkdir
TOUCH    = $(PERL) ../../tools/posix.pl touch
INSTALL  = $(PERL) ../../tools/posix.pl install
DOS2UNIX = $(PERL) ../../tools/posix.pl dos2unix

EXE =
ifeq ($(OS),Windows_NT)
  EXE = .exe
endif

all: opcodes.dat opcodes.txt ../opcodes_tables.cpp

opcodes.dat: make_opcodes.pl Opcodes.pm $(wildcard opcodes*.pl) Makefile
	$(PERL) make_opcodes.pl opcodes.dat
	$(DOS2UNIX) opcodes.dat

opcodes.txt: dump_opcodes.pl opcodes.dat Makefile
	$(PERL) dump_opcodes.pl opcodes.dat opcodes.txt
	$(DOS2UNIX) opcodes.txt

../opcodes_tables.cpp ../opcodes_tables.h ../opcodes_tables.def: \
		make_dfa.pl $(wildcard *.pm) opcodes.dat ../keywords.def ../lexer.h ../cpu.def Makefile
	$(PERL) make_dfa.pl opcodes.dat ../keywords.def ../lexer.h ../cpu.def ../opcodes_tables.cpp
	$(DOS2UNIX) ../opcodes_tables.cpp ../opcodes_tables.h ../opcodes_tables.def
