#------------------------------------------------------------------------------
# z80asm
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

include ../Make.common

#------------------------------------------------------------------------------
# developer generated source files, and test libs
# only run with DEVELOPER=1 to fix #2332 (Build fails on cygwin), 
# #2369 (wrong re2c output on Snapcraft), build failure of
# .github/workflows/build-mingw-on-ubuntu.yml
#------------------------------------------------------------------------------

BARE_PROJ	:= z80asm
PROJ		:= z88dk-$(BARE_PROJ)

TARGET_EXE	:= $(PROJ)$(EXESUFFIX)
TARGET_LIB	:= $(PROJ).lib

TASKS ?= 9

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
	LOCAL_CFLAGS := $(subst -ggdb, , $(LOCAL_CFLAGS))
    PARSE1_CFLAGS = -mlong-jump-table-offsets
endif

# link boost::filesystem if needed
LDFLAGS 	+= $(shell perl tools/build_ldflags.pl $(CXX) $(CROSS)) 

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
CXX_SRCS	:= $(wildcard src/*.cpp src/cpp/*.cpp)
OBJS_ALL	:= $(C_SRCS:.c=.o) $(CXX_SRCS:.cpp=.o) $(UNIXem_OBJS)
OBJS		:= $(filter-out main.o, $(OBJS_ALL))

DEPENDS		:= $(C_SRCS:.c=.d) $(CXX_SRCS:.cpp=.d)

#------------------------------------------------------------------------------
.PHONY: all clean test install
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# rule to make executable
#------------------------------------------------------------------------------

define MAKE_EXE
all: $(1)$(EXESUFFIX)

$(1)$(EXESUFFIX): $(2)
	$(CXX) $(CXXFLAGS) $(2) $(LDFLAGS) -o $(1)$(EXESUFFIX)
	
clean::
	$(RM) $(1) $(1)$(EXESUFFIX) $(2)
endef

%.o: %.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

#------------------------------------------------------------------------------
# rule call re2c
#------------------------------------------------------------------------------

define MAKE_RE2C
$(TARGET_EXE): $(1).o

ifeq ($(DEVELOPER),1)
$(1).cpp: $(1).re $(1).def Makefile
	$(RE2C) -o $(1).cpp $(1).re
	dos2unix $(1).cpp 2> /dev/null
endif
endef



#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------

$(eval $(call MAKE_EXE,$(PROJ),$(OBJS_ALL)))

$(TARGET_EXE): ../config.h

../config.h:
	make -C ../.. src/config.h

# parser is too big to optimize with -O3
src/c/parse1.o: src/c/parse1.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) $(PARSE1_CFLAGS) -O0 -c -o $@ $<

#------------------------------------------------------------------------------
# library
#------------------------------------------------------------------------------

all: $(TARGET_LIB)

$(TARGET_LIB): $(TARGET_EXE)
ifeq ($(CROSS),0)
  ifeq ($(DEVELOPER),1)
	perl asmstyle.pl dev/z80asm_lib/*.asm
  endif
	$(MAKE) TASKS=$(TASKS) -C dev/z80asm_lib
	cp dev/z80asm_lib/$(TARGET_LIB) .
  ifdef ZCCCFG
	cp dev/z80asm_lib/$(TARGET_LIB) $(ZCCCFG)/../
  endif
endif

clean::
	$(MAKE) -C dev/z80asm_lib clean
	$(RM) $(TARGET_LIB)

#------------------------------------------------------------------------------
# generated files
#------------------------------------------------------------------------------

# ragel parser generator
$(TARGET_EXE): src/c/scan_rules.h

src/c/scan1.o: src/c/scan_rules.h

ifeq ($(DEVELOPER),1)
src/c/scan_rules.h: src/c/scan_rules.rl src/c/tokens.h src/c/scan_def.h \
				tools/parse_ragel.pl Makefile 
	perl tools/parse_ragel.pl src/c/scan_rules.rl
	dos2unix src/c/scan_rules.h 2> /dev/null
endif

$(TARGET_EXE): src/c/parse_rules.h

src/c/parse1.o: src/c/parse_rules.h

ifeq ($(DEVELOPER),1)
src/c/parse_rules.h: src/c/parse_rules.rl src/c/tokens.h src/c/scan_def.h \
				tools/parse_ragel.pl Makefile \
				src/c/cpu_rules.h
	perl tools/parse_ragel.pl src/c/parse_rules.rl
	dos2unix src/c/parse_rules.h 2> /dev/null
endif

ifeq ($(DEVELOPER),1)
src/c/tokens.h : tools/make_tokens.pl Makefile
	perl tools/make_tokens.pl > src/c/tokens.h
	dos2unix src/c/tokens.h 2> /dev/null
endif

# opcode tables generator
$(TARGET_EXE): src/c/cpu_rules.h src/c/cpu_rules_action.c src/c/cpu_rules_action.h

ifeq ($(DEVELOPER),1)
src/c/cpu_rules.h src/c/cpu_rules_action.c src/c/cpu_rules_action.h: \
			$(wildcard dev/cpu/*.pl dev/cpu/*.pm dev/cpu/*.dat) \
			dev/cpu/Makefile Makefile
	$(MAKE) -C dev/cpu
	cp dev/cpu/cpu_rules.h src/c/cpu_rules.h
	cp dev/cpu/cpu_rules_action.c src/c/cpu_rules_action.c
	cp dev/cpu/cpu_rules_action.h src/c/cpu_rules_action.h
endif

# reloc routine
$(TARGET_EXE): src/c/reloc_code.c

ifeq ($(DEVELOPER),1)
src/c/reloc_code.c: dev/reloc_code.asm dev/make_reloc_code.pl Makefile
	cd dev && perl make_reloc_code.pl && dos2unix reloc_code.[ch] 2> /dev/null && \
		mv -f reloc_code.[ch] ../src/c/ 
endif

# re2c
$(eval $(call MAKE_RE2C,src/cpp/scan2))


all: 
	$(MAKE) -C z80asm2

#------------------------------------------------------------------------------
# test
#------------------------------------------------------------------------------

test: $(TARGET_EXE) $(TARGET_LIB)
	$(MAKE) -C dev/z80asm_lib test
	perl -S prove --state=slow,save -j$(TASKS) t/*.t
	$(MAKE) -C z80asm2 test

testzcc : $(TARGET_EXE)
	zcc +zx -lndos       -create-app -omicroman.bin ../../examples/microman.c
	zcc +zx -lndos -lmzx -create-app -omandel.bin   ../../examples/graphics/mandel.c
	eightyone microman.tap
	eightyone mandel.tap

#------------------------------------------------------------------------------
# install
#------------------------------------------------------------------------------
install: $(TARGET_EXE) $(TARGET_LIB)
	$(INSTALL) $(TARGET_EXE) $(PREFIX)/bin/$(TARGET_EXE)
	$(INSTALL) $(TARGET_EXE) $(PREFIX)/bin/$(BARE_PROJ)$(EXESUFFIX)
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
	$(RM) zcc_opt.def zcc_proj.lst
	$(RM) zcc_opt.def microman.bin microman.tap
	$(RM) zcc_opt.def mandel.bin   mandel.tap
	$(RM) -r *.dSYM
	$(RM) -r $(TARGET_EXE) test*.dir
	$(RM) $(TARGET_EXE) test*
	$(RM) t/*.tmp t/dev/*.tmp
	$(RM) $(DEPENDS)
	$(MAKE) -C z80asm2 clean

#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
-include $(DEPENDS)

#------------------------------------------------------------------------------
# rebuild the tools needed for the tests
#------------------------------------------------------------------------------

rebuild: clean
	$(RM) ../z80asm/dev/z80asm_lib/$(TARGET_LIB)
	$(RM) ../z80asm/dev/z80asm_lib/z88dk-z80asm_lib.lst
	touch ../z80asm/Makefile ../z80asm/dev/z80asm_lib/Makefile ../z80asm/dev/cpu/Makefile
	touch ../z80asm/src/c/*.rl
	$(MAKE) -C ../common
	$(MAKE) -C ../z80asm
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
	cp $(TARGET_EXE) ../../bin/

retest: rebuild
	$(MAKE) -C ../common test
	$(MAKE) -C ../z80asm test
	$(MAKE) -C ../zobjcopy test

