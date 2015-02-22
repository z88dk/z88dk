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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Makefile,v 1.196 2015-02-22 13:46:35 pauloscustodio Exp $

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
#CFLAGS  += $(shell pkg-config --cflags glib-2.0)
#LDFLAGS += $(shell pkg-config --libs   glib-2.0)

#------------------------------------------------------------------------------
# Object files
#------------------------------------------------------------------------------
SRCS1 	:= $(wildcard *.c lib/*.c)
SRCS	:= $(SRCS1:test.c=)
OBJS 	:= $(SRCS:.c=.o)
TEST_SRC_MAIN:= $(wildcard t/test_*.c)
TEST_SRC_LIB:=t/testlib.c

#------------------------------------------------------------------------------
# variables
#------------------------------------------------------------------------------
TARGET =		z80asm$(EXESUFFIX)
MSVC_TARGET =	../../win32/Debug/$(TARGET)

LOCAL_LIB :=	lib
CFLAGS +=		-I. -I$(LOCAL_LIB) -It -Wall

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------
all: $(TARGET) gccmake.bat

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

#------------------------------------------------------------------------------
# developer generated source files, and test libs
#------------------------------------------------------------------------------
developer :
	$(MAKE) depend
	$(MAKE) -C doc
	$(MAKE) -C lib
	$(MAKE) -f dev/Makefile
	$(MAKE) all

#------------------------------------------------------------------------------
# intall
#------------------------------------------------------------------------------
install:
	$(INSTALL) $(TARGET) $(PREFIX)/bin/
	$(INSTALL) asmpp.pl  $(PREFIX)/bin/

#------------------------------------------------------------------------------
# clean
#------------------------------------------------------------------------------
clean::
	$(RM) *.core $(LOCAL_LIB)/*.core $(LOCAL_LIB)/t/*.core $(LOCAL_LIB)/t/uthash/*.core
	$(RM) *.o    $(LOCAL_LIB)/*.o    $(LOCAL_LIB)/t/*.o    $(LOCAL_LIB)/t/uthash/*.o 
	$(RM) *.out  $(LOCAL_LIB)/*.out  $(LOCAL_LIB)/t/*.out  $(LOCAL_LIB)/t/uthash/*.out
	$(RM) *.orig $(LOCAL_LIB)/*.orig $(LOCAL_LIB)/t/*.orig $(LOCAL_LIB)/t/uthash/*.orig
	$(RM) *.exe  $(LOCAL_LIB)/*.exe  $(LOCAL_LIB)/t/*.exe  $(LOCAL_LIB)/t/uthash/*.exe
	$(RM) *.tmp  $(LOCAL_LIB)/*.tmp  $(LOCAL_LIB)/t/*.tmp  $(LOCAL_LIB)/t/uthash/*.tmp
	$(RM) *.bak  $(LOCAL_LIB)/*.bak  $(LOCAL_LIB)/t/*.bak  $(LOCAL_LIB)/t/uthash/*.bak
	$(RM) *.log  $(LOCAL_LIB)/*.log  $(LOCAL_LIB)/t/*.log  $(LOCAL_LIB)/t/uthash/*.log
	$(RM) *~     $(LOCAL_LIB)/*~     $(LOCAL_LIB)/t/*~     $(LOCAL_LIB)/t/uthash/*~
	$(RM) -rf Debug Release x1 x2 x3

#------------------------------------------------------------------------------
# test
#------------------------------------------------------------------------------
all: t/libtestlib.a

t/libtestlib.a : $(OBJS) $(TEST_SRC_LIB:.c=.o)
	ar rcs t/libtestlib.a $(OBJS:z80asm.o=) $(TEST_SRC_LIB:.c=.o)

$(TEST_SRC_MAIN:.c=.o) : t/libtestlib.a

.o.out :
	$(CC) -static $(CFLAGS) $< -o $(<:.o=$(EXESUFFIX)) $(LDFLAGS) -Lt -ltestlib
	$(<:.o=$(EXESUFFIX)) 2> $@~
	diff -w $(<:.o=.bmk) $@~
	mv -f $@~ $@

clean::
	$(RM) t/libtestlib.a t/*.o t/*.out lib/t/*.o lib/t/*.out $(TEST_SRC_MAIN:.c=$(EXESUFFIX))

test:
	$(MAKE) developer
	$(MAKE) prove_c
	$(MAKE) prove_perl
	$(MAKE) test_enigma

prove_c: t/libtestlib.a $(TEST_SRC_MAIN:.c=.o) $(TEST_SRC_MAIN:.c=.out)

prove_perl: $(TARGET)
	perl -S prove t/*.t

testmsvc : $(MSVC_TARGET)
	make Z80ASM=$(MSVC_TARGET) prove

test_enigma: $(TARGET)
	zcc +cpm -oenigma.bin -vn ../../examples/console/enigma.c
	echo HELLO. | cpm enigma.bin > enigma.out
	echo 'Enter text to be (de)coded, finish with a .' > enigma.bmk
	echo 'HREXLSLEOC .' >> enigma.bmk
	diff -w enigma.bmk enigma.out

clean::
	$(RM) enigma.*

testzcc : $(TARGET)
	zcc +zx -lndos       -create-app -omicroman.bin ../../examples/microman.c
	zcc +zx -lndos -lmzx -create-app -omandel.bin   ../../examples/graphics/mandel.c
	eightyone microman.tap
	eightyone mandel.tap

clean::
	$(RM) $(TARGET) $(LOCAL_LIB)/$(TARGET) test* $(LOCAL_LIB)/test*
	$(RM) t/*.tmp $(LOCAL_LIB)/t/*.tmp t/dev/*.tmp 
	$(RM) microman.bin microman.tap mandel.bin mandel.tap zcc_opt.def

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
	makedepend -Y -I. -I$(LOCAL_LIB) $(SRCS) $(TEST_SRC_MAIN) $(TEST_SRC_LIB)
	
# DO NOT DELETE

codearea.o: codearea.h lib/array.h lib/class.h lib/alloc.h lib/dbg.h
codearea.o: lib/types.h lib/queue.h lib/strutil.h lib/classhash.h
codearea.o: lib/strhash.h lib/uthash.h errors.h errors_def.h lib/fileutil.h
codearea.o: lib/list.h lib/utarray.h lib/init.h listfile.h symref.h
codearea.o: lib/classlist.h options.h options_def.h lib/strpool.h z80asm.h
codearea.o: sym.h expr.h scan.h scan_tokens.h opcodes.h
deffile.o: deffile.h lib/fileutil.h lib/list.h lib/class.h lib/alloc.h
deffile.o: lib/dbg.h lib/types.h lib/queue.h lib/strutil.h lib/utarray.h
deffile.o: listfile.h symref.h lib/classlist.h options.h options_def.h
deffile.o: symbol.h expr.h lib/array.h scan.h scan_tokens.h opcodes.h
deffile.o: errors.h errors_def.h sym.h model.h module.h lib/classhash.h
deffile.o: lib/strhash.h lib/uthash.h codearea.h symtab.h objfile.h z80asm.h
directives.o: codearea.h lib/array.h lib/class.h lib/alloc.h lib/dbg.h
directives.o: lib/types.h lib/queue.h lib/strutil.h lib/classhash.h
directives.o: lib/strhash.h lib/uthash.h directives.h errors.h errors_def.h
directives.o: lib/fileutil.h lib/list.h lib/utarray.h model.h module.h
directives.o: lib/classlist.h expr.h scan.h scan_tokens.h opcodes.h options.h
directives.o: options_def.h sym.h symref.h symtab.h parse.h lib/strpool.h
directives.o: z80asm.h
errors.o: errors.h errors_def.h lib/fileutil.h lib/list.h lib/class.h
errors.o: lib/alloc.h lib/dbg.h lib/types.h lib/queue.h lib/strutil.h
errors.o: lib/utarray.h options.h options_def.h lib/srcfile.h lib/strpool.h
errors.o: lib/strhash.h lib/uthash.h lib/init.h
expr.o: lib/array.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h
expr.o: lib/strutil.h codearea.h lib/classhash.h lib/strhash.h lib/uthash.h
expr.o: expr.h lib/classlist.h scan.h scan_tokens.h opcodes.h errors.h
expr.o: errors_def.h options.h lib/utarray.h options_def.h sym.h symref.h
expr.o: lib/init.h model.h lib/list.h module.h symtab.h lib/strpool.h
expr.o: expr_def.h
hist.o: hist.h
libfile.o: errors.h errors_def.h lib/fileutil.h lib/list.h lib/class.h
libfile.o: lib/alloc.h lib/dbg.h lib/types.h lib/queue.h lib/strutil.h
libfile.o: lib/utarray.h libfile.h objfile.h lib/array.h module.h
libfile.o: lib/classlist.h lib/classhash.h lib/strhash.h lib/uthash.h
libfile.o: codearea.h expr.h scan.h scan_tokens.h opcodes.h options.h
libfile.o: options_def.h sym.h symref.h symtab.h
listfile.o: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
listfile.o: lib/queue.h lib/strutil.h symref.h lib/classlist.h lib/fileutil.h
listfile.o: lib/list.h lib/utarray.h options.h options_def.h z80asm.h sym.h
listfile.o: expr.h lib/array.h scan.h scan_tokens.h opcodes.h errors.h
listfile.o: errors_def.h hist.h lib/strpool.h codearea.h lib/classhash.h
listfile.o: lib/strhash.h lib/uthash.h
mapfile.o: lib/fileutil.h lib/list.h lib/class.h lib/alloc.h lib/dbg.h
mapfile.o: lib/types.h lib/queue.h lib/strutil.h lib/utarray.h listfile.h
mapfile.o: symref.h lib/classlist.h mapfile.h options.h options_def.h
mapfile.o: lib/strpool.h symbol.h expr.h lib/array.h scan.h scan_tokens.h
mapfile.o: opcodes.h errors.h errors_def.h sym.h model.h module.h
mapfile.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h symtab.h
mapfile.o: objfile.h z80asm.h
model.o: model.h lib/list.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
model.o: lib/queue.h module.h lib/classlist.h lib/classhash.h lib/strhash.h
model.o: lib/uthash.h codearea.h lib/array.h lib/strutil.h expr.h scan.h
model.o: scan_tokens.h opcodes.h errors.h errors_def.h options.h
model.o: lib/utarray.h options_def.h sym.h symref.h symtab.h lib/init.h
model.o: listfile.h lib/srcfile.h
modlink.o: lib/alloc.h lib/dbg.h lib/types.h codearea.h lib/array.h
modlink.o: lib/class.h lib/queue.h lib/strutil.h lib/classhash.h
modlink.o: lib/strhash.h lib/uthash.h errors.h errors_def.h expr.h
modlink.o: lib/classlist.h scan.h scan_tokens.h opcodes.h options.h
modlink.o: lib/utarray.h options_def.h sym.h symref.h lib/fileutil.h
modlink.o: lib/list.h listfile.h modlink.h lib/strpool.h symbol.h model.h
modlink.o: module.h symtab.h objfile.h z80asm.h
module.o: codearea.h lib/array.h lib/class.h lib/alloc.h lib/dbg.h
module.o: lib/types.h lib/queue.h lib/strutil.h lib/classhash.h lib/strhash.h
module.o: lib/uthash.h lib/init.h module.h lib/classlist.h expr.h scan.h
module.o: scan_tokens.h opcodes.h errors.h errors_def.h options.h
module.o: lib/utarray.h options_def.h sym.h symref.h symtab.h lib/strpool.h
objfile.o: lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h
objfile.o: codearea.h lib/array.h lib/strutil.h lib/classhash.h lib/strhash.h
objfile.o: lib/uthash.h errors.h errors_def.h lib/fileutil.h lib/list.h
objfile.o: lib/utarray.h options.h options_def.h model.h module.h
objfile.o: lib/classlist.h expr.h scan.h scan_tokens.h opcodes.h sym.h
objfile.o: symref.h symtab.h objfile.h lib/strpool.h
opcodes.o: directives.h expr.h lib/array.h lib/class.h lib/alloc.h lib/dbg.h
opcodes.o: lib/types.h lib/queue.h lib/strutil.h lib/classlist.h scan.h
opcodes.o: scan_tokens.h opcodes.h errors.h errors_def.h options.h
opcodes.o: lib/utarray.h options_def.h sym.h symref.h codearea.h
opcodes.o: lib/classhash.h lib/strhash.h lib/uthash.h model.h lib/list.h
opcodes.o: module.h symtab.h parse.h z80asm.h
options.o: errors.h errors_def.h lib/fileutil.h lib/list.h lib/class.h
options.o: lib/alloc.h lib/dbg.h lib/types.h lib/queue.h lib/strutil.h
options.o: lib/utarray.h hist.h lib/init.h model.h module.h lib/classlist.h
options.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h lib/array.h
options.o: expr.h scan.h scan_tokens.h opcodes.h options.h options_def.h
options.o: sym.h symref.h symtab.h lib/srcfile.h lib/strpool.h z80asm.h
parse.o: lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h codearea.h
parse.o: lib/array.h lib/strutil.h lib/classhash.h lib/strhash.h lib/uthash.h
parse.o: directives.h expr.h lib/classlist.h scan.h scan_tokens.h opcodes.h
parse.o: errors.h errors_def.h options.h lib/utarray.h options_def.h sym.h
parse.o: symref.h listfile.h model.h lib/list.h module.h symtab.h parse.h
parse.o: lib/strpool.h parse_rules.h
scan.o: lib/alloc.h lib/dbg.h lib/types.h errors.h errors_def.h lib/init.h
scan.o: lib/list.h lib/class.h lib/queue.h model.h module.h lib/classlist.h
scan.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h lib/array.h
scan.o: lib/strutil.h expr.h scan.h scan_tokens.h opcodes.h options.h
scan.o: lib/utarray.h options_def.h sym.h symref.h symtab.h scan_rules.h
sym.o: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h
sym.o: lib/strutil.h symref.h lib/classlist.h options.h lib/utarray.h
sym.o: options_def.h lib/strpool.h sym.h symbol.h expr.h lib/array.h scan.h
sym.o: scan_tokens.h opcodes.h errors.h errors_def.h model.h lib/list.h
sym.o: module.h lib/classhash.h lib/strhash.h lib/uthash.h codearea.h
sym.o: symtab.h objfile.h
symref.o: options.h lib/types.h lib/utarray.h lib/dbg.h lib/alloc.h
symref.o: options_def.h symref.h lib/class.h lib/queue.h lib/classlist.h
symtab.o: errors.h errors_def.h listfile.h lib/class.h lib/alloc.h lib/dbg.h
symtab.o: lib/types.h lib/queue.h lib/strutil.h symref.h lib/classlist.h
symtab.o: model.h lib/list.h module.h lib/classhash.h lib/strhash.h
symtab.o: lib/uthash.h codearea.h lib/array.h expr.h scan.h scan_tokens.h
symtab.o: opcodes.h options.h lib/utarray.h options_def.h sym.h symtab.h
symtab.o: symbol.h objfile.h z80asm.h
z80asm.o: lib/alloc.h lib/dbg.h lib/types.h directives.h codearea.h
z80asm.o: lib/array.h lib/class.h lib/queue.h lib/strutil.h lib/classhash.h
z80asm.o: lib/strhash.h lib/uthash.h deffile.h errors.h errors_def.h expr.h
z80asm.o: lib/classlist.h scan.h scan_tokens.h opcodes.h options.h
z80asm.o: lib/utarray.h options_def.h sym.h symref.h lib/fileutil.h
z80asm.o: lib/list.h hist.h libfile.h listfile.h mapfile.h modlink.h
z80asm.o: objfile.h module.h symtab.h parse.h lib/strpool.h symbol.h model.h
z80asm.o: z80asm.h
z80pass.o: directives.h codearea.h lib/array.h lib/class.h lib/alloc.h
z80pass.o: lib/dbg.h lib/types.h lib/queue.h lib/strutil.h lib/classhash.h
z80pass.o: lib/strhash.h lib/uthash.h errors.h errors_def.h expr.h
z80pass.o: lib/classlist.h scan.h scan_tokens.h opcodes.h options.h
z80pass.o: lib/utarray.h options_def.h sym.h symref.h lib/fileutil.h
z80pass.o: lib/list.h hist.h listfile.h model.h module.h symtab.h modlink.h
z80pass.o: parse.h lib/srcfile.h symbol.h objfile.h z80asm.h
lib/alloc.o: lib/alloc.h lib/dbg.h lib/types.h lib/init.h lib/utlist.h
lib/array.o: lib/array.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
lib/array.o: lib/queue.h lib/strutil.h
lib/class.o: lib/alloc.h lib/dbg.h lib/types.h lib/class.h lib/queue.h
lib/class.o: lib/init.h lib/strpool.h
lib/dbg.o: lib/dbg.h
lib/fileutil.o: lib/alloc.h lib/dbg.h lib/types.h lib/fileutil.h lib/list.h
lib/fileutil.o: lib/class.h lib/queue.h lib/strutil.h lib/utarray.h
lib/fileutil.o: lib/strpool.h lib/uthash.h
lib/list.o: lib/alloc.h lib/dbg.h lib/types.h lib/list.h lib/class.h
lib/list.o: lib/queue.h
lib/minunit.o: lib/minunit.h lib/dbg.h
lib/srcfile.o: lib/alloc.h lib/dbg.h lib/types.h lib/srcfile.h lib/class.h
lib/srcfile.o: lib/queue.h lib/list.h lib/strutil.h lib/utarray.h
lib/srcfile.o: lib/fileutil.h lib/strpool.h
lib/strhash.o: lib/alloc.h lib/dbg.h lib/types.h lib/strhash.h lib/class.h
lib/strhash.o: lib/queue.h lib/uthash.h lib/strpool.h lib/strutil.h
lib/strpool.o: lib/alloc.h lib/dbg.h lib/types.h lib/init.h lib/strpool.h
lib/strpool.o: lib/uthash.h
lib/strutil.o: lib/alloc.h lib/dbg.h lib/types.h lib/strpool.h lib/strutil.h
lib/strutil.o: lib/class.h lib/queue.h
t/test_codearea.o: codearea.h lib/array.h lib/class.h lib/alloc.h lib/dbg.h
t/test_codearea.o: lib/types.h lib/queue.h lib/strutil.h lib/classhash.h
t/test_codearea.o: lib/strhash.h lib/uthash.h options.h lib/utarray.h
t/test_codearea.o: options_def.h
t/test_symtab.o: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
t/test_symtab.o: lib/queue.h lib/strutil.h symref.h lib/classlist.h model.h
t/test_symtab.o: lib/list.h module.h lib/classhash.h lib/strhash.h
t/test_symtab.o: lib/uthash.h codearea.h lib/array.h expr.h scan.h
t/test_symtab.o: scan_tokens.h opcodes.h errors.h errors_def.h options.h
t/test_symtab.o: lib/utarray.h options_def.h sym.h symtab.h
t/testlib.o: lib/dbg.h t/testlib.h
