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
# Makefile to build Toolkit::Template generated files
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/tt/Makefile,v 1.2 2015-08-04 22:30:06 pauloscustodio Exp $

TPAGE = perl -S tpage --include_path=. 

all : $(patsubst %.tt, ../%, $(wildcard *.tt))

../%.c : %.c.tt %.yaml
	$(TPAGE) $< > $@~
	mv $@~ $@
	dos2unix $@

../%.h : %.h.tt %.yaml
	$(TPAGE) $< > $@~
	mv $@~ $@
	dos2unix $@
