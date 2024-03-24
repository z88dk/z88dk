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

CXX			?= g++
INSTALL 	?= install

OPT 		= -O3
COMMON_FLAGS = -MMD -Wall -ggdb -Wextra -Werror -pedantic-errors $(OPT) \
			-I. -I../../common
CFLAGS 		+= -std=gnu11 $(COMMON_FLAGS)
CXX_FLAGS	+= -std=gnu++17 $(COMMON_FLAGS)

# link boost::filesystem if needed
LDFLAGS 	+= $(shell perl ../tools/build_ldflags.pl $(CXX) $(CROSS)) 

#------------------------------------------------------------------------------
# Object files
#------------------------------------------------------------------------------

LIB_SRCS	:= ../../common/xassert.c ../../common/xmalloc.c ../../common/dirname.c
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
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------

$(eval $(call MAKE_EXE,$(PROJ),$(OBJS),0))

$(TARGET_EXE): ../../config.h

../../config.h:
	make -C ../../.. src/config.h

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

