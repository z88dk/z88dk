#------------------------------------------------------------------------------
# z80asm
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# developer generated source files, and test libs
# only run with DEVELOPER=1 to fix #2332 (Build fails on cygwin), 
# #2369 (wrong re2c output on Snapcraft), build failure of
# .github/workflows/build-mingw-on-ubuntu.yml
#------------------------------------------------------------------------------

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX             := .exe
else
  EXESUFFIX             ?=
endif

# Set to 1 when cross-compiling
CROSS           ?= 0

BARE_PROJ	:= z80asm
PROJ		:= z88dk-$(BARE_PROJ)

TARGET_EXE	:= $(PROJ)$(EXESUFFIX)

CC 			?= gcc
CXX			?= g++
INSTALL 	?= install
RE2C		= re2c -W --tags --no-debug-info --no-generation-date 

OPT 		= -O3
COMMON_FLAGS = -MMD -Wall -ggdb $(OPT) \
			-I. -I../../common -I../../../ext/uthash/src
CFLAGS 		+= -std=gnu11 $(COMMON_FLAGS)
CXX_FLAGS	+= -std=gnu++17 -Wextra -Werror -pedantic-errors $(COMMON_FLAGS)

# link boost::filesystem if needed
LDFLAGS 	+= $(shell perl ../tools/build_ldflags.pl $(CXX) $(CROSS)) 

#------------------------------------------------------------------------------
# Object files
#------------------------------------------------------------------------------

LIB_SRCS	:= ../../common/xassert.c \
			   ../../common/xmalloc.c \
			   ../../common/dirname.c \
			   ../../common/z80asm_defs.c
			   
LIB_OBJS	:= $(LIB_SRCS:.c=.o) 

CXX_SRCS	:= $(wildcard *.cpp)
TSRCS		:= $(wildcard t/*.cpp)
OBJS		:= $(CXX_SRCS:.cpp=.o) $(LIB_OBJS)
DEPENDS		:= $(CXX_SRCS:.cpp=.d) $(TSRCS:.cpp=.d) $(LIB_SRCS:.c=.d)

#------------------------------------------------------------------------------
.PHONY: all clean test install
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# rule to make executable
#------------------------------------------------------------------------------

define MAKE_EXE
all: $(1)$(EXESUFFIX)

$(1)$(EXESUFFIX): $(2) lib$(PROJ).a
	$(CXX) $(CXXFLAGS) $(2) $(LDFLAGS) -L. -l$(PROJ) -o $(1)$(EXESUFFIX)
	
clean::
	$(RM) $(1) $(1)$(EXESUFFIX) $(2) lib$(PROJ).a

ifeq ($(3),1)
test:: $(1)$(EXESUFFIX)
	$(1)$(EXESUFFIX)
endif
endef

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

#------------------------------------------------------------------------------
# rule to call re2c
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

$(eval $(call MAKE_EXE,$(PROJ),$(OBJS),0))
$(eval $(call MAKE_RE2C,scan))

$(TARGET_EXE): ../../config.h

../../config.h:
	$(MAKE) -C ../../.. src/config.h

ifeq ($(DEVELOPER),1)
parser.o: cpu/parse_code.h
cpu/parse_code.h: $(wildcard cpu/*.pl cpu/*.yaml)
	$(MAKE) -C cpu
endif

#------------------------------------------------------------------------------
# test
#------------------------------------------------------------------------------

test:: lib$(PROJ).a
	perl build_unit_tests.pl

lib$(PROJ).a: $(OBJS)
	ar -crs lib$(PROJ).a $(OBJS)

-include Make.tests

#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
clean::
	$(RM) $(DEPENDS)

-include $(DEPENDS)

