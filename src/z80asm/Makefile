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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Makefile,v 1.92 2013-11-26 22:59:08 pauloscustodio Exp $

#------------------------------------------------------------------------------
# EXESUFFIX needs to be defined as .exe for windows
#------------------------------------------------------------------------------
ifndef EXESUFFIX
  ifeq ($(OS),Windows_NT)
    EXESUFFIX := .exe
  else
    EXESUFFIX := 
  endif
endif

INSTALL ?= install

#------------------------------------------------------------------------------
# Using GLIB - see http://www.gtk.org/
#
# Compile GLIB in Unix, see http://developer.gimp.org/api/2.0/glib/glib-building.html
#   Use GLIB: see http://developer.gimp.org/api/2.0/glib/glib-compiling.html
#	E.g. for Debian:
#		apt-get install pkg-config
#		apt-get install libglib2.0
#
# CygWin
#   Before 'make', install pkg-config and libglib2.0-devel
#
# Use GLIB in Win32/MinGW, see http://www.gtk.org/download/win32.php,
#   Installation of pkg-config and glib-2.0:
#   1) Extract the following binary packages at the MinGW msys root dir, e.g.
#      C:\MinGW\msys\1.0
#		- glib_2.28.8-1_win32.zip
#		- glib-dev_2.28.8-1_win32.zip
#		- gettext-runtime_0.18.1.1-2_win32.zip
#		- gettext-runtime-dev_0.18.1.1-2_win32.zip
#	2) In a MinGW shell unpack pkg-config-2.28.tar.gz downloaded from
#	   http://pkgconfig.freedesktop.org/releases/
#	3) Point the GLIB variables to the GLIB installation and build pkg-config:
#		export GLIB_CFLAGS="-I/C/MinGW/msys/1.0/include/glib-2.0 -I/C/MinGW/msys/1.0/lib/glib-2.0/include"
#		export GLIB_LIBS="-L/C/MinGW/msys/1.0/lib -lglib-2.0"
#		./configure
#		make
#		make install
#	4) Setup environment variable PKG_CONFIG_PATH to C:\MinGW\msys\1.0\lib\pkgconfig
#------------------------------------------------------------------------------
CFLAGS 	+= $(shell pkg-config --cflags glib-2.0)
LDFLAGS += $(shell pkg-config --libs   glib-2.0)

#------------------------------------------------------------------------------
# Object files
#------------------------------------------------------------------------------
OBJS = 	\
	asmdrctv.o 		\
	class.o			\
	codearea.o		\
	deffile.o		\
	die.o			\
	dynstr.o		\
	errors.o		\
	except.o		\
	exprprsr.o		\
	file.o			\
	hist.o			\
	init.o			\
	ldinstr.o		\
	listfile.o		\
	mapfile.o		\
	memalloc.o		\
	model.o			\
	model_symref.o	\
	modlink.o		\
	module.o		\
	objfile.o		\
	options.o		\
	prsident.o		\
	prsline.o		\
	safestr.o		\
	scan.o			\
	srcfile.o		\
	strhash.o		\
	strpool.o		\
	strutil.o		\
	sym.o			\
	symref.o		\
	symtab.o		\
	z80asm.o		\
	z80instr.o		\
	z80pass.o		\

#------------------------------------------------------------------------------
# variables
#------------------------------------------------------------------------------
ASTYLE = astyle \
	--mode=c \
	--lineend=linux \
	--indent=spaces=4 \
	--style=ansi \
	--indent-switches --indent-classes \
	--indent-preprocessor --convert-tabs \
	--break-blocks \
	--pad-oper --pad-paren-in --pad-header --unpad-paren \
	--align-pointer=name \
	--suffix=none

TARGET =		z80asm$(EXESUFFIX)
MSVC_TARGET =	../../win32/Debug/$(TARGET)

CFLAGS +=		-W -Wformat -Werror=format-security

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------
all: $(TARGET) gccmake.bat

legacy:
	echo "#define __LEGACY_Z80ASM_SYNTAX " > legacy.h
	$(MAKE) depend
	$(MAKE)

new:
	echo "#undef __LEGACY_Z80ASM_SYNTAX " > legacy.h
	$(MAKE) depend
	$(MAKE)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

#------------------------------------------------------------------------------
# developer generated source files
#------------------------------------------------------------------------------
gen :
	$(MAKE) -f dev/Makefile
	$(MAKE) all

#------------------------------------------------------------------------------
# intall
#------------------------------------------------------------------------------
install:
	$(INSTALL) $(TARGET) $(PREFIX)/bin/

#------------------------------------------------------------------------------
# clean
#------------------------------------------------------------------------------
clean :
	$(RM) *.o *.exe *~ *.bak *.orig core $(TARGET) test* t/*.tmp t/developer/*.tmp 
	$(RM) microman.bin microman.tap mandel.bin mandel.tap zcc_opt.def
	$(RM) -rf Debug Release x1 x2 x3

#------------------------------------------------------------------------------
# test
#------------------------------------------------------------------------------
test : $(TARGET)
	$(MAKE) legacy prove
	$(MAKE) new    prove

prove: $(TARGET)
	perl -S prove t/*.t

testmsvc : $(MSVC_TARGET)
	make Z80ASM=$(MSVC_TARGET) prove

testzcc : $(TARGET)
	zcc +zx -lndos       -create-app -omicroman.bin ../../examples/microman.c
	zcc +zx -lndos -lmzx -create-app -omandel.bin   ../../examples/graphics/mandel.c
	eightyone microman.tap
	eightyone mandel.tap

#------------------------------------------------------------------------------
# build with msvc - need to build manualy, devenv not available in Express
#------------------------------------------------------------------------------
$(MSVC_TARGET) : $(wildcard *.c) $(wildcard *.h)
	@echo Build z80asm inside Microsoft Visual C++ 2010 Express
	@exit 1

#------------------------------------------------------------------------------
# formatting style
#------------------------------------------------------------------------------
astyle:
	$(ASTYLE) *.c *.h

#------------------------------------------------------------------------------
# gccmake.bat - work arround impossibility of writing a '$' in the perl code
#------------------------------------------------------------------------------
gccmake.bat : Makefile
	@perl -e " \
			print \
				'@echo off', qq(\n); \
			@printed = (); \
			open(F, 'gccmake.bat'); \
			while (<F>) { \
				next unless /^rem.*Id/; \
				push @printed, 1; \
				print; \
				last; \
			} \
			close(F); \
			@printed or print 'rem ','$$','Id','$$',qq(\n); \
			print \
				qq(\n), \
				'echo *******************', qq(\n), \
				'echo * Building z80asm *', qq(\n), \
				'echo *******************', qq(\n), \
				'del *.o', qq(\n); \
			for (@ARGV) { \
				s/\.o$$//; \
				print 'gcc -c -o '; \
				print; \
				print '.o ', ' ' x (20 - length); \
				print; \
				print '.c'; \
				print qq(\n); \
			} \
			print \
				'gcc -o z80asm.exe *.o', qq(\n), \
				'copy z80asm.exe ..\\..\\bin', qq(\n), \
				'del z80asm.exe', qq(\n); \
		" $(OBJS) > gccmake.bat.new
	@mv gccmake.bat.new gccmake.bat
	
#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
depend:
	makedepend -Y $(OBJS:.o=.c)
	perl -i.bak -pe "s!\.\.\/config\.h!!g" Makefile


#------------------------------------------------------------------------------
# $Log: Makefile,v $
# Revision 1.92  2013-11-26 22:59:08  pauloscustodio
# Version 2.0.0: new C-like expression syntax, incompatible object file format with previous version
#
# Revision 1.91  2013/11/20 13:26:13  stefano
# Sorted out the PSG stuff for the X1
#
# Revision 1.90  2013/11/11 23:47:03  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.89  2013/10/31 22:59:48  pauloscustodio
# Preprocessors (perl, ragel) might not be available in the target platform.
# Ignore errors when calling these tools and use the pre-generated files
# that are in the CVS repository.
#
# Revision 1.88  2013/10/16 00:14:37  pauloscustodio
# Move FileStack implementation to scan.c, remove FileStack.
# Move getline_File() to scan.c.
#
# Revision 1.87  2013/10/15 23:13:53  pauloscustodio
# Keep //#line when generating scan.c from scan.rl
#
# Revision 1.86  2013/10/08 21:53:06  pauloscustodio
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.85  2013/10/05 13:43:05  pauloscustodio
# Parse command line options via look-up tables:
# -i, --use-lib
# -x, --make-lib
#
# Revision 1.84  2013/10/05 10:54:35  pauloscustodio
# Parse command line options via look-up tables:
# -I, --inc-path
# -L, --lib-path
#
# Revision 1.83  2013/10/01 22:50:26  pauloscustodio
# Parse command line options via look-up tables:
# -s, --symtable
# -ns, --no-symtable
#
# Revision 1.82  2013/09/30 00:24:25  pauloscustodio
# Parse command line options via look-up tables:
# -e, --asm-ext
# -M, --obj-ext
# Move filename extension functions to options.c
#
# Revision 1.81  2013/09/29 21:40:13  pauloscustodio
# include
#
# Revision 1.80  2013/09/27 01:14:33  pauloscustodio
# Parse command line options via look-up tables:
# --help, --verbose
#
# Revision 1.79  2013/09/23 23:14:10  pauloscustodio
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.78  2013/09/22 21:04:21  pauloscustodio
# New File and FileStack objects
#
# Revision 1.77  2013/09/12 00:05:34  pauloscustodio
# ASTYLE is optional, do not call it to make init.c
#
# Revision 1.76  2013/09/10 23:47:51  dom
# Pass install down to cope with non-gnu compatible install commands.
#
# Revision 1.75  2013/09/09 00:15:10  pauloscustodio
# Integrate codearea in init() mechanism.
#
# Revision 1.74  2013/09/08 00:43:58  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.73  2013/09/04 21:17:52  pauloscustodio
# $(EXESUFFIX) is passed down as part of the build
#
# Revision 1.72  2013/09/01 16:53:18  pauloscustodio
# Replaced strpool code by GLib String Chunks.
#
# Revision 1.71  2013/09/01 12:28:51  pauloscustodio
# Unified glib compilation options between MinGW and Linux
#
# Revision 1.70  2013/09/01 11:52:55  pauloscustodio
# Setup memalloc on init.c.
# Setup GLib memory allocation functions to use memalloc functions.
#
# Revision 1.69  2013/09/01 00:08:55  pauloscustodio
# - Included GLIB in the Makefile options.
# - Created a code-generation mechanism for automatic execution of initialize
#   code before the main() function starts, and methods for struct malloc
#   and free calling constructors and destructors.
#
# Revision 1.68  2013/08/31 16:50:27  pauloscustodio
# Test GLIB CFLAGS and LDFLAGS
#
# Revision 1.67  2013/08/30 21:50:43  pauloscustodio
# By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
# as an identifier reserved by the C standard for implementation-defined behaviour
# starting with two underscores.
#
# Revision 1.66  2013/08/30 01:06:08  pauloscustodio
# New C-like expressions, defined when __LEGACY_Z80ASM_SYNTAX  is not defined. Keeps old
# behaviour under -D__LEGACY_Z80ASM_SYNTAX  (defined in legacy.h)
#
# BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX )
# - Expressions now use more standard C-like operators
# - Object and library files changed signature to
#   "Z80RMF02", "Z80LMF02", to avoid usage of old
#   object files with expressions inside in the old format
#
# Detail:
# - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
# - Power:                        changed from '^' to '**'; '^' will be XOR
# - XOR:                          changed from ':' to '^';
# - AND:                          changed from '~' to '&';  '~' will be NOT
# - NOT:                          '~' added as binary not
#
# Revision 1.65  2013/08/26 21:49:39  pauloscustodio
# Bug report 2013-07-27 10:50:27 by rkd77 : compile with -Wformat -Werror=format-security
#
# Revision 1.64  2013/06/16 20:14:39  pauloscustodio
# Move deffile writing to deffile.c, remove global variable deffile
#
# Revision 1.63  2013/06/16 18:01:54  pauloscustodio
# Add testzcc target to compile and run a few examples using the assembler.
#
# Revision 1.62  2013/06/15 00:26:23  pauloscustodio
# Move mapfile writing to mapfile.c.
#
# Revision 1.61  2013/06/10 23:08:03  pauloscustodio
# depends
#
# Revision 1.60  2013/06/08 22:58:22  pauloscustodio
# Add module.c
#
# Revision 1.59  2013/06/01 01:24:21  pauloscustodio
# CH_0022 : Replace avltree by hash table for symbol table
#
# Revision 1.58  2013/05/23 22:22:23  pauloscustodio
# Move symbol to sym.c, rename to Symbol
#
# Revision 1.57  2013/05/16 23:39:48  pauloscustodio
# Move struct node to sym.c, rename to Symbol
# Move SymbolRef to symref.c
#
# Revision 1.56  2013/05/11 00:22:33  pauloscustodio
# depends
#
# Revision 1.55  2013/05/07 22:43:24  pauloscustodio
# Build gccmake.bat so that CVS Id is not always changed, causing file to be always
#  modified
#
# Revision 1.54  2013/05/02 21:20:14  pauloscustodio
# depends
#
# Revision 1.53  2013/05/01 19:03:45  pauloscustodio
# Simplified scanner and adapted to be used with a BISON generated parser.
# Removed balanced struct checking and token ring.
# Removed start condition to list assembly lines, as it was difficult to keep in sync across included
# files; inserted an RS char in the input before each line to trigger listing.
# Allow ".NAME" and "NAME:" to return a NAME token, so that ".LD" is recognized as a label and not the LD assembly statement.
# Added Integer out of range warning to number scanning routine.
# Allow input lines to be any size, as long as memory can be allocated.
# Created a skeleton BISON parser.
#
# Revision 1.52  2013/04/21 22:51:51  pauloscustodio
# Simplified flex build
#
# Revision 1.51  2013/04/14 18:16:58  pauloscustodio
# Split scanner in several modules, allow token look-ahead to simplify
# parser.
#
# Revision 1.50  2013/03/31 13:16:48  pauloscustodio
# Embryo of parse module
#
# Revision 1.49  2013/03/29 23:53:07  pauloscustodio
# Added GNU Flex-based scanner. Not yet integrated into assembler.
#
# Revision 1.48  2013/03/02 23:49:44  pauloscustodio
# depends
#
# Revision 1.47  2013/02/27 22:29:59  pauloscustodio
# New srcfile.c to handle reading lines from source files
#
# Revision 1.46  2013/02/26 02:11:32  pauloscustodio
# New model_symref.c with all symbol cross-reference list handling
#
# Revision 1.45  2013/02/25 21:37:30  pauloscustodio
# Show output difference of t_run_module() in visual-diff, to allow easy merge of changes
#
# Revision 1.44  2013/02/19 22:52:40  pauloscustodio
# BUG_0030 : List bytes patching overwrites header
# BUG_0031 : List file garbled with input lines with 255 chars
# New listfile.c with all the listing related code
#
# Revision 1.43  2013/01/30 00:39:25  pauloscustodio
# New CLASS_LIST() to create lists of objects defined with CLASS()
#
# Revision 1.42  2013/01/20 20:43:59  pauloscustodio
# make clean now deletes Microsoft Visual C++ output files
#
# Revision 1.41  2013/01/18 22:59:17  pauloscustodio
# CH_0016 : StrHash class to create maps from string to void*
# Created the StrHash to create hash tables mapping string keys kept in
# strpool to void* user pointer.
#
# Revision 1.40  2013/01/10 23:33:49  pauloscustodio
# Fix dependencies for MSVC_TARGET
#
# Revision 1.39  2013/01/10 22:54:18  pauloscustodio
# Add testmsvc to run tests with executable generated by MS Visual Studio - stops with debugger on memory allocation/usage errors
#
# Revision 1.38  2013/01/10 22:32:16  pauloscustodio
# Dont force gcc
#
# Revision 1.37  2012/11/03 17:27:51  pauloscustodio
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
	
# DO NOT DELETE

asmdrctv.o: memalloc.h codearea.h types.h config.h  errors.h
asmdrctv.o: errors_def.h file.h strutil.h safestr.h listfile.h class.h
asmdrctv.o: queue.h dynstr.h symref.h classlist.h options.h options_def.h
asmdrctv.o: srcfile.h symbol.h model.h objfile.h symtab.h classhash.h
asmdrctv.o: strhash.h uthash.h die.h sym.h token_def.h z80asm.h
class.o: memalloc.h class.h queue.h types.h die.h
codearea.o: memalloc.h codearea.h types.h config.h  errors.h
codearea.o: errors_def.h symbol.h model.h objfile.h class.h queue.h symtab.h
codearea.o: classhash.h strhash.h uthash.h die.h sym.h symref.h classlist.h
codearea.o: token_def.h z80asm.h file.h strutil.h safestr.h listfile.h
codearea.o: dynstr.h
deffile.o: memalloc.h deffile.h file.h strutil.h types.h config.h 
deffile.o: safestr.h listfile.h class.h queue.h dynstr.h symref.h classlist.h
deffile.o: options.h options_def.h symbol.h model.h objfile.h symtab.h
deffile.o: classhash.h strhash.h uthash.h die.h sym.h token_def.h z80asm.h
die.o: memalloc.h die.h
dynstr.o: memalloc.h dynstr.h class.h queue.h types.h strutil.h
errors.o: memalloc.h errors.h errors_def.h except.h die.h types.h file.h
errors.o: strutil.h config.h  safestr.h strpool.h
except.o: memalloc.h except.h die.h types.h
exprprsr.o: memalloc.h codearea.h types.h config.h  errors.h
exprprsr.o: errors_def.h file.h strutil.h safestr.h legacy.h options.h
exprprsr.o: options_def.h symbol.h model.h objfile.h class.h queue.h symtab.h
exprprsr.o: classhash.h strhash.h uthash.h die.h sym.h symref.h classlist.h
exprprsr.o: token_def.h except.h z80asm.h
file.o: memalloc.h file.h strutil.h types.h config.h  safestr.h
file.o: listfile.h class.h queue.h dynstr.h symref.h classlist.h options.h
file.o: options_def.h strpool.h errors.h errors_def.h uthash.h die.h
hist.o: memalloc.h hist.h
init.o: memalloc.h strpool.h errors.h errors_def.h options.h types.h
init.o: strutil.h options_def.h scan.h class.h queue.h codearea.h
ldinstr.o: memalloc.h config.h  z80asm.h types.h sym.h class.h
ldinstr.o: queue.h symref.h classlist.h symbol.h model.h objfile.h symtab.h
ldinstr.o: classhash.h strhash.h uthash.h die.h token_def.h errors.h
ldinstr.o: errors_def.h codearea.h options.h strutil.h options_def.h
listfile.o: memalloc.h listfile.h class.h queue.h types.h dynstr.h symref.h
listfile.o: classlist.h file.h strutil.h config.h  safestr.h
listfile.o: options.h options_def.h z80asm.h sym.h errors.h errors_def.h
listfile.o: hist.h strpool.h codearea.h
mapfile.o: memalloc.h file.h strutil.h types.h config.h  safestr.h
mapfile.o: listfile.h class.h queue.h dynstr.h symref.h classlist.h mapfile.h
mapfile.o: options.h options_def.h strpool.h symbol.h model.h objfile.h
mapfile.o: symtab.h classhash.h strhash.h uthash.h die.h sym.h token_def.h
mapfile.o: z80asm.h
memalloc.o: memalloc.h
modlink.o: memalloc.h codearea.h types.h config.h  errors.h
modlink.o: errors_def.h file.h strutil.h safestr.h listfile.h class.h queue.h
modlink.o: dynstr.h symref.h classlist.h options.h options_def.h strpool.h
modlink.o: sym.h symbol.h model.h objfile.h symtab.h classhash.h strhash.h
modlink.o: uthash.h die.h token_def.h except.h z80asm.h
module.o: memalloc.h module.h class.h queue.h types.h classlist.h dynstr.h
module.o: symtab.h classhash.h strhash.h uthash.h die.h sym.h symref.h
objfile.o: memalloc.h class.h queue.h types.h errors.h errors_def.h file.h
objfile.o: strutil.h config.h  safestr.h objfile.h strpool.h
objfile.o: legacy.h
options.o: memalloc.h errors.h errors_def.h scan.h class.h queue.h types.h
options.o: file.h strutil.h config.h  safestr.h hist.h options.h
options.o: options_def.h strpool.h symtab.h classhash.h strhash.h uthash.h
options.o: die.h sym.h symref.h classlist.h z80asm.h
prsident.o: memalloc.h codearea.h types.h config.h  errors.h
prsident.o: errors_def.h listfile.h class.h queue.h dynstr.h symref.h
prsident.o: classlist.h options.h strutil.h options_def.h symbol.h model.h
prsident.o: objfile.h symtab.h classhash.h strhash.h uthash.h die.h sym.h
prsident.o: token_def.h z80asm.h
prsline.o: memalloc.h config.h  z80asm.h types.h sym.h class.h
prsline.o: queue.h symref.h classlist.h symbol.h model.h objfile.h symtab.h
prsline.o: classhash.h strhash.h uthash.h die.h token_def.h options.h
prsline.o: strutil.h options_def.h errors.h errors_def.h
safestr.o: memalloc.h safestr.h types.h strutil.h
scan.o: memalloc.h scan.h class.h queue.h types.h codearea.h errors.h
scan.o: errors_def.h file.h strutil.h config.h  safestr.h legacy.h
scan.o: listfile.h dynstr.h symref.h classlist.h options.h options_def.h
scan.o: strpool.h
srcfile.o: memalloc.h codearea.h types.h errors.h errors_def.h file.h
srcfile.o: strutil.h config.h  safestr.h listfile.h class.h
srcfile.o: queue.h dynstr.h symref.h classlist.h options.h options_def.h
srcfile.o: srcfile.h strpool.h
strhash.o: memalloc.h strhash.h types.h class.h queue.h uthash.h die.h
strhash.o: strpool.h
strpool.o: memalloc.h strpool.h types.h
strutil.o: memalloc.h strpool.h strutil.h
sym.o: memalloc.h listfile.h class.h queue.h types.h dynstr.h symref.h
sym.o: classlist.h options.h strutil.h options_def.h safestr.h strpool.h
sym.o: sym.h symbol.h model.h objfile.h symtab.h classhash.h strhash.h
sym.o: uthash.h die.h token_def.h
symref.o: memalloc.h options.h types.h strutil.h options_def.h symref.h
symref.o: class.h queue.h classlist.h
symtab.o: memalloc.h errors.h errors_def.h listfile.h class.h queue.h types.h
symtab.o: dynstr.h symref.h classlist.h options.h strutil.h options_def.h
symtab.o: symbol.h model.h objfile.h symtab.h classhash.h strhash.h uthash.h
symtab.o: die.h sym.h token_def.h z80asm.h config.h 
z80asm.o: memalloc.h codearea.h types.h config.h  deffile.h
z80asm.o: errors.h errors_def.h file.h strutil.h safestr.h hist.h init.h
z80asm.o: legacy.h listfile.h class.h queue.h dynstr.h symref.h classlist.h
z80asm.o: mapfile.h objfile.h options.h options_def.h strpool.h symbol.h
z80asm.o: model.h symtab.h classhash.h strhash.h uthash.h die.h sym.h
z80asm.o: token_def.h except.h z80asm.h
z80instr.o: memalloc.h config.h  z80asm.h types.h sym.h class.h
z80instr.o: queue.h symref.h classlist.h symbol.h model.h objfile.h symtab.h
z80instr.o: classhash.h strhash.h uthash.h die.h token_def.h options.h
z80instr.o: strutil.h options_def.h errors.h errors_def.h codearea.h
z80pass.o: memalloc.h codearea.h types.h config.h  errors.h
z80pass.o: errors_def.h file.h strutil.h safestr.h hist.h listfile.h class.h
z80pass.o: queue.h dynstr.h symref.h classlist.h model.h options.h
z80pass.o: options_def.h scan.h sym.h symbol.h objfile.h symtab.h classhash.h
z80pass.o: strhash.h uthash.h die.h token_def.h z80asm.h
