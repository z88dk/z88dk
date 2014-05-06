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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Makefile,v 1.146 2014-05-06 22:52:01 pauloscustodio Exp $

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
#CFLAGS		+= $(shell pkg-config --cflags glib-2.0)
#LDFLAGS	+= $(shell pkg-config --libs   glib-2.0)

#------------------------------------------------------------------------------
# Object files
#------------------------------------------------------------------------------
OBJS = 	\
	asmdrctv.o 		\
	codearea.o		\
	deffile.o		\
	errors.o		\
	expr.o			\
	exprprsr.o		\
	hist.o			\
	ldinstr.o		\
	listfile.o		\
	mapfile.o		\
	model.o			\
	modlink.o		\
	module.o		\
	objfile.o		\
	options.o		\
	prsident.o		\
	prsline.o		\
	scan.o			\
	sym.o			\
	symref.o		\
	symtab.o		\
	z80asm.o		\
	z80instr.o		\
	z80pass.o		\
	\
	lib/array.o		\
	lib/class.o		\
	lib/die.o		\
	lib/except.o	\
	lib/fileutil.o	\
	lib/list.o		\
	lib/srcfile.o	\
	lib/strhash.o	\
	lib/strpool.o	\
	lib/strutil.o	\
	lib/xmalloc.o	\

#------------------------------------------------------------------------------
# variables
#------------------------------------------------------------------------------
TARGET =		z80asm$(EXESUFFIX)
MSVC_TARGET =	../../win32/Debug/$(TARGET)

LOCAL_LIB :=	lib
CFLAGS +=		-I$(LOCAL_LIB) -Wall

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------
all: $(TARGET) gccmake.bat

legacy:
	echo "#define __LEGACY_Z80ASM_SYNTAX " > legacy.h
	$(MAKE) -f dev/Makefile
	$(MAKE) depend
	$(MAKE)

new:
	echo "#undef __LEGACY_Z80ASM_SYNTAX " > legacy.h
	$(MAKE) -f dev/Makefile
	$(MAKE) depend
	$(MAKE)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

#------------------------------------------------------------------------------
# developer generated source files, and test libs
#------------------------------------------------------------------------------
developer :
	$(MAKE) -C lib
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
	$(RM) *.o $(LOCAL_LIB)/*.o *.exe $(LOCAL_LIB)/*.exe *~ $(LOCAL_LIB)/*~ *.tmp
	$(RM) *.bak $(LOCAL_LIB)/*.bak *.orig $(LOCAL_LIB)/*.orig core $(LOCAL_LIB)/core
	$(RM) $(TARGET) $(LOCAL_LIB)/$(TARGET) test* $(LOCAL_LIB)/test*
	$(RM) t/*.tmp $(LOCAL_LIB)/t/*.tmp t/developer/*.tmp 
	$(RM) microman.bin microman.tap mandel.bin mandel.tap zcc_opt.def
	$(RM) -rf Debug Release x1 x2 x3

#------------------------------------------------------------------------------
# test
#------------------------------------------------------------------------------
test:
	$(MAKE) legacy
	$(MAKE) prove
	$(MAKE) new
	$(MAKE) prove

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
				'del *.o $(LOCAL_LIB)\\*.o', qq(\n); \
			for (@ARGV) { \
				s/\.o$$//; \
				print 'gcc -Ilib -Wall -c -o '; \
				print; \
				print '.o ', ' ' x (20 - length); \
				print; \
				print '.c'; \
				print qq(\n); \
			} \
			print \
				'gcc -o z80asm.exe *.o $(LOCAL_LIB)\\*.o', qq(\n), \
				'copy z80asm.exe ..\\..\\bin', qq(\n), \
				'del z80asm.exe', qq(\n); \
		" $(OBJS) > gccmake.bat.new
	@mv gccmake.bat.new gccmake.bat
	
#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
depend:
	makedepend -Y -I$(LOCAL_LIB) $(OBJS:.o=.c)


#------------------------------------------------------------------------------
# $Log: Makefile,v $
# Revision 1.146  2014-05-06 22:52:01  pauloscustodio
# Remove OS-dependent defines and dependency on ../config.h.
# Remove OS_ID constant from predefined defines in assembly.
#
# Revision 1.145  2014/05/03 09:51:51  pauloscustodio
# Make test failed to build object after changing legacy.
# List of out-of-date targets are computed by make only at start. When legacy.h is
# changed, a new set of target get out-of-date, but make misses them if running in the
# same session.
# Need to split make targets in multiple sessions.
#
# Revision 1.144  2014/05/02 23:36:27  pauloscustodio
# Make test failed to build object after changing legacy
#
# Revision 1.143  2014/05/02 20:24:38  pauloscustodio
# New class Module to replace struct module and struct modules
#
# Revision 1.142  2014/04/19 14:57:58  pauloscustodio
# Fix test scripts to run in UNIX
#
# Revision 1.141  2014/04/18 17:46:18  pauloscustodio
# - Change struct expr to Expr class, use CLASS_LIST instead of linked list
#   manipulating.
# - Factor parsing and evaluating contants.
# - Factor symbol-not-defined error during expression evaluation.
# - Store module name in strpool instead of xstrdup/xfree.
#
# Revision 1.140  2014/04/12 15:18:03  pauloscustodio
# Add intArray and longArray to array.c
#
# Revision 1.139  2014/04/12 11:56:45  pauloscustodio
# Removed model_symref.c
#
# Revision 1.138  2014/04/06 23:29:26  pauloscustodio
# Removed lookup functions in token.c, no longer needed with the ragel based scanner.
# Moved the token definitions from token_def.h to scan_def.h.
#
# Revision 1.137  2014/04/05 22:07:32  pauloscustodio
# Added ignore_case attribute to allow case-insensitive class hashes
#
# Revision 1.136  2014/03/29 00:08:27  pauloscustodio
# Moved astyle to dev/Makefile
# Added code to generate scan_rules.h from scan_rules.rl by calling preprocessor and ragel.
#
# Revision 1.135  2014/03/11 22:59:20  pauloscustodio
# Move EOL flag to scanner
#
# Revision 1.134  2014/03/11 00:15:13  pauloscustodio
# Scanner reads input line-by-line instead of character-by-character.
# Factor house-keeping at each new line read in the scanner getasmline().
# Add interface to allow back-tacking of the recursive descent parser by
# getting the current input buffer position and comming back to the same later.
# SetTemporaryLine() keeps a stack of previous input lines.
# Scanner handles single-quoted strings and returns a number.
# New error for single-quoted string with length != 1.
# Scanner handles double-quoted strings and returns the quoted string.
#
# Revision 1.133  2014/03/04 11:49:47  pauloscustodio
# Expression parser and expression evaluator use a look-up table of all
# supported unary, binary and ternary oprators, instead of a big switch
# statement to select the operation.
# Expression operations are stored in a contiguous array instead of
# a liked list to reduce administrative overhead of adding / iterating.
#
# Revision 1.132  2014/03/03 02:44:14  pauloscustodio
# Division by zero error was causing memory leaks - made non-fatal.
# Moved calculator stack to expr.c, made it singleton and based on array.h - no
# need to allocate on every expression computed, elements are stored in
# a vector instead of being allocated individually.
#
# Revision 1.131  2014/03/01 15:45:31  pauloscustodio
# CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
# Handle C-like operators, make exponentiation (**) right-associative.
# Simplify expression parser by handling composed tokens in lexer.
# Change token ids to TK_...
#
# Revision 1.130  2014/02/24 23:08:55  pauloscustodio
# Rename "enum symbols" to "tokid_t", define in token.h
#
# Revision 1.129  2014/02/23 18:48:16  pauloscustodio
# CH_0021: New operators ==, !=, &&, ||, ?:
# Handle C-like operators ==, !=, &&, || and ?:.
# Simplify expression parser by handling composed tokens in lexer.
#
# Revision 1.128  2014/02/19 23:59:26  pauloscustodio
# BUG_0041: 64-bit portability issues
# size_t changes to unsigned long in 64-bit. Usage of size_t * to
# retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
# breaks on a 64-bit architecture. Make the functions return the value instead
# of being passed the pointer to the return value, so that the compiler
# takes care of size convertions.
# Create uint_t and ulong_t, use uint_t instead of size_t.
#
# Revision 1.127  2014/02/18 22:59:06  pauloscustodio
# BUG_0040: Detect and report division by zero instead of crashing
# BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
#
# Revision 1.126  2014/02/17 23:36:07  pauloscustodio
# Embryo of new expression parser
#
# Revision 1.125  2014/02/16 12:58:14  pauloscustodio
# depends
#
# Revision 1.124  2014/02/09 10:09:18  pauloscustodio
# depends
#
# Revision 1.123  2014/02/08 18:30:49  pauloscustodio
# lib/srcfile.c to read source files and handle recursive includes,
# used to read @lists, removed opts.files;
# model.c to hold global data model
#
# Revision 1.122  2014/02/08 11:21:08  pauloscustodio
# Moved srcfile.c to lib/
#
# Revision 1.121  2014/01/29 22:40:52  pauloscustodio
# Mechanism for atomic file write - open a temp file for writing on
# xfopen_atomic(), close and rename to final name on xfclose().
# temp_filename() to generate a temporary file name that is
# deleted atexit.
#
# Revision 1.120  2014/01/23 22:30:55  pauloscustodio
# Use xfclose() instead of fclose() to detect file write errors during buffer flush called
# at fclose()
#
# Revision 1.119  2014/01/20 23:29:17  pauloscustodio
# Moved file.c to lib/fileutil.c
#
# Revision 1.118  2014/01/15 00:01:39  pauloscustodio
# Decouple file.c from errors.c by adding a call-back mechanism in file for
# fatal errors, setup by errors_init()
#
# Revision 1.117  2014/01/11 00:28:30  pauloscustodio
# Link sequence: lib at the end
#
# Revision 1.116  2014/01/11 00:24:39  pauloscustodio
# Clean temp files in lib
#
# Revision 1.115  2014/01/11 00:16:01  pauloscustodio
# Reported by Stefan Drissen (stefan.drissen@gmail.com) 2013-01-11:
# z80asm however does not compile - xmalloc.h cannot be found. The header is in the lib directory, but there is nothing telling gcc to look in the lib directory. I see that the Linux makefile is adding -I lib to also look in the lib directory.
#
# If I add -I lib to all the gcc -c lines in gccmake.bat then z80asm also compiles fine.
#
# So gccmake.bat needs an update?
#
# Revision 1.114  2014/01/11 00:10:38  pauloscustodio
# Astyle - format C code
# Add -Wall option to CFLAGS, remove all warnings
#
# Revision 1.113  2014/01/10 00:15:25  pauloscustodio
# Use Str instead of glib, List instead of GSList.
# Use init.h mechanism, no need for main() calling init_scan.
# glib dependency removed from code and Makefile
#
# Revision 1.112  2014/01/09 23:26:24  pauloscustodio
# Use init.h mechanism, no need for main() calling init_codearea
#
# Revision 1.111  2014/01/09 23:13:03  pauloscustodio
# Use init.h mechanism, no need for main() calling init_options.
# Use Str instead of glib.
#
# Revision 1.110  2014/01/06 00:33:36  pauloscustodio
# Use init.h mechanism, no need for main() calling init_errors
# and atexit(fini_errors); use Str and StrHash instead of glib.
#
# Revision 1.109  2014/01/05 23:20:39  pauloscustodio
# List, StrHash classlist and classhash receive the address of the container
# object in all functions that add items to the container, and create the
# container on first use. This allows a container to be staticaly
# initialized with NULL and instantiated on first push/unshift/set.
# Add count attribute to StrHash, classhash to count elements in container.
# Add free_data attribute in StrHash to register a free fucntion to delete
# the data container when the hash is removed or a key is overwritten.
#
# Revision 1.108  2014/01/02 17:18:16  pauloscustodio
# StrList removed, replaced by List
#
# Revision 1.107  2014/01/01 21:23:48  pauloscustodio
# Move generic file utility functions to lib/fileutil.c
#
# Revision 1.106  2013/12/30 02:05:32  pauloscustodio
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.105  2013/12/26 23:42:27  pauloscustodio
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.104  2013/12/25 17:37:13  pauloscustodio
# Move classlist and classhash to the z80asm/lib directory
#
# Revision 1.103  2013/12/25 17:02:10  pauloscustodio
# Move strhash.c to the z80asm/lib directory
#
# Revision 1.102  2013/12/25 14:39:50  pauloscustodio
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.101  2013/12/19 00:18:23  pauloscustodio
# Use init.h mechanism for intialization code; rename object structure
#
# Revision 1.100  2013/12/18 23:05:51  pauloscustodio
# Move class.c to the z80asm/lib directory
#
# Revision 1.99  2013/12/18 01:46:22  pauloscustodio
# Move strpool.c to the z80asm/lib directory
#
# Revision 1.98  2013/12/15 23:05:54  pauloscustodio
# Remove code-generation for init() functions, do a plain call from main().
# Complicates maintenance, as all the modules with init() functions
# are coupled together, and it may not be clear how the init() module
# appears.
#
# Revision 1.97  2013/12/15 20:30:38  pauloscustodio
# Move except.c to the z80asm/lib directory
#
# Revision 1.96  2013/12/15 19:04:31  pauloscustodio
# Move types.h to the z80asm/lib directory
#
# Revision 1.95  2013/12/15 15:55:23  pauloscustodio
# Move the uthash module to the z80asm/lib directory
#
# Revision 1.94  2013/12/15 13:18:33  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.93  2013/12/15 04:02:25  pauloscustodio
# Move the die and queue modules to the z80asm/lib directory
#
# Revision 1.92  2013/11/26 22:59:08  pauloscustodio
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

asmdrctv.o: lib/xmalloc.h codearea.h lib/types.h errors.h errors_def.h expr.h
asmdrctv.o: lib/array.h lib/class.h lib/queue.h lib/strutil.h lib/classlist.h
asmdrctv.o: scan.h scan_def.h legacy.h lib/fileutil.h lib/list.h listfile.h
asmdrctv.o: symref.h expr_def.h options.h options_def.h lib/strpool.h
asmdrctv.o: symbol.h model.h module.h symtab.h lib/classhash.h lib/strhash.h
asmdrctv.o: lib/uthash.h lib/die.h sym.h objfile.h z80asm.h
codearea.o: lib/xmalloc.h codearea.h lib/types.h errors.h errors_def.h
codearea.o: lib/fileutil.h lib/list.h lib/class.h lib/queue.h lib/strutil.h
codearea.o: lib/init.h lib/die.h listfile.h symref.h lib/classlist.h symbol.h
codearea.o: expr.h lib/array.h scan.h scan_def.h legacy.h model.h module.h
codearea.o: symtab.h lib/classhash.h lib/strhash.h lib/uthash.h sym.h
codearea.o: objfile.h z80asm.h
deffile.o: lib/xmalloc.h deffile.h lib/fileutil.h lib/list.h lib/class.h
deffile.o: lib/queue.h lib/types.h lib/strutil.h listfile.h symref.h
deffile.o: lib/classlist.h options.h options_def.h symbol.h expr.h
deffile.o: lib/array.h scan.h scan_def.h legacy.h model.h module.h symtab.h
deffile.o: lib/classhash.h lib/strhash.h lib/uthash.h lib/die.h sym.h
deffile.o: objfile.h z80asm.h
errors.o: lib/xmalloc.h errors.h errors_def.h lib/except.h lib/die.h
errors.o: lib/types.h lib/fileutil.h lib/list.h lib/class.h lib/queue.h
errors.o: lib/strutil.h lib/srcfile.h lib/strpool.h lib/strhash.h
errors.o: lib/uthash.h lib/init.h
expr.o: lib/xmalloc.h lib/array.h lib/class.h lib/queue.h lib/types.h
expr.o: lib/strutil.h codearea.h expr.h lib/classlist.h scan.h scan_def.h
expr.o: legacy.h errors.h errors_def.h lib/init.h lib/die.h model.h
expr.o: lib/list.h module.h symtab.h lib/classhash.h lib/strhash.h
expr.o: lib/uthash.h sym.h symref.h lib/strpool.h expr_def.h
exprprsr.o: lib/xmalloc.h lib/class.h lib/queue.h lib/types.h codearea.h
exprprsr.o: errors.h errors_def.h expr.h lib/array.h lib/strutil.h
exprprsr.o: lib/classlist.h scan.h scan_def.h legacy.h lib/fileutil.h
exprprsr.o: lib/list.h options.h options_def.h symbol.h model.h module.h
exprprsr.o: symtab.h lib/classhash.h lib/strhash.h lib/uthash.h lib/die.h
exprprsr.o: sym.h symref.h objfile.h lib/except.h expr_def.h z80asm.h
hist.o: lib/xmalloc.h hist.h
ldinstr.o: lib/xmalloc.h codearea.h lib/types.h errors.h errors_def.h
ldinstr.o: options.h lib/list.h lib/class.h lib/queue.h options_def.h scan.h
ldinstr.o: scan_def.h legacy.h symbol.h expr.h lib/array.h lib/strutil.h
ldinstr.o: lib/classlist.h model.h module.h symtab.h lib/classhash.h
ldinstr.o: lib/strhash.h lib/uthash.h lib/die.h sym.h symref.h objfile.h
ldinstr.o: z80asm.h
listfile.o: lib/xmalloc.h listfile.h lib/class.h lib/queue.h lib/types.h
listfile.o: lib/strutil.h symref.h lib/classlist.h lib/fileutil.h lib/list.h
listfile.o: options.h options_def.h z80asm.h sym.h errors.h errors_def.h
listfile.o: hist.h lib/strpool.h codearea.h
mapfile.o: lib/xmalloc.h lib/fileutil.h lib/list.h lib/class.h lib/queue.h
mapfile.o: lib/types.h lib/strutil.h listfile.h symref.h lib/classlist.h
mapfile.o: mapfile.h options.h options_def.h lib/strpool.h symbol.h expr.h
mapfile.o: lib/array.h scan.h scan_def.h legacy.h model.h module.h symtab.h
mapfile.o: lib/classhash.h lib/strhash.h lib/uthash.h lib/die.h sym.h
mapfile.o: objfile.h z80asm.h
model.o: lib/xmalloc.h model.h lib/list.h lib/class.h lib/queue.h lib/types.h
model.o: module.h lib/classlist.h expr.h lib/array.h lib/strutil.h scan.h
model.o: scan_def.h legacy.h symtab.h lib/classhash.h lib/strhash.h
model.o: lib/uthash.h lib/die.h sym.h symref.h codearea.h errors.h
model.o: errors_def.h lib/init.h listfile.h options.h options_def.h
model.o: lib/srcfile.h
modlink.o: lib/xmalloc.h codearea.h lib/types.h errors.h errors_def.h
modlink.o: lib/except.h lib/die.h expr.h lib/array.h lib/class.h lib/queue.h
modlink.o: lib/strutil.h lib/classlist.h scan.h scan_def.h legacy.h
modlink.o: lib/fileutil.h lib/list.h listfile.h symref.h options.h
modlink.o: options_def.h lib/strpool.h sym.h symbol.h model.h module.h
modlink.o: symtab.h lib/classhash.h lib/strhash.h lib/uthash.h objfile.h
modlink.o: z80asm.h
module.o: lib/xmalloc.h codearea.h lib/types.h module.h lib/class.h
module.o: lib/queue.h lib/classlist.h expr.h lib/array.h lib/strutil.h scan.h
module.o: scan_def.h legacy.h symtab.h lib/classhash.h lib/strhash.h
module.o: lib/uthash.h lib/die.h sym.h symref.h
objfile.o: lib/xmalloc.h lib/class.h lib/queue.h lib/types.h errors.h
objfile.o: errors_def.h lib/fileutil.h lib/list.h lib/strutil.h objfile.h
objfile.o: lib/strpool.h legacy.h
options.o: lib/xmalloc.h errors.h errors_def.h lib/fileutil.h lib/list.h
options.o: lib/class.h lib/queue.h lib/types.h lib/strutil.h hist.h
options.o: lib/init.h lib/die.h model.h module.h lib/classlist.h expr.h
options.o: lib/array.h scan.h scan_def.h legacy.h symtab.h lib/classhash.h
options.o: lib/strhash.h lib/uthash.h sym.h symref.h options.h options_def.h
options.o: lib/srcfile.h lib/strpool.h z80asm.h
prsident.o: lib/xmalloc.h codearea.h lib/types.h errors.h errors_def.h
prsident.o: listfile.h lib/class.h lib/queue.h lib/strutil.h symref.h
prsident.o: lib/classlist.h options.h lib/list.h options_def.h scan.h
prsident.o: scan_def.h legacy.h symbol.h expr.h lib/array.h model.h module.h
prsident.o: symtab.h lib/classhash.h lib/strhash.h lib/uthash.h lib/die.h
prsident.o: sym.h objfile.h z80asm.h
prsline.o: lib/xmalloc.h codearea.h lib/types.h errors.h errors_def.h
prsline.o: listfile.h lib/class.h lib/queue.h lib/strutil.h symref.h
prsline.o: lib/classlist.h options.h lib/list.h options_def.h scan.h
prsline.o: scan_def.h legacy.h symbol.h expr.h lib/array.h model.h module.h
prsline.o: symtab.h lib/classhash.h lib/strhash.h lib/uthash.h lib/die.h
prsline.o: sym.h objfile.h z80asm.h
scan.o: lib/xmalloc.h errors.h errors_def.h lib/init.h lib/types.h lib/die.h
scan.o: lib/list.h lib/class.h lib/queue.h model.h module.h lib/classlist.h
scan.o: expr.h lib/array.h lib/strutil.h scan.h scan_def.h legacy.h symtab.h
scan.o: lib/classhash.h lib/strhash.h lib/uthash.h sym.h symref.h
scan.o: scan_rules.h
sym.o: lib/xmalloc.h listfile.h lib/class.h lib/queue.h lib/types.h
sym.o: lib/strutil.h symref.h lib/classlist.h options.h lib/list.h
sym.o: options_def.h lib/strpool.h sym.h symbol.h expr.h lib/array.h scan.h
sym.o: scan_def.h legacy.h model.h module.h symtab.h lib/classhash.h
sym.o: lib/strhash.h lib/uthash.h lib/die.h objfile.h
symref.o: lib/xmalloc.h options.h lib/types.h lib/list.h lib/class.h
symref.o: lib/queue.h options_def.h symref.h lib/classlist.h
symtab.o: lib/xmalloc.h errors.h errors_def.h listfile.h lib/class.h
symtab.o: lib/queue.h lib/types.h lib/strutil.h symref.h lib/classlist.h
symtab.o: model.h lib/list.h module.h expr.h lib/array.h scan.h scan_def.h
symtab.o: legacy.h symtab.h lib/classhash.h lib/strhash.h lib/uthash.h
symtab.o: lib/die.h sym.h options.h options_def.h symbol.h objfile.h z80asm.h
z80asm.o: lib/xmalloc.h codearea.h lib/types.h deffile.h errors.h
z80asm.o: errors_def.h lib/except.h lib/die.h expr.h lib/array.h lib/class.h
z80asm.o: lib/queue.h lib/strutil.h lib/classlist.h scan.h scan_def.h
z80asm.o: legacy.h lib/fileutil.h lib/list.h hist.h listfile.h symref.h
z80asm.o: mapfile.h objfile.h options.h options_def.h lib/strpool.h symbol.h
z80asm.o: model.h module.h symtab.h lib/classhash.h lib/strhash.h
z80asm.o: lib/uthash.h sym.h z80asm.h
z80instr.o: lib/xmalloc.h codearea.h lib/types.h errors.h errors_def.h expr.h
z80instr.o: lib/array.h lib/class.h lib/queue.h lib/strutil.h lib/classlist.h
z80instr.o: scan.h scan_def.h legacy.h options.h lib/list.h options_def.h
z80instr.o: symbol.h model.h module.h symtab.h lib/classhash.h lib/strhash.h
z80instr.o: lib/uthash.h lib/die.h sym.h symref.h objfile.h z80asm.h
z80pass.o: lib/xmalloc.h codearea.h lib/types.h errors.h errors_def.h expr.h
z80pass.o: lib/array.h lib/class.h lib/queue.h lib/strutil.h lib/classlist.h
z80pass.o: scan.h scan_def.h legacy.h lib/fileutil.h lib/list.h hist.h
z80pass.o: listfile.h symref.h model.h module.h symtab.h lib/classhash.h
z80pass.o: lib/strhash.h lib/uthash.h lib/die.h sym.h options.h options_def.h
z80pass.o: lib/srcfile.h symbol.h objfile.h z80asm.h
lib/array.o: lib/xmalloc.h lib/array.h lib/class.h lib/queue.h lib/types.h
lib/array.o: lib/strutil.h
lib/class.o: lib/xmalloc.h lib/class.h lib/queue.h lib/types.h lib/die.h
lib/class.o: lib/init.h
lib/die.o: lib/die.h
lib/except.o: lib/xmalloc.h lib/except.h lib/die.h lib/types.h
lib/fileutil.o: lib/xmalloc.h lib/fileutil.h lib/list.h lib/class.h
lib/fileutil.o: lib/queue.h lib/types.h lib/strutil.h lib/strpool.h
lib/fileutil.o: lib/uthash.h lib/die.h
lib/list.o: lib/xmalloc.h lib/list.h lib/class.h lib/queue.h lib/types.h
lib/srcfile.o: lib/xmalloc.h lib/srcfile.h lib/class.h lib/queue.h
lib/srcfile.o: lib/types.h lib/list.h lib/strutil.h lib/fileutil.h
lib/srcfile.o: lib/strpool.h
lib/strhash.o: lib/xmalloc.h lib/strhash.h lib/types.h lib/class.h
lib/strhash.o: lib/queue.h lib/uthash.h lib/die.h lib/strpool.h lib/strutil.h
lib/strpool.o: lib/xmalloc.h lib/die.h lib/init.h lib/types.h lib/queue.h
lib/strpool.o: lib/strpool.h lib/uthash.h
lib/strutil.o: lib/xmalloc.h lib/strpool.h lib/strutil.h lib/class.h
lib/strutil.o: lib/queue.h lib/types.h
lib/xmalloc.o: lib/xmalloc.h lib/die.h lib/queue.h lib/init.h lib/types.h
