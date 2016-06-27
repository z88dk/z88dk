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
	$(RM) zcc_opt.def enigma.bin enigma.out enigma.bmk enigma.reloc

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

codearea.obj: codearea.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
codearea.obj: lib/class.h lib/queue.h lib/str.h lib/classhash.h lib/strhash.h
codearea.obj: lib/uthash.h errors.h error_func.h lib/fileutil.h lib/utarray.h
codearea.obj: lib/init.h listfile.h options.h options_def.h lib/strpool.h
codearea.obj: z80asm.h sym.h expr.h lib/classlist.h scan.h tokens.h opcodes.h
deffile.obj: deffile.h lib/fileutil.h lib/types.h lib/str.h lib/alloc.h
deffile.obj: lib/dbg.h lib/utarray.h listfile.h lib/class.h lib/queue.h
deffile.obj: options.h options_def.h symbol.h expr.h lib/array.h
deffile.obj: lib/classlist.h scan.h tokens.h opcodes.h errors.h error_func.h
deffile.obj: sym.h model.h lib/list.h module.h lib/classhash.h lib/strhash.h
deffile.obj: lib/uthash.h codearea.h symtab.h objfile.h z80asm.h
directives.obj: codearea.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
directives.obj: lib/class.h lib/queue.h lib/str.h lib/classhash.h
directives.obj: lib/strhash.h lib/uthash.h directives.h errors.h error_func.h
directives.obj: lib/fileutil.h lib/utarray.h model.h lib/list.h module.h
directives.obj: lib/classlist.h expr.h scan.h tokens.h opcodes.h options.h
directives.obj: options_def.h sym.h symtab.h parse.h lib/strpool.h z80asm.h
error_func.obj: errors.h error_func.h lib/str.h lib/alloc.h lib/dbg.h
error_func.obj: lib/types.h
errors.obj: errors.h error_func.h lib/fileutil.h lib/types.h lib/str.h
errors.obj: lib/alloc.h lib/dbg.h lib/utarray.h options.h options_def.h
errors.obj: lib/srcfile.h lib/class.h lib/queue.h lib/list.h lib/strpool.h
errors.obj: lib/strhash.h lib/uthash.h lib/init.h
expr.obj: lib/array.h lib/alloc.h lib/dbg.h lib/types.h lib/class.h
expr.obj: lib/queue.h lib/str.h codearea.h lib/classhash.h lib/strhash.h
expr.obj: lib/uthash.h expr.h lib/classlist.h scan.h tokens.h opcodes.h
expr.obj: errors.h error_func.h options.h lib/utarray.h options_def.h sym.h
expr.obj: lib/init.h model.h lib/list.h module.h symtab.h lib/strpool.h
expr.obj: expr_def.h
hist.obj: hist.h
libfile.obj: errors.h error_func.h lib/fileutil.h lib/types.h lib/str.h
libfile.obj: lib/alloc.h lib/dbg.h lib/utarray.h libfile.h objfile.h
libfile.obj: lib/array.h lib/class.h lib/queue.h module.h lib/classlist.h
libfile.obj: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h expr.h
libfile.obj: scan.h tokens.h opcodes.h options.h options_def.h sym.h symtab.h
listfile.obj: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
listfile.obj: lib/queue.h lib/str.h lib/fileutil.h lib/utarray.h options.h
listfile.obj: options_def.h z80asm.h sym.h expr.h lib/array.h lib/classlist.h
listfile.obj: scan.h tokens.h opcodes.h errors.h error_func.h hist.h
listfile.obj: lib/strpool.h codearea.h lib/classhash.h lib/strhash.h
listfile.obj: lib/uthash.h
mapfile.obj: lib/fileutil.h lib/types.h lib/str.h lib/alloc.h lib/dbg.h
mapfile.obj: lib/utarray.h listfile.h lib/class.h lib/queue.h mapfile.h
mapfile.obj: options.h options_def.h lib/strpool.h symbol.h expr.h
mapfile.obj: lib/array.h lib/classlist.h scan.h tokens.h opcodes.h errors.h
mapfile.obj: error_func.h sym.h model.h lib/list.h module.h lib/classhash.h
mapfile.obj: lib/strhash.h lib/uthash.h codearea.h symtab.h objfile.h
mapfile.obj: z80asm.h
model.obj: model.h lib/list.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
model.obj: lib/queue.h module.h lib/classlist.h lib/classhash.h lib/strhash.h
model.obj: lib/uthash.h codearea.h lib/array.h lib/str.h expr.h scan.h
model.obj: tokens.h opcodes.h errors.h error_func.h options.h lib/utarray.h
model.obj: options_def.h sym.h symtab.h lib/init.h listfile.h lib/srcfile.h
modlink.obj: lib/alloc.h lib/dbg.h lib/types.h codearea.h lib/array.h
modlink.obj: lib/class.h lib/queue.h lib/str.h lib/classhash.h lib/strhash.h
modlink.obj: lib/uthash.h errors.h error_func.h expr.h lib/classlist.h scan.h
modlink.obj: tokens.h opcodes.h options.h lib/utarray.h options_def.h sym.h
modlink.obj: lib/fileutil.h listfile.h modlink.h lib/strpool.h symbol.h
modlink.obj: model.h lib/list.h module.h symtab.h objfile.h z80asm.h
module.obj: codearea.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
module.obj: lib/class.h lib/queue.h lib/str.h lib/classhash.h lib/strhash.h
module.obj: lib/uthash.h lib/init.h module.h lib/classlist.h expr.h scan.h
module.obj: tokens.h opcodes.h errors.h error_func.h options.h lib/utarray.h
module.obj: options_def.h sym.h symtab.h lib/strpool.h
objfile.obj: lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h
objfile.obj: codearea.h lib/array.h lib/str.h lib/classhash.h lib/strhash.h
objfile.obj: lib/uthash.h errors.h error_func.h lib/fileutil.h lib/utarray.h
objfile.obj: options.h options_def.h model.h lib/list.h module.h
objfile.obj: lib/classlist.h expr.h scan.h tokens.h opcodes.h sym.h symtab.h
objfile.obj: objfile.h lib/strpool.h
opcodes.obj: directives.h expr.h lib/array.h lib/alloc.h lib/dbg.h
opcodes.obj: lib/types.h lib/class.h lib/queue.h lib/str.h lib/classlist.h
opcodes.obj: scan.h tokens.h opcodes.h errors.h error_func.h options.h
opcodes.obj: lib/utarray.h options_def.h sym.h codearea.h lib/classhash.h
opcodes.obj: lib/strhash.h lib/uthash.h model.h lib/list.h module.h symtab.h
opcodes.obj: parse.h z80asm.h
options.obj: errors.h error_func.h lib/fileutil.h lib/types.h lib/str.h
options.obj: lib/alloc.h lib/dbg.h lib/utarray.h hist.h lib/init.h model.h
options.obj: lib/list.h lib/class.h lib/queue.h module.h lib/classlist.h
options.obj: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h
options.obj: lib/array.h expr.h scan.h tokens.h opcodes.h options.h
options.obj: options_def.h sym.h symtab.h lib/srcfile.h lib/strpool.h
options.obj: z80asm.h
parse.obj: lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h
parse.obj: codearea.h lib/array.h lib/str.h lib/classhash.h lib/strhash.h
parse.obj: lib/uthash.h directives.h expr.h lib/classlist.h scan.h tokens.h
parse.obj: opcodes.h errors.h error_func.h options.h lib/utarray.h
parse.obj: options_def.h sym.h listfile.h model.h lib/list.h module.h
parse.obj: symtab.h parse.h lib/strpool.h parse_rules.h
scan.obj: lib/alloc.h lib/dbg.h lib/types.h errors.h error_func.h lib/init.h
scan.obj: lib/list.h lib/class.h lib/queue.h model.h module.h lib/classlist.h
scan.obj: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h lib/array.h
scan.obj: lib/str.h expr.h scan.h tokens.h opcodes.h options.h lib/utarray.h
scan.obj: options_def.h sym.h symtab.h scan_rules.h
sym.obj: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h lib/queue.h
sym.obj: lib/str.h options.h lib/utarray.h options_def.h lib/strpool.h sym.h
sym.obj: symbol.h expr.h lib/array.h lib/classlist.h scan.h tokens.h
sym.obj: opcodes.h errors.h error_func.h model.h lib/list.h module.h
sym.obj: lib/classhash.h lib/strhash.h lib/uthash.h codearea.h symtab.h
sym.obj: objfile.h
symtab.obj: errors.h error_func.h listfile.h lib/class.h lib/alloc.h
symtab.obj: lib/dbg.h lib/types.h lib/queue.h lib/str.h model.h lib/list.h
symtab.obj: module.h lib/classlist.h lib/classhash.h lib/strhash.h
symtab.obj: lib/uthash.h codearea.h lib/array.h expr.h scan.h tokens.h
symtab.obj: opcodes.h options.h lib/utarray.h options_def.h sym.h symtab.h
symtab.obj: symbol.h objfile.h z80asm.h
z80asm.obj: deffile.h directives.h lib/fileutil.h lib/types.h lib/str.h
z80asm.obj: lib/alloc.h lib/dbg.h lib/utarray.h libfile.h listfile.h
z80asm.obj: lib/class.h lib/queue.h mapfile.h modlink.h expr.h lib/array.h
z80asm.obj: lib/classlist.h scan.h tokens.h opcodes.h errors.h error_func.h
z80asm.obj: options.h options_def.h sym.h module.h lib/classhash.h
z80asm.obj: lib/strhash.h lib/uthash.h codearea.h symtab.h objfile.h parse.h
z80asm.obj: lib/strpool.h symbol.h model.h lib/list.h
z80pass.obj: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
z80pass.obj: lib/queue.h lib/str.h modlink.h expr.h lib/array.h
z80pass.obj: lib/classlist.h scan.h tokens.h opcodes.h errors.h error_func.h
z80pass.obj: options.h lib/utarray.h options_def.h sym.h symbol.h model.h
z80pass.obj: lib/list.h module.h lib/classhash.h lib/strhash.h lib/uthash.h
z80pass.obj: codearea.h symtab.h objfile.h
lib/alloc.obj: lib/alloc.h lib/dbg.h lib/types.h lib/init.h lib/utlist.h
lib/array.obj: lib/array.h lib/alloc.h lib/dbg.h lib/types.h lib/class.h
lib/array.obj: lib/queue.h lib/str.h
lib/class.obj: lib/alloc.h lib/dbg.h lib/types.h lib/class.h lib/queue.h
lib/class.obj: lib/init.h lib/strpool.h
lib/dbg.obj: lib/dbg.h
lib/fileutil.obj: lib/alloc.h lib/dbg.h lib/types.h lib/class.h lib/queue.h
lib/fileutil.obj: lib/fileutil.h lib/str.h lib/utarray.h lib/init.h
lib/fileutil.obj: lib/strpool.h lib/uthash.h
lib/list.obj: lib/alloc.h lib/dbg.h lib/types.h lib/list.h lib/class.h
lib/list.obj: lib/queue.h
lib/minunit.obj: lib/minunit.h lib/dbg.h
lib/srcfile.obj: lib/alloc.h lib/dbg.h lib/types.h lib/srcfile.h lib/class.h
lib/srcfile.obj: lib/queue.h lib/list.h lib/str.h lib/utarray.h
lib/srcfile.obj: lib/fileutil.h lib/strpool.h
lib/str.obj: lib/str.h lib/alloc.h lib/dbg.h lib/types.h
lib/strhash.obj: lib/alloc.h lib/dbg.h lib/types.h lib/strhash.h lib/class.h
lib/strhash.obj: lib/queue.h lib/uthash.h lib/strpool.h lib/str.h
lib/strpool.obj: lib/alloc.h lib/dbg.h lib/types.h lib/init.h lib/strpool.h
lib/strpool.obj: lib/uthash.h
t/test_codearea.obj: codearea.h lib/array.h lib/alloc.h lib/dbg.h lib/types.h
t/test_codearea.obj: lib/class.h lib/queue.h lib/str.h lib/classhash.h
t/test_codearea.obj: lib/strhash.h lib/uthash.h options.h lib/utarray.h
t/test_codearea.obj: options_def.h
t/test_symtab.obj: listfile.h lib/class.h lib/alloc.h lib/dbg.h lib/types.h
t/test_symtab.obj: lib/queue.h lib/str.h model.h lib/list.h module.h
t/test_symtab.obj: lib/classlist.h lib/classhash.h lib/strhash.h lib/uthash.h
t/test_symtab.obj: codearea.h lib/array.h expr.h scan.h tokens.h opcodes.h
t/test_symtab.obj: errors.h error_func.h options.h lib/utarray.h
t/test_symtab.obj: options_def.h sym.h symtab.h
t/testlib.obj: lib/dbg.h t/testlib.h
