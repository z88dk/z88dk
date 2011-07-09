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
# Copyright (C) Paulo Custodio, 2011

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Makefile,v 1.13 2011-07-09 18:25:35 pauloscustodio Exp $
# $Log: Makefile,v $
# Revision 1.13  2011-07-09 18:25:35  pauloscustodio
# Log keyword in checkin comment was expanded inside Log expansion... recursive
# Added Z80asm banner to all source files
#
# Revision 1.12  2011/07/09 17:36:09  pauloscustodio
# Copied cvs log into Log history
#
# Revision 1.11  2011/07/09 01:46:00  pauloscustodio
# Added Log keyword
# 
# Revision 1.10  2011/07/09 01:12:31  pauloscustodio
# Added test and depend targets
# 
# Revision 1.9  2011/06/26 16:07:29  dom
# Add some support for using binutils
# 
# Revision 1.8  2009/07/19 18:54:52  dom
# introduce exesuffix so that we can use mingw to produce an automagic build
# 
# Revision 1.7  2002/12/09 18:49:46  dom
# simplified the makefiles somewhat, allow cross building for Amiga on linux
# 
# Revision 1.6  2002/10/22 19:15:27  dom
# Makefile changes to use $(RM) instead of rm
# 
# Revision 1.5  2002/07/15 17:45:46  dom
# updates to ensure that the thing can install in /usr/local/bin /usr/local/z88dk on unix systems
# 
# Revision 1.4  2002/01/20 23:21:14  dom
# bumped version number and added prototype (from Dennis)
# 
# Revision 1.3  2001/02/28 17:59:22  dom
# Added UNDEFINE for undefining symbols, bumped version to 1.0.18
# 
# Revision 1.2  2001/01/23 10:00:08  dom
# Changes by x1cygnus:
# 
# just added a harcoded macro Invoke, similar to callpkg except that the
# instruction 'Invoke' resolves to a call by default (ti83) and to a RST if
# the parameter -plus is specified on the command line.
# 
# Changes by dom:
# Added in a rudimentary default directory set up (Defined at compile time)
# a bit kludgy and not very nice!
# 
# Revision 1.1  2000/07/04 15:33:30  dom
# branches:  1.1.1;
# Initial revision
# 
# Revision 1.1.1.1  2000/07/04 15:33:30  dom
# First import of z88dk into the sourceforge system <gulp>
#

OBJS = 	asmdrctv.o 	\
	avltree.o	\
	exprprsr.o	\
	hist.o		\
	ldinstr.o	\
	modlink.o	\
	prsident.o	\
	prsline.o	\
	symbols.o	\
	z80asm.o	\
	z80instr.o	\
	z80pass.o
	
all: z80asm$(EXESUFFIX)


z80asm$(EXESUFFIX): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o z80asm$(EXESUFFIX)  $(OBJS)


install:
	install  z80asm$(EXESUFFIX) $(PREFIX)/bin/


clean :
	$(RM) *.o *~ *.bak core z80asm$(EXESUFFIX) test.*


# test
test : z80asm$(EXESUFFIX)
	perl -S prove t/*.t


# Dependencies
depend:
	makedepend -Y -- $(CFLAGS) -- $(OBJS:.o=.c)

# DO NOT DELETE

asmdrctv.o: config.h ../config.h symbol.h avltree.h z80asm.h
avltree.o: avltree.h
exprprsr.o: config.h ../config.h symbol.h avltree.h
hist.o: hist.h
ldinstr.o: config.h ../config.h z80asm.h symbol.h avltree.h
modlink.o: config.h ../config.h symbol.h avltree.h
prsident.o: config.h ../config.h z80asm.h symbol.h avltree.h
prsline.o: config.h ../config.h z80asm.h symbol.h avltree.h
symbols.o: config.h ../config.h symbol.h avltree.h
z80asm.o: config.h ../config.h symbol.h avltree.h z80asm.h hist.h
z80instr.o: config.h ../config.h z80asm.h symbol.h avltree.h
z80pass.o: config.h ../config.h symbol.h avltree.h hist.h
