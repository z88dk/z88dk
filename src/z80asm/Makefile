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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Makefile,v 1.37 2012-11-03 17:27:51 pauloscustodio Exp $
# $Log: Makefile,v $
# Revision 1.37  2012-11-03 17:27:51  pauloscustodio
# Remove all test* in make clean
#
# Revision 1.36  2012/08/01 21:08:02  dom
# Allow x-compilation of z80asm
#
# Revision 1.35  2012/06/14 15:04:58  pauloscustodio
# New safestr.o, dynstr.o
#
# Revision 1.34  2012/05/26 18:50:06  pauloscustodio
# Use gcc to compile instead of cc.
#
# Revision 1.33  2012/05/24 21:42:42  pauloscustodio
# CH_0011 : new string list class to hold lists of strings
#
# Revision 1.32  2012/05/24 17:50:02  pauloscustodio
# CH_0010 : new string pool to hold strings for all program duration
#
# Revision 1.31  2012/05/24 17:01:45  pauloscustodio
# CH_0009 : new CLASS to define simple classes
#
# Revision 1.30  2012/05/24 15:02:26  pauloscustodio
# depends
#
# Revision 1.29  2012/05/17 20:29:32  pauloscustodio
# depends
#
# Revision 1.28  2012/05/17 17:11:47  pauloscustodio
# depends
#
# Revision 1.27  2012/05/17 14:59:39  pauloscustodio
# New dio.o
#
# Revision 1.26  2012/05/11 19:29:49  pauloscustodio
# Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
#         --mode=c
#         --lineend=linux
#         --indent=spaces=4
#         --style=ansi --add-brackets
#         --indent-switches --indent-classes
#         --indent-preprocessor --convert-tabs
#         --break-blocks
#         --pad-oper --pad-paren-in --pad-header --unpad-paren
#         --align-pointer=name
#
# Revision 1.25  2011/10/14 13:56:51  pauloscustodio
# New module scrutil
#
# Revision 1.24  2011/10/07 17:23:57  pauloscustodio
# Delete all *.exe in clean
#
# Revision 1.23  2011/09/29 21:27:16  pauloscustodio
# Updated depend
#
# Revision 1.22  2011/08/21 20:18:33  pauloscustodio
# Dependencies updated
#
# Revision 1.21  2011/08/19 15:53:58  pauloscustodio
# BUG_0010 : heap corruption when reaching MAXCODESIZE
# - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
# - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
#
# Revision 1.20  2011/08/18 23:16:10  pauloscustodio
# Dependencies
#
# Revision 1.19  2011/08/18 21:45:17  pauloscustodio
# new object file.o
#
# Revision 1.18  2011/08/05 19:30:57  pauloscustodio
# CH_0004 : Exception mechanism to handle fatal errors
#
# Revision 1.17  2011/07/18 00:48:25  pauloscustodio
# Initialize MS Visual Studio DEBUG build to show memory leaks on exit
#
# Revision 1.16  2011/07/14 01:32:08  pauloscustodio
#     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
#     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
#     CH_0003 : Error messages should be more informative
#         - Added printf-args to error messages, added "Error:" prefix.
#     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
#         - Raise ERR_UNBALANCED_PAREN instead
#
# Revision 1.15  2011/07/12 22:47:59  pauloscustodio
# - Moved all error variables and error reporting code to a separate module errors.c,
#   replaced all extern declarations of these variables by include errors.h,
#   created symbolic constants for error codes.
# - Added test scripts for error messages.
#
# Revision 1.14  2011/07/11 15:54:37  pauloscustodio
# new module options.o
#
# Revision 1.13  2011/07/09 18:25:35  pauloscustodio
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

OBJS = 	\
	asmdrctv.o 	\
	avltree.o	\
	class.o		\
	codearea.o	\
	die.o		\
	dynstr.o	\
	errors.o	\
	except.o	\
	exprprsr.o	\
	file.o		\
	hist.o		\
	ldinstr.o	\
	memalloc.o	\
	modlink.o	\
	objfile.o	\
	options.o	\
	prsident.o	\
	prsline.o	\
	safestr.o	\
	strlist.o	\
	strpool.o	\
	strutil.o	\
	symbols.o	\
	z80asm.o	\
	z80instr.o	\
	z80pass.o	\

ASTYLE = astyle \
	--mode=c \
	--lineend=linux \
	--indent=spaces=4 \
	--style=ansi --add-brackets \
	--indent-switches --indent-classes \
	--indent-preprocessor --convert-tabs \
	--break-blocks \
	--pad-oper --pad-paren-in --pad-header --unpad-paren \
	--align-pointer=name

CC ?= gcc

all: z80asm$(EXESUFFIX)


z80asm$(EXESUFFIX): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o z80asm$(EXESUFFIX)  $(OBJS)


install:
	install  z80asm$(EXESUFFIX) $(PREFIX)/bin/


clean :
	$(RM) *.o *.exe *~ *.bak *.orig core z80asm$(EXESUFFIX) test*


# test
test : z80asm$(EXESUFFIX)
	perl -S prove t/*.t


# formatting style
astyle:
	$(ASTYLE) *.c *.h

# Dependencies
depend:
	makedepend -Y -- $(CFLAGS) -- $(OBJS:.o=.c)

# DO NOT DELETE

asmdrctv.o: memalloc.h except.h e4c.h config.h ../config.h options.h symbol.h
asmdrctv.o: avltree.h symbols.h z80asm.h types.h errors.h errors_def.h file.h
asmdrctv.o: strlist.h class.h queue.h codearea.h
avltree.o: memalloc.h except.h e4c.h avltree.h
class.o: memalloc.h except.h e4c.h class.h queue.h types.h die.h
codearea.o: codearea.h memalloc.h except.h e4c.h config.h ../config.h
codearea.o: errors.h errors_def.h symbol.h avltree.h z80asm.h types.h file.h
codearea.o: strlist.h class.h queue.h
die.o: memalloc.h except.h e4c.h die.h types.h strutil.h safestr.h
dynstr.o: dynstr.h memalloc.h except.h e4c.h types.h class.h queue.h
errors.o: memalloc.h except.h e4c.h errors.h errors_def.h strutil.h safestr.h
errors.o: types.h class.h queue.h strpool.h
except.o: except.h memalloc.h e4c.h types.h die.h e4c.c
exprprsr.o: memalloc.h except.h e4c.h config.h ../config.h symbol.h avltree.h
exprprsr.o: options.h errors.h errors_def.h file.h strlist.h class.h queue.h
exprprsr.o: types.h codearea.h
file.o: file.h memalloc.h except.h e4c.h strlist.h class.h queue.h types.h
file.o: config.h ../config.h strutil.h safestr.h strpool.h errors.h
file.o: errors_def.h
hist.o: memalloc.h except.h e4c.h hist.h
ldinstr.o: memalloc.h except.h e4c.h config.h ../config.h z80asm.h avltree.h
ldinstr.o: types.h symbol.h errors.h errors_def.h codearea.h options.h
memalloc.o: memalloc.h except.h e4c.h types.h die.h queue.h
modlink.o: memalloc.h except.h e4c.h config.h ../config.h options.h symbol.h
modlink.o: avltree.h symbols.h z80asm.h types.h errors.h errors_def.h file.h
modlink.o: strlist.h class.h queue.h codearea.h strutil.h safestr.h
objfile.o: objfile.h memalloc.h except.h e4c.h
options.o: memalloc.h except.h e4c.h z80asm.h config.h ../config.h avltree.h
options.o: types.h options.h symbol.h symbols.h errors.h errors_def.h
options.o: strlist.h class.h queue.h file.h
prsident.o: memalloc.h except.h e4c.h config.h ../config.h z80asm.h avltree.h
prsident.o: types.h symbol.h symbols.h options.h errors.h errors_def.h
prsident.o: codearea.h
prsline.o: memalloc.h except.h e4c.h config.h ../config.h z80asm.h avltree.h
prsline.o: types.h symbol.h options.h errors.h errors_def.h
safestr.o: safestr.h memalloc.h except.h e4c.h types.h
strlist.o: memalloc.h except.h e4c.h strlist.h class.h queue.h types.h
strlist.o: strpool.h
strpool.o: memalloc.h except.h e4c.h strpool.h class.h queue.h types.h
strpool.o: uthash.h die.h
strutil.o: strutil.h memalloc.h except.h e4c.h
symbols.o: memalloc.h except.h e4c.h config.h ../config.h symbol.h avltree.h
symbols.o: symbols.h options.h errors.h errors_def.h
z80asm.o: memalloc.h except.h e4c.h config.h ../config.h symbol.h avltree.h
z80asm.o: symbols.h z80asm.h types.h hist.h options.h errors.h errors_def.h
z80asm.o: file.h strlist.h class.h queue.h codearea.h strutil.h
z80instr.o: memalloc.h except.h e4c.h config.h ../config.h z80asm.h avltree.h
z80instr.o: types.h symbol.h options.h errors.h errors_def.h codearea.h
z80pass.o: memalloc.h except.h e4c.h config.h ../config.h symbol.h avltree.h
z80pass.o: symbols.h hist.h options.h z80asm.h types.h errors.h errors_def.h
z80pass.o: file.h strlist.h class.h queue.h codearea.h strutil.h
