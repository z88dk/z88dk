#------------------------------------------------------------------------------
# Z88DK Z80 Module Assembler
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
BARE_PROJ	:= z80asm
PROJ		:= z88dk-$(BARE_PROJ)

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 	:= .exe
else
  EXESUFFIX 	?=
endif

# UNIXem is needed in both Windows_NT and in a MinGW build in Unix
ifeq ($(EXESUFFIX),.exe)
  UNIXem_CFLAGS	:= -I../../ext/UNIXem/include
  UNIXem_OBJS	:= ../../ext/UNIXem/src/glob.o \
				   ../../ext/UNIXem/src/dirent.o
endif

CC 			?= gcc
CXX			?= g++
INSTALL 	?= install
CROSS		?= 0

#------------------------------------------------------------------------------
# Object files
#------------------------------------------------------------------------------
C_SRCS		:= $(filter-out src/c/test.c, $(wildcard src/c/*.c ../common/*.c ../../ext/regex/reg*.c))
CXX_SRCS	:= $(wildcard src/cpp/*.cpp)	
OBJS 		:= $(C_SRCS:.c=.o) $(CXX_SRCS:.cpp=.o) $(UNIXem_OBJS)
DEPENDS		:= $(C_SRCS:.c=.d) $(CXX_SRCS:.cpp=.d)
TEST_SRC_MAIN	:= $(wildcard t/test_*.c)
TEST_SRC_LIB	:= t/testlib.c

#------------------------------------------------------------------------------
# variables
#------------------------------------------------------------------------------
OPT 		= -O3
#OPT		= -g -Wextra 

COMMON_FLAGS = -MMD -Wall $(OPT) \
			-Isrc

LOCAL_CFLAGS += -std=gnu11 $(COMMON_FLAGS) \
			-Isrc/c \
			-It \
			-I../common \
			-I../../ext/optparse \
			-I../../ext/regex \
			-I../../ext/uthash/src \
			$(UNIXem_CFLAGS)
CXX_FLAGS	+= -std=c++17 $(COMMON_FLAGS) \
			-Isrc/cpp

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------
.PHONY: all

all: $(PROJ)$(EXESUFFIX)

$(PROJ)$(EXESUFFIX): ../config.h $(OBJS)
	$(CXX) -o $(PROJ)$(EXESUFFIX) $(OBJS) $(LDFLAGS)

../config.h:
	@echo \#define PREFIX \"/usr/local/share/z88dk\" 				 > $@
	@echo \#define UNIX 1											>> $@
	@echo \#define EXEC_PREFIX \"\"									>> $@
	@echo \#define Z88DK_VERSION \"build-$(shell date +%Y%m%d)\"	>> $@

%.o: %.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

# parser is too big to optimize with -O3
src/c/parse.o: src/c/parse.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -O0 -c -o $@ $<

#------------------------------------------------------------------------------
# z80asm2
#------------------------------------------------------------------------------
#all: z80asm2$(EXESUFFIX)
#
#z80asm2$(EXESUFFIX): dev/z80asm2/z80asm2$(EXESUFFIX)
#	cp dev/z80asm2/z80asm2$(EXESUFFIX) z80asm2$(EXESUFFIX)
#
#dev/z80asm2/z80asm2$(EXESUFFIX): $(wildcard dev/z80asm2/*.c dev/z80asm2/*.h)
#	$(MAKE) -C dev/z80asm2
#
#------------------------------------------------------------------------------
# libraries
#------------------------------------------------------------------------------
.PHONY: z80asm_lib
all: z80asm_lib

z80asm_lib:
ifeq ($(CROSS),0)
	$(MAKE) -C dev/z80asm_lib
	cp dev/z80asm_lib/$(PROJ)-*.lib .
ifdef ZCCCFG
	cp dev/z80asm_lib/$(PROJ)-*.lib $(ZCCCFG)/../
endif
endif

clean::
	$(MAKE) -C dev/z80asm_lib clean
	$(RM) $(PROJ)-*.lib

#------------------------------------------------------------------------------
# developer generated source files, and test libs
#------------------------------------------------------------------------------
.PHONY: dev
dev:
	perl asmstyle.pl dev/z80asm_lib/*.asm
	$(MAKE) -C tt
	$(MAKE) -f dev/Makefile
	$(MAKE) all

clean::
	$(MAKE) -C lib clean

#------------------------------------------------------------------------------
# install
#------------------------------------------------------------------------------
install: $(PROJ)$(EXESUFFIX) z80asm_lib
	$(INSTALL) $(PROJ)$(EXESUFFIX)     $(PREFIX)/bin/$(PROJ)$(EXESUFFIX)
	$(INSTALL) $(PROJ)$(EXESUFFIX)     $(PREFIX)/bin/$(BARE_PROJ)$(EXESUFFIX)
	$(INSTALL) asmpp.pl      $(PREFIX)/bin/z88dk-asmpp
	$(INSTALL) asmstyle.pl   $(PREFIX)/bin/z88dk-asmstyle
	$(MAKE) -C dev/z80asm_lib install PREFIX=$(PREFIX_SHARE)

#------------------------------------------------------------------------------
# clean
#------------------------------------------------------------------------------
clean::
	$(RM) *.core *.o  *.out *.orig *.exe *.tmp *.bak *.log *~
	$(RM) -rf Debug Release x1 x2 x3
	$(RM) $(OBJS) $(TEST_SRC_LIB:.c=.o)

#------------------------------------------------------------------------------
# test
#------------------------------------------------------------------------------
all: t/libtestlib.a

t/libtestlib.a : $(OBJS) $(TEST_SRC_LIB:.c=.o)
	ar rcs t/libtestlib.a $(OBJS:src/c/main.o=) $(TEST_SRC_LIB:.c=.o)

$(TEST_SRC_MAIN:.c=.o) : t/libtestlib.a

.o.out :
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) $< -o $(<:.o=$(EXESUFFIX)) $(LDFLAGS) -Lt -ltestlib
	$(<:.o=$(EXESUFFIX)) 2> $@~
	diff -w $(<:.o=.bmk) $@~
	mv -f $@~ $@

clean::
	$(RM) t/libtestlib.a t/*.o t/*.out lib/t/*.o lib/t/*.out $(TEST_SRC_MAIN:.c=$(EXESUFFIX))

all:
	perl dev/cpu2/cpu.pl

test: $(PROJ)$(EXESUFFIX) z80asm_lib
	$(MAKE) dev
	$(MAKE) z80asm_lib
	$(MAKE) prove_c
	$(MAKE) prove_perl

testdev:
	$(MAKE) -C dev/z80asm_lib test
	$(MAKE) -C dev/z80asm2 test
	perl dev/cpu2/cpu.pl -s test

testlib:
	$(MAKE) -C lib test

prove_c: t/libtestlib.a $(TEST_SRC_MAIN:.c=.o) $(TEST_SRC_MAIN:.c=.out)

prove_perl: $(PROJ)$(EXESUFFIX)
	perl -S prove --state=slow,save -j9 t2/*.t
	perl -S prove t/*.t

clean::
	$(RM) zcc_opt.def zcc_proj.lst

testzcc : $(PROJ)$(EXESUFFIX)
	zcc +zx -lndos       -create-app -omicroman.bin ../../examples/microman.c
	zcc +zx -lndos -lmzx -create-app -omandel.bin   ../../examples/graphics/mandel.c
	eightyone microman.tap
	eightyone mandel.tap

clean::
	$(RM) zcc_opt.def microman.bin microman.tap
	$(RM) zcc_opt.def mandel.bin   mandel.tap

clean::
	$(RM) -r *.dSYM
	$(RM) $(PROJ)$(EXESUFFIX) test*
	$(RM) t/*.tmp t/dev/*.tmp

#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
clean::
	$(RM) $(DEPENDS)

-include $(DEPENDS)
