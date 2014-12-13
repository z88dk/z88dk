#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2013
#
# Makefile to generate C files, to be called from the .. directory
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/Makefile,v 1.12 2014-12-13 00:49:46 pauloscustodio Exp $

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
# ragel lexer generator
#------------------------------------------------------------------------------
all : scan_rules.h

scan_rules.h : scan_rules.rl scan_tokens.h scan_def.h legacy.h \
			   dev/parse_ragel.pl dev/Makefile
	perl dev/parse_ragel.pl scan_rules.rl
	$(ASTYLE) scan_rules.h

scan_tokens.h : scan_def.h legacy.h \
				dev/build_tokens.pl dev/Makefile
	perl dev/build_tokens.pl	

#------------------------------------------------------------------------------
# ragel parser generator
#------------------------------------------------------------------------------
all : parse_rules.h

parse_rules.h : parse_rules.rl scan_tokens.h scan_def.h legacy.h \
				dev/parse_ragel.pl dev/Makefile 
	perl dev/parse_ragel.pl parse_rules.rl
	$(ASTYLE) parse_rules.h
	
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

#------------------------------------------------------------------------------
# $Log: Makefile,v $
# Revision 1.12  2014-12-13 00:49:46  pauloscustodio
# Implemented infrastructure to do parsing based on a RAGEL state machine,
# and to fall back to the original parser on error. Implemented the first
# two simple opcodes (NOP and HALT) as a concept check.
#
# Revision 1.11  2014/05/13 23:42:48  pauloscustodio
# Move opcode testing to t/opcodes.t, add errors and warnings checks, build it by dev/build_opcodes.pl and dev/build_opcodes.asm.
# Remove opcode errors and warnings from t/errors.t.
# Remove t/cpu-opcodes.t, it was too slow - calling z80asm for every single Z80 opcode.
# Remove t/data/z80opcodes*, too complex to maintain.
#
# Revision 1.10  2014/04/27 09:06:25  pauloscustodio
# Cleanup temporary files
#
# Revision 1.9  2014/04/25 23:52:17  pauloscustodio
# Rename input file for z80opcodes generation
#
# Revision 1.8  2014/04/25 23:39:13  pauloscustodio
# Create asm and binary files at dev/Makefile using z80pack's assembler as benchmarks
# to test the z80asm assembler. These files are used during testing.
#
# Revision 1.7  2014/04/06 23:29:27  pauloscustodio
# Removed lookup functions in token.c, no longer needed with the ragel based scanner.
# Moved the token definitions from token_def.h to scan_def.h.
#
# Revision 1.6  2014/03/29 00:08:27  pauloscustodio
# Moved astyle to dev/Makefile
# Added code to generate scan_rules.h from scan_rules.rl by calling preprocessor and ragel.
#
# Revision 1.5  2014/02/11 15:18:56  pauloscustodio
# Add (commented) lemon parser generation.
#
# Revision 1.4  2013/12/15 23:38:49  pauloscustodio
# Remove CVS tags from generated file
#
# Revision 1.3  2013/12/15 23:05:54  pauloscustodio
# Remove code-generation for init() functions, do a plain call from main().
# Complicates maintenance, as all the modules with init() functions
# are coupled together, and it may not be clear how the init() module
# appears.
#
# Revision 1.2  2013/12/15 13:18:35  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.1  2013/11/11 23:47:04  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
#------------------------------------------------------------------------------
