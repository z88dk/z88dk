#------------------------------------------------------------------------------
# z80asm
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
#  SANITIZE			:= 
else
  EXESUFFIX 		?=
#  SANITIZE			:= -fsanitize=address
endif

PROJ =		z80asm
TARGET =	$(PROJ)$(EXESUFFIX)

CXX			?= g++
CXX_FLAGS	+= -std=gnu++17 -MMD -Wall -Wextra -Werror -pedantic-errors $(OPT)
OPT			?= -O3 -g $(SANITIZE)
LDFLAGS		+= $(SANITIZE)

SRCS		= $(wildcard *.cpp)
OBJS		= $(SRCS:.cpp=.o)
TEMPLATEC	=                                                       ../../common/z80asm_defs.c
TEMPLATECPP	= token.cpp operator.cpp obj_module.cpp line_parser.cpp                            cpu.cpp
TEMPLATEH	= token.h   operator.h   obj_module.h   line_parser.h   ../../common/z80asm_defs.h cpu.h
DEPENDS		= $(SRCS:.cpp=.d)

TASKS 		?= 9


all: $(PROJ)$(EXESUFFIX)

$(PROJ)$(EXESUFFIX): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) $(LDFLAGS) -o $(PROJ)$(EXESUFFIX)

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

$(TEMPLATEC:.c=.o): 	$(PROJ).pp
$(TEMPLATECPP:.cpp=.o): $(PROJ).pp
$(TEMPLATEH:.h=.o):     $(PROJ).pp

$(PROJ).pp: $(TEMPLATEC) $(TEMPLATECPP) $(TEMPLATEH) $(PROJ).y mkparser.pl Makefile
	perl mkparser.pl $(PROJ).y $(TEMPLATEC) $(TEMPLATECPP) $(TEMPLATEH)
	touch $(PROJ).pp

$(PROJ).y: directives.y opcodes.y
	cat directives.y opcodes.y > $(PROJ).y
	dos2unix $(PROJ).y

test: 
	$(MAKE) unit_tests
	$(MAKE) system_tests

system_tests: $(PROJ)$(EXESUFFIX)
	perl -S prove --state=slow,save -j$(TASKS) t/*.t

unit_tests:
	$(MAKE) clean
	$(MAKE) OPT=-DUNIT_TESTS $(PROJ)$(EXESUFFIX)
	./$(PROJ)$(EXESUFFIX)
	$(MAKE) clean

clean::
	$(RM) $(PROJ) $(PROJ)$(EXESUFFIX) $(OBJS) $(wildcard *.bak t/*.bak) $(DEPENDS)

cloc:
	perl -S cloc *.cpp *.h *.pl t/*.t t/*.pl

# Dependencies
-include $(DEPENDS)

