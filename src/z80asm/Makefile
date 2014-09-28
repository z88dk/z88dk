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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Makefile,v 1.171 2014-09-28 17:37:14 pauloscustodio Exp $

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
TEST_SRC_MAIN:= $(wildcard t/test_*.c lib/t/test_*.c)
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
	$(RM) *.core $(LOCAL_LIB)/*.core $(LOCAL_LIB)/t/*.core
	$(RM) *.o    $(LOCAL_LIB)/*.o    $(LOCAL_LIB)/t/*.o 
	$(RM) *.out  $(LOCAL_LIB)/*.out  $(LOCAL_LIB)/t/*.out
	$(RM) *.orig $(LOCAL_LIB)/*.orig $(LOCAL_LIB)/t/*.orig
	$(RM) *.exe  $(LOCAL_LIB)/*.exe  $(LOCAL_LIB)/t/*.exe
	$(RM) *.tmp  $(LOCAL_LIB)/*.tmp  $(LOCAL_LIB)/t/*.tmp
	$(RM) *.bak  $(LOCAL_LIB)/*.bak  $(LOCAL_LIB)/t/*.bak
	$(RM) *~     $(LOCAL_LIB)/*~     $(LOCAL_LIB)/t/*~
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
	$(MAKE) legacy
	$(MAKE) prove
	$(MAKE) new
	$(MAKE) prove
	$(MAKE) test_enigma

prove: prove_c prove_perl

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
	$(RM) t/*.tmp $(LOCAL_LIB)/t/*.tmp t/developer/*.tmp 
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

asmdrctv.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
asmdrctv.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
asmdrctv.o: lib/uthash.h errors.h errors_def.h expr.h lib/classlist.h scan.h
asmdrctv.o: scan_def.h legacy.h sym.h symref.h lib/fileutil.h lib/list.h
asmdrctv.o: listfile.h expr_def.h options.h options_def.h lib/strpool.h
asmdrctv.o: symbol.h model.h module.h symtab.h objfile.h z80asm.h
codearea.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
codearea.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
codearea.o: lib/uthash.h errors.h errors_def.h lib/fileutil.h lib/list.h
codearea.o: lib/init.h listfile.h symref.h lib/classlist.h options.h
codearea.o: options_def.h lib/strpool.h z80asm.h sym.h expr.h scan.h
codearea.o: scan_def.h legacy.h
deffile.o: lib/xmalloc.h deffile.h lib/fileutil.h lib/list.h lib/class.h
deffile.o: lib/queue.h lib/types.h lib/strutil.h listfile.h symref.h
deffile.o: lib/classlist.h options.h options_def.h symbol.h expr.h
deffile.o: lib/array.h scan.h scan_def.h legacy.h sym.h model.h module.h
deffile.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h symtab.h
deffile.o: objfile.h z80asm.h
errors.o: lib/xmalloc.h errors.h errors_def.h lib/except.h lib/types.h
errors.o: lib/fileutil.h lib/list.h lib/class.h lib/queue.h lib/strutil.h
errors.o: options.h options_def.h lib/srcfile.h lib/strpool.h lib/strhash.h
errors.o: lib/uthash.h lib/init.h
expr.o: lib/xmalloc.h lib/array.h lib/class.h lib/queue.h lib/types.h
expr.o: lib/strutil.h codearea.h lib/classhash.h lib/strhash.h lib/uthash.h
expr.o: expr.h lib/classlist.h scan.h scan_def.h legacy.h sym.h symref.h
expr.o: errors.h errors_def.h lib/init.h model.h lib/list.h module.h symtab.h
expr.o: lib/strpool.h expr_def.h
exprprsr.o: lib/xmalloc.h lib/class.h lib/queue.h lib/types.h codearea.h
exprprsr.o: lib/array.h lib/strutil.h lib/classhash.h lib/strhash.h
exprprsr.o: lib/uthash.h errors.h errors_def.h expr.h lib/classlist.h scan.h
exprprsr.o: scan_def.h legacy.h sym.h symref.h lib/fileutil.h lib/list.h
exprprsr.o: options.h options_def.h symbol.h model.h module.h symtab.h
exprprsr.o: objfile.h lib/except.h expr_def.h z80asm.h
hist.o: lib/xmalloc.h hist.h
ldinstr.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
ldinstr.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
ldinstr.o: lib/uthash.h errors.h errors_def.h options.h lib/list.h
ldinstr.o: options_def.h scan.h scan_def.h legacy.h symbol.h expr.h
ldinstr.o: lib/classlist.h sym.h symref.h model.h module.h symtab.h objfile.h
ldinstr.o: z80asm.h
libfile.o: lib/xmalloc.h errors.h errors_def.h lib/fileutil.h lib/list.h
libfile.o: lib/class.h lib/queue.h lib/types.h lib/strutil.h legacy.h
libfile.o: libfile.h objfile.h lib/array.h module.h lib/classlist.h
libfile.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h expr.h
libfile.o: scan.h scan_def.h sym.h symref.h symtab.h options.h options_def.h
listfile.o: lib/xmalloc.h listfile.h lib/class.h lib/queue.h lib/types.h
listfile.o: lib/strutil.h symref.h lib/classlist.h lib/fileutil.h lib/list.h
listfile.o: options.h options_def.h z80asm.h sym.h expr.h lib/array.h scan.h
listfile.o: scan_def.h legacy.h errors.h errors_def.h hist.h lib/strpool.h
listfile.o: codearea.h lib/classhash.h lib/strhash.h lib/uthash.h
mapfile.o: lib/xmalloc.h lib/fileutil.h lib/list.h lib/class.h lib/queue.h
mapfile.o: lib/types.h lib/strutil.h listfile.h symref.h lib/classlist.h
mapfile.o: mapfile.h options.h options_def.h lib/strpool.h symbol.h expr.h
mapfile.o: lib/array.h scan.h scan_def.h legacy.h sym.h model.h module.h
mapfile.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h symtab.h
mapfile.o: objfile.h z80asm.h
model.o: lib/xmalloc.h model.h lib/list.h lib/class.h lib/queue.h lib/types.h
model.o: module.h lib/classlist.h lib/classhash.h lib/strhash.h lib/uthash.h
model.o: codearea.h lib/array.h lib/strutil.h expr.h scan.h scan_def.h
model.o: legacy.h sym.h symref.h symtab.h errors.h errors_def.h lib/init.h
model.o: listfile.h options.h options_def.h lib/srcfile.h
modlink.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
modlink.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
modlink.o: lib/uthash.h errors.h errors_def.h lib/except.h expr.h
modlink.o: lib/classlist.h scan.h scan_def.h legacy.h sym.h symref.h
modlink.o: lib/fileutil.h lib/list.h listfile.h modlink.h options.h
modlink.o: options_def.h lib/strpool.h symbol.h model.h module.h symtab.h
modlink.o: objfile.h z80asm.h
module.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
module.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
module.o: lib/uthash.h lib/init.h module.h lib/classlist.h expr.h scan.h
module.o: scan_def.h legacy.h sym.h symref.h symtab.h lib/strpool.h
objfile.o: lib/xmalloc.h lib/class.h lib/queue.h lib/types.h codearea.h
objfile.o: lib/array.h lib/strutil.h lib/classhash.h lib/strhash.h
objfile.o: lib/uthash.h errors.h errors_def.h lib/fileutil.h lib/list.h
objfile.o: options.h options_def.h model.h module.h lib/classlist.h expr.h
objfile.o: scan.h scan_def.h legacy.h sym.h symref.h symtab.h objfile.h
objfile.o: lib/strpool.h
options.o: lib/xmalloc.h errors.h errors_def.h lib/fileutil.h lib/list.h
options.o: lib/class.h lib/queue.h lib/types.h lib/strutil.h hist.h
options.o: lib/init.h model.h module.h lib/classlist.h lib/classhash.h
options.o: lib/strhash.h lib/uthash.h codearea.h lib/array.h expr.h scan.h
options.o: scan_def.h legacy.h sym.h symref.h symtab.h options.h
options.o: options_def.h lib/srcfile.h lib/strpool.h z80asm.h
prsident.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
prsident.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
prsident.o: lib/uthash.h errors.h errors_def.h listfile.h symref.h
prsident.o: lib/classlist.h options.h lib/list.h options_def.h scan.h
prsident.o: scan_def.h legacy.h symbol.h expr.h sym.h model.h module.h
prsident.o: symtab.h objfile.h z80asm.h
prsline.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
prsline.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
prsline.o: lib/uthash.h errors.h errors_def.h listfile.h symref.h
prsline.o: lib/classlist.h options.h lib/list.h options_def.h scan.h
prsline.o: scan_def.h legacy.h symbol.h expr.h sym.h model.h module.h
prsline.o: symtab.h objfile.h z80asm.h
scan.o: lib/xmalloc.h errors.h errors_def.h lib/init.h lib/types.h lib/list.h
scan.o: lib/class.h lib/queue.h model.h module.h lib/classlist.h
scan.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h lib/array.h
scan.o: lib/strutil.h expr.h scan.h scan_def.h legacy.h sym.h symref.h
scan.o: symtab.h scan_rules.h
sym.o: lib/xmalloc.h listfile.h lib/class.h lib/queue.h lib/types.h
sym.o: lib/strutil.h symref.h lib/classlist.h options.h lib/list.h
sym.o: options_def.h lib/strpool.h sym.h symbol.h expr.h lib/array.h scan.h
sym.o: scan_def.h legacy.h model.h module.h lib/classhash.h lib/strhash.h
sym.o: lib/uthash.h codearea.h symtab.h objfile.h
symref.o: lib/xmalloc.h options.h lib/types.h lib/list.h lib/class.h
symref.o: lib/queue.h options_def.h symref.h lib/classlist.h
symtab.o: lib/xmalloc.h errors.h errors_def.h listfile.h lib/class.h
symtab.o: lib/queue.h lib/types.h lib/strutil.h symref.h lib/classlist.h
symtab.o: model.h lib/list.h module.h lib/classhash.h lib/strhash.h
symtab.o: lib/uthash.h codearea.h lib/array.h expr.h scan.h scan_def.h
symtab.o: legacy.h sym.h symtab.h options.h options_def.h symbol.h objfile.h
symtab.o: z80asm.h
z80asm.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
z80asm.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
z80asm.o: lib/uthash.h deffile.h errors.h errors_def.h lib/except.h expr.h
z80asm.o: lib/classlist.h scan.h scan_def.h legacy.h sym.h symref.h
z80asm.o: lib/fileutil.h lib/list.h hist.h libfile.h listfile.h mapfile.h
z80asm.o: modlink.h objfile.h module.h symtab.h options.h options_def.h
z80asm.o: lib/strpool.h symbol.h model.h z80asm.h
z80instr.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
z80instr.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
z80instr.o: lib/uthash.h errors.h errors_def.h expr.h lib/classlist.h scan.h
z80instr.o: scan_def.h legacy.h sym.h symref.h options.h lib/list.h
z80instr.o: options_def.h symbol.h model.h module.h symtab.h objfile.h
z80instr.o: z80asm.h
z80pass.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h lib/queue.h
z80pass.o: lib/types.h lib/strutil.h lib/classhash.h lib/strhash.h
z80pass.o: lib/uthash.h errors.h errors_def.h expr.h lib/classlist.h scan.h
z80pass.o: scan_def.h legacy.h sym.h symref.h lib/fileutil.h lib/list.h
z80pass.o: hist.h listfile.h model.h module.h symtab.h modlink.h options.h
z80pass.o: options_def.h lib/srcfile.h symbol.h objfile.h z80asm.h
lib/array.o: lib/xmalloc.h lib/array.h lib/class.h lib/queue.h lib/types.h
lib/array.o: lib/strutil.h
lib/class.o: lib/xmalloc.h lib/class.h lib/queue.h lib/types.h lib/init.h
lib/class.o: lib/strpool.h
lib/dlist.o: lib/xmalloc.h lib/dlist.h
lib/except.o: lib/xmalloc.h lib/except.h lib/types.h
lib/fileutil.o: lib/xmalloc.h lib/fileutil.h lib/list.h lib/class.h
lib/fileutil.o: lib/queue.h lib/types.h lib/strutil.h lib/strpool.h
lib/fileutil.o: lib/uthash.h
lib/list.o: lib/xmalloc.h lib/list.h lib/class.h lib/queue.h lib/types.h
lib/srcfile.o: lib/xmalloc.h lib/srcfile.h lib/class.h lib/queue.h
lib/srcfile.o: lib/types.h lib/list.h lib/strutil.h lib/fileutil.h
lib/srcfile.o: lib/strpool.h
lib/strhash.o: lib/xmalloc.h lib/strhash.h lib/types.h lib/class.h
lib/strhash.o: lib/queue.h lib/uthash.h lib/strpool.h lib/strutil.h
lib/strpool.o: lib/xmalloc.h lib/init.h lib/types.h lib/queue.h lib/strpool.h
lib/strpool.o: lib/uthash.h
lib/strutil.o: lib/xmalloc.h lib/strpool.h lib/strutil.h lib/class.h
lib/strutil.o: lib/queue.h lib/types.h
lib/xmalloc.o: lib/xmalloc.h lib/dlist.h lib/init.h lib/types.h
t/test_codearea.o: lib/xmalloc.h codearea.h lib/array.h lib/class.h
t/test_codearea.o: lib/queue.h lib/types.h lib/strutil.h lib/classhash.h
t/test_codearea.o: lib/strhash.h lib/uthash.h options.h lib/list.h
t/test_codearea.o: options_def.h
t/test_symtab.o: lib/xmalloc.h listfile.h lib/class.h lib/queue.h lib/types.h
t/test_symtab.o: lib/strutil.h symref.h lib/classlist.h model.h lib/list.h
t/test_symtab.o: module.h lib/classhash.h lib/strhash.h lib/uthash.h
t/test_symtab.o: codearea.h lib/array.h expr.h scan.h scan_def.h legacy.h
t/test_symtab.o: sym.h symtab.h options.h options_def.h
lib/t/test_dlist.o: lib/xmalloc.h lib/dlist.h
lib/t/test_init.o: lib/xmalloc.h lib/init.h lib/types.h
lib/t/test_xmalloc.o: lib/xmalloc.h
t/testlib.o: lib/xmalloc.h t/testlib.h
