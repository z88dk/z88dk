#------------------------------------------------------------------------------
# z80asm
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# windows portability layer
PERL     = perl
CP       = $(PERL) tools/posix.pl cp
RM       = $(PERL) tools/posix.pl rm
MV       = $(PERL) tools/posix.pl mv
MKDIR    = $(PERL) tools/posix.pl mkdir
TOUCH    = $(PERL) tools/posix.pl touch
INSTALL  = $(PERL) tools/posix.pl install
DOS2UNIX = $(PERL) tools/posix.pl dos2unix

ifeq ($(OS),Windows_NT)
  EXESUFFIX := .exe
else
  EXESUFFIX ?=
endif

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

Z80NM_DIR	:= ../z80nm
Z80NM		:= z88dk-z80nm$(EXESUFFIX)

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
LDFLAGS 	+= $(shell $(PERL) tools/build_ldflags.pl $(CXX) $(CROSS)) 

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
	$(RM) -f $(1) $(1)$(EXESUFFIX) $(2)
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
	$(DOS2UNIX) $(1).cpp
endif
endef

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------

$(eval $(call MAKE_EXE,$(PROJ),$(OBJS_ALL)))

$(TARGET_EXE) src/options.o: ../config.h

../config.h:
ifeq ($(OS),Windows_NT)
	..\..\win32\config\make_config.cmd
else
	$(MAKE) -C ../.. src/config.h
endif

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
	$(PERL) asmstyle.pl dev/z80asm_lib/*.asm
  endif
	$(MAKE) TASKS=$(TASKS) -C dev/z80asm_lib
	$(CP) dev/z80asm_lib/$(TARGET_LIB) .
  ifdef ZCCCFG
	$(CP) dev/z80asm_lib/$(TARGET_LIB) $(ZCCCFG)/../
  endif
endif

clean::
	$(MAKE) -C dev/z80asm_lib clean
	$(RM) -f $(TARGET_LIB)

#------------------------------------------------------------------------------
# generated files
#------------------------------------------------------------------------------

# ragel parser generator
$(TARGET_EXE): src/c/scan_rules.h

src/c/scan1.o: src/c/scan_rules.h

ifeq ($(DEVELOPER),1)
src/c/scan_rules.h: src/c/scan_rules.rl src/c/tokens.h src/c/scan_def.h \
				tools/parse_ragel.pl Makefile 
	$(PERL) tools/parse_ragel.pl src/c/scan_rules.rl
	$(DOS2UNIX) src/c/scan_rules.h
endif

$(TARGET_EXE): src/c/parse_rules.h

src/c/parse1.o: src/c/parse_rules.h

ifeq ($(DEVELOPER),1)
src/c/parse_rules.h: src/c/parse_rules.rl src/c/tokens.h src/c/scan_def.h \
				tools/parse_ragel.pl Makefile \
				src/c/cpu_rules.h
	$(PERL) tools/parse_ragel.pl src/c/parse_rules.rl
	$(DOS2UNIX) src/c/parse_rules.h
endif

ifeq ($(DEVELOPER),1)
src/c/tokens.h : tools/make_tokens.pl Makefile
	$(PERL) tools/make_tokens.pl > src/c/tokens.h
	$(DOS2UNIX) src/c/tokens.h
endif

# opcode tables generator
$(TARGET_EXE): src/c/cpu_rules.h src/c/cpu_rules_action.c src/c/cpu_rules_action.h

ifeq ($(DEVELOPER),1)
src/c/cpu_rules.h src/c/cpu_rules_action.c src/c/cpu_rules_action.h: \
			$(wildcard dev/cpu/*.pl dev/cpu/*.pm dev/cpu/*.dat) \
			dev/cpu/Makefile Makefile
	$(MAKE) -C dev/cpu
	$(CP) dev/cpu/cpu_rules.h src/c/cpu_rules.h
	$(CP) dev/cpu/cpu_rules_action.c src/c/cpu_rules_action.c
	$(CP) dev/cpu/cpu_rules_action.h src/c/cpu_rules_action.h
endif

# reloc routine
$(TARGET_EXE): src/c/reloc_code.c

ifeq ($(DEVELOPER),1)
RELOC_DIR = dev/reloc_code

src/c/reloc_code.c: $(RELOC_DIR)/reloc_code.asm $(RELOC_DIR)/make_reloc_code.pl \
		Makefile $(RELOC_DIR)/Makefile
	$(MAKE) -C $(RELOC_DIR)
	$(DOS2UNIX) $(RELOC_DIR)/reloc_code.c $(RELOC_DIR)/reloc_code.h
	$(MV) $(RELOC_DIR)/reloc_code.c src/c/
	$(MV) $(RELOC_DIR)/reloc_code.h src/c/
endif

# re2c
$(eval $(call MAKE_RE2C,src/cpp/scan2))

#------------------------------------------------------------------------------
# test
#------------------------------------------------------------------------------
test: $(TARGET_EXE) $(TARGET_LIB) $(Z80NM)
	$(MAKE) -C dev/z80asm_lib test
	$(PERL) -S prove --state=slow,save -j$(TASKS) t/*.t

$(Z80NM): $(Z80NM_DIR)/$(Z80NM)
	$(CP) $(Z80NM_DIR)/$(Z80NM) $(Z80NM)

$(Z80NM_DIR)/$(Z80NM): $(wildcard $(Z80NM_DIR)/*.c $(Z80NM_DIR)/*.h)
	$(MAKE) -C $(Z80NM_DIR)

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
	$(PERL) tools/del_temps.pl
	$(RM) -rf Debug Release x1 x2 x3
	$(RM) -f $(OBJS) $(TEST_SRC_LIB:.c=.o)
	$(RM) -f zcc_opt.def zcc_proj.lst
	$(RM) -f zcc_opt.def microman.bin microman.tap
	$(RM) -f zcc_opt.def mandel.bin   mandel.tap
	$(RM) -rf *.dSYM
	$(RM) -rf $(TARGET_EXE) test*.dir
	$(RM) -f $(TARGET_EXE) test*
	$(RM) -f t/*.tmp t/dev/*.tmp

#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
clean::
	$(RM) -f $(DEPENDS)

-include $(DEPENDS)

#------------------------------------------------------------------------------
# rebuild the tools needed for the tests
#------------------------------------------------------------------------------

rebuild: clean
	$(RM) -f ../z80asm/dev/z80asm_lib/$(TARGET_LIB)
	$(RM) -f ../z80asm/dev/z80asm_lib/z88dk-z80asm_lib.lst
	$(TOUCH) ../z80asm/Makefile ../z80asm/dev/z80asm_lib/Makefile ../z80asm/dev/cpu/Makefile
	$(TOUCH) ../z80asm/src/c/*.rl
	$(MAKE) -C ../common
	$(MAKE) -C ../z80asm
	$(CP) ../z80asm/z88dk-z80asm$(EXESUFFIX) ../../bin/
	$(MAKE) -C ../z80nm
	$(CP) ../z80nm/z88dk-z80nm$(EXESUFFIX) ../../bin/
	$(MAKE) -C ../sccz80
	$(CP) ../sccz80/sccz80$(EXESUFFIX) ../../bin/z88dk-sccz80$(EXESUFFIX)
	$(MAKE) -C ../zcc
	$(CP) ../zcc/zcc$(EXESUFFIX) ../../bin/zcc$(EXESUFFIX)
	$(MAKE) -C ../ticks all
	$(CP) ../ticks/z88dk-dis$(EXESUFFIX) ../../bin/
	$(CP) ../ticks/z88dk-ticks$(EXESUFFIX) ../../bin/
	$(CP) ../ticks/z88dk-gdb$(EXESUFFIX) ../../bin/
	$(MAKE) -C ../zobjcopy all
	$(CP) $(TARGET_EXE) ../../bin/

retest: rebuild
	$(MAKE) -C ../common test
	$(MAKE) -C ../z80asm test
	$(MAKE) -C ../zobjcopy test

