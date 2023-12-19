#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2023
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
#OPT		= -O3 -g -Wextra 

COMMON_FLAGS = -MMD -Wall -ggdb $(OPT) \
			-I. -Isrc -I../common

LOCAL_CFLAGS += -std=gnu11 $(COMMON_FLAGS) \
			-Isrc/c \
			-It \
			-I../../ext/optparse \
			-I../../ext/regex \
			-I../../ext/uthash/src \
			$(UNIXem_CFLAGS)
CXX_FLAGS	+= -std=gnu++17 $(COMMON_FLAGS) -Wextra -Werror -pedantic-errors \
			-Isrc/cpp
ifeq ($(findstring m68k, $(CC)), m68k)
    PARSE1_CFLAGS = -mlong-jump-table-offsets
endif

# link boost::filesystem if needed
LDFLAGS 	+= $(shell perl build_ldflags.pl $(CXX) $(CROSS)) 

# needed for stack_trace
UNAME = $(shell uname)
ifeq ($(UNAME), Linux)
ifeq ($(CROSS), 0)
LDFLAGS 	+= -rdynamic
endif
endif

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
	@echo \#define Z88DK_VERSION \"build-$(shell date +%Y%m%d)\"	>> $@

%.o: %.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

# parser is too big to optimize with -O3
src/c/parse1.o: src/c/parse1.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) $(PARSE1_CFLAGS) -O0 -c -o $@ $<

#------------------------------------------------------------------------------
# libraries
#------------------------------------------------------------------------------
.PHONY: z80asm_lib
all: z80asm_lib

z80asm_lib: $(PROJ)$(EXESUFFIX)
ifeq ($(CROSS),0)
	$(MAKE) -C dev/z80asm_lib
	cp dev/z80asm_lib/$(PROJ).lib .
  ifdef ZCCCFG
	cp dev/z80asm_lib/$(PROJ).lib $(ZCCCFG)/../
  endif
endif

clean::
	$(MAKE) -C dev/z80asm_lib clean
	$(RM) $(PROJ).lib

#------------------------------------------------------------------------------
# developer generated source files, and test libs
# only run with DEVELOPER=1 to fix #2332 (Build fails on cygwin), 
# #2369 (wrong re2c output on Snapcraft), build failure of
# .github/workflows/build-mingw-on-ubuntu.yml
#------------------------------------------------------------------------------
.PHONY: dev
dev:
	perl asmstyle.pl dev/z80asm_lib/*.asm
	$(MAKE) DEVELOPER=1 all
	$(MAKE) all

# ragel parser generator
dev: src/c/scan_rules.h

src/c/scan1.o: src/c/scan_rules.h

src/c/scan_rules.h: src/c/scan_rules.rl src/c/tokens.h src/c/scan_def.h \
				parse_ragel.pl Makefile 
ifeq ($(DEVELOPER),1)
	perl parse_ragel.pl src/c/scan_rules.rl
	dos2unix src/c/scan_rules.h 2> /dev/null
endif
	
dev: src/c/parse_rules.h

src/c/parse1.o: src/c/parse_rules.h

src/c/parse_rules.h: src/c/parse_rules.rl src/c/tokens.h src/c/scan_def.h \
				parse_ragel.pl Makefile \
				src/c/cpu_rules.h
ifeq ($(DEVELOPER),1)
	perl parse_ragel.pl src/c/parse_rules.rl
	dos2unix src/c/parse_rules.h 2> /dev/null
endif

src/c/tokens.h : make_tokens.pl Makefile
ifeq ($(DEVELOPER),1)
	perl make_tokens.pl > src/c/tokens.h
	dos2unix src/c/tokens.h 2> /dev/null
endif

# opcode tables generator
dev: src/c/cpu_rules.h src/c/cpu_rules_action.c src/c/cpu_rules_action.h

src/c/cpu_rules.h src/c/cpu_rules_action.c src/c/cpu_rules_action.h: \
			$(wildcard dev/cpu/*.pl dev/cpu/*.y) dev/cpu/Makefile Makefile
ifeq ($(DEVELOPER),1)
	$(MAKE) -C dev/cpu
	cp dev/cpu/cpu_rules.h src/c/cpu_rules.h
	cp dev/cpu/cpu_rules_action.c src/c/cpu_rules_action.c
	cp dev/cpu/cpu_rules_action.h src/c/cpu_rules_action.h
endif

# reloc routine
dev: src/c/reloc_code.c

src/c/reloc_code.c: dev/reloc_code.asm dev/make_reloc_code.pl Makefile
ifeq ($(DEVELOPER),1)
	cd dev && perl make_reloc_code.pl && dos2unix reloc_code.[ch] 2> /dev/null && \
		mv -f reloc_code.[ch] ../src/c/ 
endif

# re2c
define MAKE_RE2C
dev: $(1).cpp

$(1).cpp: $(1).re $(1).def Makefile
ifeq ($(DEVELOPER),1)
	$(RE2C) -o $(1).cpp $(1).re
	dos2unix $(1).cpp 2> /dev/null
endif
endef

$(eval $(call MAKE_RE2C,src/cpp/scan))

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
	find . -type f '(' -name '*.core' -o -name '*.o' -o -name '*.d' \
					-o -name '*.out' -o -name '*.orig' -o -name '*.exe' \
					-o -name '*.tmp' -o -name '*.bak' -o -name '*.log' \
					-o -name '*~' ')' -exec $(RM) {} '+'
	$(RM) -rf Debug Release x1 x2 x3
	$(RM) $(OBJS) $(TEST_SRC_LIB:.c=.o)

test: $(PROJ)$(EXESUFFIX) z80asm_lib
	$(MAKE) -C dev/z80asm_lib test
	perl -S prove --state=slow,save -j9 t/*.t

testdev: $(PROJ)$(EXESUFFIX)
	$(MAKE) DEVELOPER=1 dev
	$(MAKE) DEVELOPER=1 z80asm_lib
	$(MAKE) DEVELOPER=1 test

testlib:
	$(MAKE) -C lib test

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

#------------------------------------------------------------------------------
# rebuild the tools needed for the tests
rebuild: clean
	$(RM) ../z80asm/dev/z80asm_lib/z88dk-z80asm.lib
	$(RM) ../z80asm/dev/z80asm_lib/z88dk-z80asm_lib.lst
	touch ../z80asm/Makefile ../z80asm/dev/z80asm_lib/Makefile ../z80asm/dev/cpu/Makefile
	touch ../z80asm/src/c/*.rl
	$(MAKE) -C ../common
	$(MAKE) -C ../z80asm dev
	cp ../z80asm/z88dk-z80asm$(EXESUFFIX) ../../bin/
	$(MAKE) -C ../z80nm
	cp ../z80nm/z88dk-z80nm$(EXESUFFIX) ../../bin/
	$(MAKE) -C ../sccz80
	cp ../sccz80/sccz80$(EXESUFFIX) ../../bin/z88dk-sccz80$(EXESUFFIX)
	$(MAKE) -C ../zcc
	cp ../zcc/zcc$(EXESUFFIX) ../../bin/zcc$(EXESUFFIX)
	$(MAKE) -C ../ticks all
	cp ../ticks/z88dk-dis$(EXESUFFIX) ../../bin/
	cp ../ticks/z88dk-ticks$(EXESUFFIX) ../../bin/
	cp ../ticks/z88dk-gdb$(EXESUFFIX) ../../bin/
	$(MAKE) -C ../zobjcopy all
	cp $(PROJ)$(EXESUFFIX) ../../bin/

retest: rebuild
	$(MAKE) -C ../common test
	$(MAKE) -C ../z80asm testdev
	$(MAKE) -C ../zobjcopy test
