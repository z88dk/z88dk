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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/Makefile,v 1.10 2014-04-27 09:06:25 pauloscustodio Exp $

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

scan_rules.h : scan_rules.rl scan_def.h legacy.h
	$(CC) -E -xc scan_rules.rl > scan_rules.1.tmp
	perl -pe "s/^#.*//; s/^\x22\x22.*//; s/\t+/ /g; s/ *<CAT> *//g; s/ *<NL> */\n/g; s/ *<TAB> */\t/g;" < scan_rules.1.tmp > scan_rules.2.tmp
	ragel -G2 -oscan_rules.3.tmp scan_rules.2.tmp
	perl -pe "s/^#line.*//; s/\x24Header/:Header/; s/\x24Log/:Log/;" < scan_rules.3.tmp > scan_rules.h
	$(ASTYLE) scan_rules.h
	$(RM) scan_rules.*.tmp
	
all:
	$(MAKE)

#------------------------------------------------------------------------------
# Generate test scripts using  Udo Munk's z80asm as a reference implementation
#------------------------------------------------------------------------------
BUILD_OPCODES	= dev/build_z80opcodes.pl
OPCODES_DAT		= t/data/z80opcodes_templ.asm
OPCODES_OUT		= t/data/z80opcodes

all : $(OPCODES_OUT).asm $(OPCODES_OUT).bin $(OPCODES_OUT)_rabbit.asm $(OPCODES_OUT)_rabbit.bin 

$(OPCODES_OUT).asm $(OPCODES_OUT).bin $(OPCODES_OUT)_rabbit.asm $(OPCODES_OUT)_rabbit.bin : $(OPCODES_DAT) $(BUILD_OPCODES)
	perl $(BUILD_OPCODES)          $(OPCODES_DAT) $(OPCODES_OUT).asm        $(OPCODES_OUT).bin
	perl $(BUILD_OPCODES) -DRABBIT $(OPCODES_DAT) $(OPCODES_OUT)_rabbit.asm $(OPCODES_OUT)_rabbit.bin

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
	

#------------------------------------------------------------------------------
# $Log: Makefile,v $
# Revision 1.10  2014-04-27 09:06:25  pauloscustodio
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
