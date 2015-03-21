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
# Copyright (C) Paulo Custodio, 2011-2015
#
# Makefile to generate C files, to be called from the .. directory
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/Makefile,v 1.16 2015-03-21 20:55:13 pauloscustodio Exp $

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

scan_rules.h : scan_rules.rl scan_tokens.h scan_def.h \
			   dev/parse_ragel.pl dev/Makefile
	perl dev/parse_ragel.pl scan_rules.rl
#	$(ASTYLE) scan_rules.h -- formatted file too big for debugger (> 65536 lines)

scan_tokens.h : scan_def.h \
				dev/build_tokens.pl dev/Makefile
	perl dev/build_tokens.pl	

#------------------------------------------------------------------------------
# ragel parser generator
#------------------------------------------------------------------------------
all : parse_rules.h

parse_rules.h : parse_rules.rl scan_tokens.h scan_def.h \
				dev/parse_ragel.pl dev/Makefile 
	perl dev/parse_ragel.pl parse_rules.rl
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
