#------------------------------------------------------------------------------
# z80asm
# Copyright (C) Paulo Custodio, 2011-2024
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

PROJ =		z80asm
TARGET =	$(PROJ)$(EXESUFFIX)

CXX1		?= g++
CXX_FLAGS	+= -std=gnu++17 -MMD -Wall -Wextra -Werror -pedantic-errors $(OPT)
OPT			?= -O3

SRCS		= $(wildcard *.cpp)
OBJS		= $(SRCS:.cpp=.o)
TEMPLATECPP	= token.cpp operator.cpp $(PROJ).cpp 
TEMPLATEH	= token.h   operator.h
DEPENDS		= $(SRCS:.cpp=.d)


all: $(PROJ)$(EXESUFFIX)

$(PROJ)$(EXESUFFIX): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) $(LDFLAGS) -o $(PROJ)$(EXESUFFIX)

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

$(TEMPLATECPP:.cpp=.o): $(PROJ).pp
$(TEMPLATEH:.h=.o):     $(PROJ).pp

$(PROJ).pp: $(TEMPLATECPP) $(TEMPLATEH) $(PROJ).y mkparser.pl Makefile
	perl mkparser.pl $(PROJ).y $(TEMPLATECPP) $(TEMPLATEH)
	touch $(PROJ).pp

$(PROJ).y: directives.y opcodes.y
	cat directives.y opcodes.y > $(PROJ).y
	dos2unix $(PROJ).y

test: $(PROJ)$(EXESUFFIX)
	./$(PROJ)$(EXESUFFIX) test.asm

clean::
	$(RM) $(PROJ)$(EXESUFFIX) $(OBJS) $(PROJ).pp $(PROJ).y $(wildcard *.bak) $(DEPENDS)

# Dependencies
-include $(DEPENDS)
