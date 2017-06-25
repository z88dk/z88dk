# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Makefile to generate C files, to be called from the .. directory

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
# ragel parser generator
#------------------------------------------------------------------------------
all : scan_rules.h

scan_rules.h : scan_rules.rl tokens.h scan_def.h \
				parse_ragel.pl dev/Makefile 
	perl parse_ragel.pl scan_rules.rl
#	$(ASTYLE) scan_rules.h -- formatted file too big for debugger (> 65536 lines)
	
all : parse_rules.h

parse_rules.h : parse_rules.rl tokens.h scan_def.h \
				parse_ragel.pl dev/Makefile 
	perl parse_ragel.pl parse_rules.rl
#	$(ASTYLE) parse_rules.h -- formatted file too big for debugger (> 65536 lines)
	
#------------------------------------------------------------------------------
# Generate test scripts using  Udo Munk's z80asm as a reference implementation
#------------------------------------------------------------------------------
all: t/opcodes.t

t/opcodes.t: dev/build_opcodes.pl dev/build_opcodes.asm dev/Makefile
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
#all : grammar.c
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

all:
	$(MAKE)
