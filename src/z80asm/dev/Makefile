# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Makefile to generate C files, to be called from the .. directory

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

ASTYLE = astyle \
	--mode=c \
	--lineend=linux \
	--indent=spaces=4 \
	--style=ansi \
	--break-blocks \
	--pad-oper --pad-paren-in --pad-header --unpad-paren \
	--align-pointer=name \
	--suffix=none

#------------------------------------------------------------------------------
# force generation of version with make dev
#------------------------------------------------------------------------------
all::
	touch src/c/hist.c

#------------------------------------------------------------------------------
# ragel parser generator
#------------------------------------------------------------------------------
all:: src/c/scan_rules.h

src/c/scan_rules.h : src/c/scan_rules.rl src/c/tokens.h src/c/scan_def.h \
				parse_ragel.pl dev/Makefile 
	perl parse_ragel.pl src/c/scan_rules.rl
#	$(ASTYLE) scan_rules.h -- formatted file too big for debugger (> 65536 lines)
	
all:: src/c/parse_rules.h

dev/cpu/cpu_rules.h : dev/cpu/cpu.pl dev/Makefile
	perl dev/cpu/cpu.pl

src/c/parse_rules.h : src/c/parse_rules.rl src/c/tokens.h src/c/scan_def.h \
				parse_ragel.pl dev/Makefile \
				dev/cpu/cpu_rules.h
	perl parse_ragel.pl src/c/parse_rules.rl
	
#------------------------------------------------------------------------------
# Generate test scripts using  Udo Munk's z80asm as a reference implementation
#------------------------------------------------------------------------------
all:: t/opcodes.t

t/opcodes.t: dev/build_opcodes.pl dev/build_opcodes.asm dev/Makefile
	$(MAKE) -C dev/z80pack-1.21/z80asm
	perl dev/build_opcodes.pl

#------------------------------------------------------------------------------
# formatting style
#------------------------------------------------------------------------------
astyle:
	$(ASTYLE) *.c *.h $(LOCAL_LIB)/*.c $(LOCAL_LIB)/*.h

#------------------------------------------------------------------------------
# Lemon parser generator
#------------------------------------------------------------------------------
#LEMON := 		dev/lemon$(EXESUFFIX)
#LEMON_SRC := 	dev/lemon.c
#LEMON_TMPL := 	dev/lempar.c
#
#all:: grammar.c
#
#grammar.c grammar.h : $(LEMON) $(LEMON_TMPL) grammar.y dev/Makefile
#	$(LEMON) grammar.y
#
#clean::
#	$(RM) grammar.out $(LEMON)
#
#$(LEMON) : $(LEMON_SRC)
#	$(CC) $(CFLAGS) -o $(LEMON) $(LEMON_SRC)
#
#
#------------------------------------------------------------------------------
# bison
#------------------------------------------------------------------------------
#parse.c parse.h : parse.y
#	bison parse.y

all::
	$(MAKE)
