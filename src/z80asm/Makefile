#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------
BARE_PROJ	:= z80asm
PROJ		:= z88dk-$(BARE_PROJ)

include ../Make.common

CC 			?= gcc
CXX			?= g++
INSTALL 	?= install
RE2C		= re2c -W --tags --no-debug-info --no-generation-date 

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
CXX_FLAGS	+= -std=gnu++17 $(COMMON_FLAGS) -Wextra -Werror -pedantic-errors \
			-Isrc/cpp

#------------------------------------------------------------------------------
# Object files
#------------------------------------------------------------------------------
C_SRCS		:= $(filter-out src/c/test.c, $(wildcard src/c/*.c ../common/*.c ../../ext/regex/reg*.c))
CXX_SRCS	:= $(wildcard src/cpp/*.cpp)	
OBJS 		:= $(C_SRCS:.c=.o) $(CXX_SRCS:.cpp=.o) $(UNIXem_OBJS)
DEPENDS		:= $(C_SRCS:.c=.d) $(CXX_SRCS:.cpp=.d)
#TEST_SRC_MAIN	:= $(wildcard t/test_*.cpp)
#TEST_SRC_LIB	:= t/testlib.c

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
	touch src/c/hist.c
	$(MAKE) all

# ragel parser generator
dev: src/c/scan_rules.h

src/c/scan_rules.h: src/c/scan_rules.rl src/c/tokens.h src/c/scan_def.h \
				parse_ragel.pl Makefile 
	perl parse_ragel.pl src/c/scan_rules.rl
	dos2unix -q src/c/scan_rules.h
	
dev: src/c/parse_rules.h

src/c/parse_rules.h: src/c/parse_rules.rl src/c/tokens.h src/c/scan_def.h \
				parse_ragel.pl Makefile \
				dev/cpu/cpu_rules.h
	perl parse_ragel.pl src/c/parse_rules.rl
	dos2unix -q src/c/parse_rules.h

src/c/tokens.h : make_tokens.pl Makefile
	perl make_tokens.pl > src/c/tokens.h
	dos2unix -q src/c/tokens.h

# opcode tables generator
dev: dev/cpu/opcodes.yaml \
	 dev/cpu/opcodes.txt \
	 dev/cpu/cpu_test_z80_ok.asm \
	 dev/cpu/cpu_rules.h

dev/cpu/opcodes.yaml: dev/cpu/make_opcodes.pl Makefile
	cd dev/cpu && perl make_opcodes.pl && dos2unix -q opcodes.yaml

dev/cpu/opcodes.txt: dev/cpu/opcodes.yaml dev/cpu/dump_opcodes.pl Makefile
	cd dev/cpu && perl dump_opcodes.pl && dos2unix -q opcodes.txt

dev/cpu/cpu_test_z80_ok.asm: dev/cpu/opcodes.yaml dev/cpu/make_cpu_test.pl Makefile
	cd dev/cpu && perl make_cpu_test.pl && dos2unix -q cpu_test_*.asm

dev/cpu/cpu_rules.h: dev/cpu/opcodes.yaml dev/cpu/make_cpu_rules.pl Makefile
	cd dev/cpu && perl make_cpu_rules.pl && dos2unix -q cpu_rules.h

# reloc routine
dev: src/c/reloc_code.c

src/c/reloc_code.c: dev/reloc_code.asm dev/make_reloc_code.pl Makefile
	cd dev && perl make_reloc_code.pl && dos2unix -q reloc_code.[ch] && \
		mv -f reloc_code.[ch] ../src/c/

# re2c
define MAKE_RE2C
dev: $(1).o

$(1).cpp: $(1).re Makefile
	$(RE2C) -o $(1).cpp $(1).re
	dos2unix -q $(1).cpp
endef

$(eval $(call MAKE_RE2C,src/cpp/lex))

#------------------------------------------------------------------------------
# install
#------------------------------------------------------------------------------
install: $(PROJ)$(EXESUFFIX) z80asm_lib
	$(INSTALL) $(PROJ)$(EXESUFFIX)     $(PREFIX)/bin/$(PROJ)$(EXESUFFIX)
	$(INSTALL) $(PROJ)$(EXESUFFIX)     $(PREFIX)/bin/$(BARE_PROJ)$(EXESUFFIX)
	$(INSTALL) asmpp.pl      $(PREFIX)/bin/z88dk-asmpp
	$(INSTALL) asmstyle.pl   $(PREFIX)/bin/z88dk-asmstyle
ifeq ($(CROSS),0)
	$(MAKE) -C dev/z80asm_lib install PREFIX=$(PREFIX_SHARE)
endif

#------------------------------------------------------------------------------
# clean
#------------------------------------------------------------------------------
clean::
	$(RM) *.core *.o  *.out *.orig *.exe *.tmp *.bak *.log *~
	$(RM) -rf Debug Release x1 x2 x3
	$(RM) $(OBJS) $(TEST_SRC_LIB:.c=.o)

#all:
#	perl dev/cpu2/cpu.pl

test: $(PROJ)$(EXESUFFIX) z80asm_lib
	$(MAKE) dev
	$(MAKE) z80asm_lib
	$(MAKE) prove_perl

testdev: test
	$(MAKE) -C dev/z80asm_lib test
	perl dev/cpu2/cpu.pl -s test

testlib:
	$(MAKE) -C lib test

prove_perl: $(PROJ)$(EXESUFFIX)
	perl -S prove --state=slow,save -j9 t/*.t

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
	$(RM) -r $(PROJ)$(EXESUFFIX) test*.dir
	$(RM) $(PROJ)$(EXESUFFIX) test*
	$(RM) t/*.tmp t/dev/*.tmp

#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
clean::
	$(RM) $(DEPENDS)

-include $(DEPENDS)
