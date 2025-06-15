#------------------------------------------------------------------------------
# z80asm
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

PROJ =		z80asm

ifeq ($(OS),Windows_NT)
  EXESUFFIX := .exe
else
  EXESUFFIX ?=
endif

# debug release unit_tests
BUILD		?= release

# Set output directories based on build type
ifeq ($(BUILD),release)
  OUTDIR 	:= build/release
else
  ifeq ($(BUILD),debug)
    OUTDIR 	:= build/debug
  else
    OUTDIR	:= build/unit_tests
  endif
endif

OBJDIR 		:= $(OUTDIR)/obj
BINDIR 		:= $(OUTDIR)/bin

TARGET 		= $(BINDIR)/$(PROJ)$(EXESUFFIX)

SRCS		= $(wildcard *.cpp)
OBJS		= $(patsubst %.cpp,$(OBJDIR)/%.o,$(SRCS))

TEMPLATE_C	=                                                       ../../common/z80asm_defs.c
TEMPLATE_CPP= token.cpp operator.cpp obj_module.cpp line_parser.cpp                            cpu.cpp symbol.cpp
TEMPLATE_H	= token.h   operator.h   obj_module.h   line_parser.h   ../../common/z80asm_defs.h cpu.h   symbol.h
DEPENDS		= $(patsubst %.cpp,$(OBJDIR)/%.d,$(SRCS))

CXX			?= g++
CXX_FLAGS	+= -std=gnu++17 -MMD -Wall -Wextra -Werror -pedantic-errors

ifeq ($(BUILD),release)
  CXX_FLAGS += -O3
else
  ifeq ($(BUILD),debug)
    CXX_FLAGS+= -g
  else
    CXX_FLAGS+= -g -DUNIT_TESTS
  endif
endif

LDFLAGS		+= 

TASKS 		?= 9

all: $(TARGET)

all_builds:
	$(MAKE) BUILD=debug      
	$(MAKE) BUILD=release    
	$(MAKE) BUILD=unit_tests 

# link
$(TARGET): $(OBJS) | $(BINDIR)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

# compile
$(OBJDIR)/%.o: %.cpp | $(OBJDIR)
	$(CXX) $(CXX_FLAGS) -c $< -o $@

# create directories
$(OBJDIR) $(BINDIR):
	mkdir -p $@

# preprocess
$(patsubst %.c,$(OBJDIR)/%.o,$(TEMPLATE_C)):		$(PROJ).pp
$(patsubst %.cpp,$(OBJDIR)/%.o,$(TEMPLATE_CPP)):	$(PROJ).pp
$(patsubst %.h,$(OBJDIR)/%.o,$(TEMPLATE_H)):		$(PROJ).pp

$(PROJ).pp: $(TEMPLATE_C) $(TEMPLATE_CPP) $(TEMPLATE_H) $(PROJ).y mkparser.pl Makefile
	perl mkparser.pl $(PROJ).y $(TEMPLATE_C) $(TEMPLATE_CPP) $(TEMPLATE_H)
	touch $(PROJ).pp

$(PROJ).y: directives.y opcodes.y
	cat directives.y opcodes.y > $(PROJ).y
	dos2unix $(PROJ).y

test: all_builds
	$(MAKE) BUILD=debug      do_test
	$(MAKE) BUILD=release    do_test
	$(MAKE) BUILD=unit_tests do_test

do_test: $(TARGET)
ifeq ($(BUILD),unit_tests)
	$(TARGET)
else
	TARGET=$(TARGET) perl -S prove --state=slow,save -j$(TASKS) t/*.t
endif

clean::
	$(RM) $(wildcard *.bak t/*.bak)
	$(RM) -rf build

cloc:
	perl -S cloc *.cpp *.h *.pl t/*.t t/*.pl

# Dependencies
-include $(DEPENDS)

.PHONY: all clean
