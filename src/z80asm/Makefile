# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm

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
.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

#------------------------------------------------------------------------------
# developer generated source files, and test libs
#------------------------------------------------------------------------------
.PHONY: dev
dev:
	$(MAKE) -C tt
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
	$(MAKE) dev
	$(MAKE) prove_c
	$(MAKE) prove_perl
	$(MAKE) test_enigma

testlib:
	$(MAKE) -C lib test

prove_c: t/libtestlib.a $(TEST_SRC_MAIN:.c=.o) $(TEST_SRC_MAIN:.c=.out)

prove_perl: $(TARGET)
	perl -S prove t/*.t

testmsvc : $(MSVC_TARGET)
	make Z80ASM=$(MSVC_TARGET) prove

test_enigma: $(TARGET)
	zcc +cpm -oenigma.bin -vn t/data/enigma.c
	echo HELLO. | cpm enigma.bin > enigma.out
	echo 'Enter text to be (de)coded, finish with a .' > enigma.bmk
	echo 'HREXLSLEOC .' >> enigma.bmk
	diff -w enigma.bmk enigma.out
	$(RM) zcc_opt.def enigma.bin enigma.out enigma.bmk

testzcc : $(TARGET)
	zcc +zx -lndos       -create-app -omicroman.bin ../../examples/microman.c
	zcc +zx -lndos -lmzx -create-app -omandel.bin   ../../examples/graphics/mandel.c
	eightyone microman.tap
	eightyone mandel.tap

clean::
	$(RM) $(TARGET) $(LOCAL_LIB)/$(TARGET) test* $(LOCAL_LIB)/test*
	$(RM) t/*.tmp $(LOCAL_LIB)/t/*.tmp t/dev/*.tmp 
	$(RM) microman.bin microman.tap mandel.bin mandel.tap zcc_opt.def
	$(RM) enigma.* crt0.*

#------------------------------------------------------------------------------
# build with msvc - need to build manualy, devenv not available in Express
#------------------------------------------------------------------------------
$(MSVC_TARGET) : $(wildcard *.c) $(wildcard *.h)
	@echo Build z80asm inside Microsoft Visual C++ 2010 Express
	@exit 1

#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
depend:
	makedepend -Y -I. -I$(LOCAL_LIB) $(SRCS) $(TEST_SRC_MAIN) $(TEST_SRC_LIB)
	
# DO NOT DELETE

codearea.o: codearea.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
codearea.o: lib/class.h lib/queue.h lib/str.h lib/classhash.h lib/strhash.h
codearea.o: lib/uthash.h errors.h error_func.h lib/fileutil.h lib/utarray.h
codearea.o: lib/init.h listfile.h symref.h lib/classlist.h options.h
codearea.o: options_def.h lib/strpool.h z80asm.h sym.h expr.h scan.h tokens.h
codearea.o: opcodes.h
deffile.o: deffile.h lib/fileutil.h lib/types.h lib/str.h lib/alloc.h
deffile.o: lib/dbg.h lib/utarray.h listfile.h lib/class.h lib/queue.h
deffile.o: symref.h lib/classlist.h options.h options_def.h symbol.h expr.h
deffile.o: lib/array.h scan.h tokens.h opcodes.h errors.h error_func.h sym.h
deffile.o: model.h lib/list.h module.h lib/classhash.h lib/strhash.h
deffile.o: lib/uthash.h codearea.h symtab.h objfile.h z80asm.h
directives.o: codearea.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
directives.o: lib/class.h lib/queue.h lib/str.h lib/classhash.h lib/strhash.h
directives.o: lib/uthash.h directives.h errors.h error_func.h lib/fileutil.h
directives.o: lib/utarray.h model.h lib/list.h module.h lib/classlist.h
directives.o: expr.h scan.h tokens.h opcodes.h options.h options_def.h sym.h
directives.o: symref.h symtab.h parse.h lib/strpool.h z80asm.h
error_func.o: errors.h error_func.h lib/str.h lib/alloc.h lib/dbg.h
error_func.o: lib/types.h
errors.o: errors.h error_func.h lib/fileutil.h lib/types.h lib/str.h
errors.o: lib/alloc.h lib/dbg.h lib/utarray.h options.h options_def.h
errors.o: lib/srcfile.h lib/class.h lib/queue.h lib/list.h lib/strpool.h
errors.o: lib/strhash.h lib/uthash.h lib/init.h
expr.o: lib/array.h lib/alloc.h lib/dbg.h lib/types.h lib/class.h lib/queue.h
expr.o: lib/str.h codearea.h lib/classhash.h lib/strhash.h lib/uthash.h
expr.o: expr.h lib/classlist.h scan.h tokens.h opcodes.h errors.h
expr.o: error_func.h options.h lib/utarray.h options_def.h sym.h symref.h
expr.o: lib/init.h model.h lib/list.h module.h symtab.h lib/strpool.h
expr.o: expr_def.h
hist.o: hist.h
libfile.o: errors.h error_func.h lib/fileutil.h lib/types.h lib/str.h
libfile.o: lib/alloc.h lib/dbg.h lib/utarray.h libfile.h objfile.h
libfile.o: lib/array.h lib/class.h lib/queue.h module.h lib/classlist.h
libfile.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h expr.h
libfile.o: scan.h tokens.h opcodes.h options.h options_def.h sym.h symref.h
libfile.o: symtab.h
listfile.o: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
listfile.o: lib/queue.h lib/str.h symref.h lib/classlist.h lib/fileutil.h
listfile.o: lib/utarray.h options.h options_def.h z80asm.h sym.h expr.h
listfile.o: lib/array.h scan.h tokens.h opcodes.h errors.h error_func.h
listfile.o: hist.h lib/strpool.h codearea.h lib/classhash.h lib/strhash.h
listfile.o: lib/uthash.h
mapfile.o: lib/fileutil.h lib/types.h lib/str.h lib/alloc.h lib/dbg.h
mapfile.o: lib/utarray.h listfile.h lib/class.h lib/queue.h symref.h
mapfile.o: lib/classlist.h mapfile.h options.h options_def.h lib/strpool.h
mapfile.o: symbol.h expr.h lib/array.h scan.h tokens.h opcodes.h errors.h
mapfile.o: error_func.h sym.h model.h lib/list.h module.h lib/classhash.h
mapfile.o: lib/strhash.h lib/uthash.h codearea.h symtab.h objfile.h z80asm.h
model.o: model.h lib/list.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
model.o: lib/queue.h module.h lib/classlist.h lib/classhash.h lib/strhash.h
model.o: lib/uthash.h codearea.h lib/array.h lib/str.h expr.h scan.h tokens.h
model.o: opcodes.h errors.h error_func.h options.h lib/utarray.h
model.o: options_def.h sym.h symref.h symtab.h lib/init.h listfile.h
model.o: lib/srcfile.h
modlink.o: lib/alloc.h lib/dbg.h lib/types.h codearea.h lib/array.h
modlink.o: lib/class.h lib/queue.h lib/str.h lib/classhash.h lib/strhash.h
modlink.o: lib/uthash.h errors.h error_func.h expr.h lib/classlist.h scan.h
modlink.o: tokens.h opcodes.h options.h lib/utarray.h options_def.h sym.h
modlink.o: symref.h lib/fileutil.h listfile.h modlink.h lib/strpool.h
modlink.o: symbol.h model.h lib/list.h module.h symtab.h objfile.h z80asm.h
module.o: codearea.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
module.o: lib/class.h lib/queue.h lib/str.h lib/classhash.h lib/strhash.h
module.o: lib/uthash.h lib/init.h module.h lib/classlist.h expr.h scan.h
module.o: tokens.h opcodes.h errors.h error_func.h options.h lib/utarray.h
module.o: options_def.h sym.h symref.h symtab.h lib/strpool.h
objfile.o: lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h
objfile.o: codearea.h lib/array.h lib/str.h lib/classhash.h lib/strhash.h
objfile.o: lib/uthash.h errors.h error_func.h lib/fileutil.h lib/utarray.h
objfile.o: options.h options_def.h model.h lib/list.h module.h
objfile.o: lib/classlist.h expr.h scan.h tokens.h opcodes.h sym.h symref.h
objfile.o: symtab.h objfile.h lib/strpool.h
opcodes.o: directives.h expr.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
opcodes.o: lib/class.h lib/queue.h lib/str.h lib/classlist.h scan.h tokens.h
opcodes.o: opcodes.h errors.h error_func.h options.h lib/utarray.h
opcodes.o: options_def.h sym.h symref.h codearea.h lib/classhash.h
opcodes.o: lib/strhash.h lib/uthash.h model.h lib/list.h module.h symtab.h
opcodes.o: parse.h z80asm.h
options.o: errors.h error_func.h lib/fileutil.h lib/types.h lib/str.h
options.o: lib/alloc.h lib/dbg.h lib/utarray.h hist.h lib/init.h model.h
options.o: lib/list.h lib/class.h lib/queue.h module.h lib/classlist.h
options.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h lib/array.h
options.o: expr.h scan.h tokens.h opcodes.h options.h options_def.h sym.h
options.o: symref.h symtab.h lib/srcfile.h lib/strpool.h z80asm.h
parse.o: lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h codearea.h
parse.o: lib/array.h lib/str.h lib/classhash.h lib/strhash.h lib/uthash.h
parse.o: directives.h expr.h lib/classlist.h scan.h tokens.h opcodes.h
parse.o: errors.h error_func.h options.h lib/utarray.h options_def.h sym.h
parse.o: symref.h listfile.h model.h lib/list.h module.h symtab.h parse.h
parse.o: lib/strpool.h parse_rules.h
scan.o: lib/alloc.h lib/dbg.h lib/types.h errors.h error_func.h lib/init.h
scan.o: lib/list.h lib/class.h lib/queue.h model.h module.h lib/classlist.h
scan.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h lib/array.h
scan.o: lib/str.h expr.h scan.h tokens.h opcodes.h options.h lib/utarray.h
scan.o: options_def.h sym.h symref.h symtab.h scan_rules.h
sym.o: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h
sym.o: lib/str.h symref.h lib/classlist.h options.h lib/utarray.h
sym.o: options_def.h lib/strpool.h sym.h symbol.h expr.h lib/array.h scan.h
sym.o: tokens.h opcodes.h errors.h error_func.h model.h lib/list.h module.h
sym.o: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h symtab.h
sym.o: objfile.h
symref.o: options.h lib/types.h lib/utarray.h lib/dbg.h lib/alloc.h
symref.o: options_def.h symref.h lib/class.h lib/queue.h lib/classlist.h
symtab.o: errors.h error_func.h listfile.h lib/class.h lib/alloc.h lib/dbg.h
symtab.o: lib/types.h lib/queue.h lib/str.h symref.h lib/classlist.h model.h
symtab.o: lib/list.h module.h lib/classhash.h lib/strhash.h lib/uthash.h
symtab.o: codearea.h lib/array.h expr.h scan.h tokens.h opcodes.h options.h
symtab.o: lib/utarray.h options_def.h sym.h symtab.h symbol.h objfile.h
symtab.o: z80asm.h
z80asm.o: deffile.h directives.h lib/fileutil.h lib/types.h lib/str.h
z80asm.o: lib/alloc.h lib/dbg.h lib/utarray.h libfile.h listfile.h
z80asm.o: lib/class.h lib/queue.h symref.h lib/classlist.h mapfile.h
z80asm.o: modlink.h expr.h lib/array.h scan.h tokens.h opcodes.h errors.h
z80asm.o: error_func.h options.h options_def.h sym.h module.h lib/classhash.h
z80asm.o: lib/strhash.h lib/uthash.h codearea.h symtab.h objfile.h parse.h
z80asm.o: lib/strpool.h symbol.h model.h lib/list.h
z80pass.o: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
z80pass.o: lib/queue.h lib/str.h symref.h lib/classlist.h modlink.h expr.h
z80pass.o: lib/array.h scan.h tokens.h opcodes.h errors.h error_func.h
z80pass.o: options.h lib/utarray.h options_def.h sym.h symbol.h model.h
z80pass.o: lib/list.h module.h lib/classhash.h lib/strhash.h lib/uthash.h
z80pass.o: codearea.h symtab.h objfile.h
lib/alloc.o: lib/alloc.h lib/dbg.h lib/types.h lib/init.h lib/utlist.h
lib/array.o: lib/array.h lib/alloc.h lib/dbg.h lib/types.h lib/class.h
lib/array.o: lib/queue.h lib/str.h
lib/class.o: lib/alloc.h lib/dbg.h lib/types.h lib/class.h lib/queue.h
lib/class.o: lib/init.h lib/strpool.h
lib/dbg.o: lib/dbg.h
lib/fileutil.o: lib/alloc.h lib/dbg.h lib/types.h lib/class.h lib/queue.h
lib/fileutil.o: lib/fileutil.h lib/str.h lib/utarray.h lib/init.h
lib/fileutil.o: lib/strpool.h lib/uthash.h
lib/list.o: lib/alloc.h lib/dbg.h lib/types.h lib/list.h lib/class.h
lib/list.o: lib/queue.h
lib/minunit.o: lib/minunit.h lib/dbg.h
lib/srcfile.o: lib/alloc.h lib/dbg.h lib/types.h lib/srcfile.h lib/class.h
lib/srcfile.o: lib/queue.h lib/list.h lib/str.h lib/utarray.h lib/fileutil.h
lib/srcfile.o: lib/strpool.h
lib/str.o: lib/str.h lib/alloc.h lib/dbg.h lib/types.h
lib/strhash.o: lib/alloc.h lib/dbg.h lib/types.h lib/strhash.h lib/class.h
lib/strhash.o: lib/queue.h lib/uthash.h lib/strpool.h lib/str.h
lib/strpool.o: lib/alloc.h lib/dbg.h lib/types.h lib/init.h lib/strpool.h
lib/strpool.o: lib/uthash.h
t/test_codearea.o: codearea.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
t/test_codearea.o: lib/class.h lib/queue.h lib/str.h lib/classhash.h
t/test_codearea.o: lib/strhash.h lib/uthash.h options.h lib/utarray.h
t/test_codearea.o: options_def.h
t/test_symtab.o: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
t/test_symtab.o: lib/queue.h lib/str.h symref.h lib/classlist.h model.h
t/test_symtab.o: lib/list.h module.h lib/classhash.h lib/strhash.h
t/test_symtab.o: lib/uthash.h codearea.h lib/array.h expr.h scan.h tokens.h
t/test_symtab.o: opcodes.h errors.h error_func.h options.h lib/utarray.h
t/test_symtab.o: options_def.h sym.h symtab.h
t/testlib.o: lib/dbg.h t/testlib.h
