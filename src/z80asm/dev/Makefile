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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/Makefile,v 1.4 2013-12-15 23:38:49 pauloscustodio Exp $

#------------------------------------------------------------------------------
# ragel
#------------------------------------------------------------------------------
all : scan.c

scan.c : scan.rl dev/Makefile
	ragel -G2 scan.rl
	perl -i.bak -pe "s/^#line/\/\/#line/; s/\x24Header/:Header/; s/\x24Log/:Log/;" scan.c
	$(RM) scan.c.bak

#------------------------------------------------------------------------------
# flex
#------------------------------------------------------------------------------
#scan.c scan.h : scan.l
#	flex -L scan.l
#	perl -i.bak -ne "print unless /^#line/" scan.c scan.h
#	$(RM) scan.c.bak scan.h.bak

#------------------------------------------------------------------------------
# bison
#------------------------------------------------------------------------------
#parse.c parse.h : parse.y
#	bison parse.y
	

#------------------------------------------------------------------------------
# $Log: Makefile,v $
# Revision 1.4  2013-12-15 23:38:49  pauloscustodio
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
