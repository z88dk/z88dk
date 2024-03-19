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

CXX_FLAGS	+= -std=gnu++17 -MMD -I. -Wall -ggdb $(OPT) \
			-Wextra -Werror -pedantic-errors 

# link boost::filesystem if needed
LDFLAGS 	+= $(shell perl ../tools/build_ldflags.pl $(CXX) $(CROSS)) 

#------------------------------------------------------------------------------
# Object files
#------------------------------------------------------------------------------

SRCS		:= $(wildcard *.cpp)
TSRCS		:= $(wildcard t/*.cpp)
OBJS		:= $(SRCS:.cpp=.o)
DEPENDS		:= $(SRCS:.cpp=.d) $(TSRCS:.cpp=.d)

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

ifeq ($(3),1)
test:: $(1)$(EXESUFFIX)
	perl -S prove $(1)$(EXESUFFIX)
endif
endef

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

test::
	perl build_unit_tests.pl

-include Make.tests

#------------------------------------------------------------------------------
# Dependencies
#------------------------------------------------------------------------------
clean::
	$(RM) $(DEPENDS)

-include $(DEPENDS)

