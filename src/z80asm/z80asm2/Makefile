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

all: $(PROJ)$(EXESUFFIX)

$(PROJ)$(EXESUFFIX): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) $(LDFLAGS) -o $(PROJ)$(EXESUFFIX)

%.o: %.cpp
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

$(PROJ).o: $(PROJ).pp

$(PROJ).pp: $(PROJ).cpp mkparser.pl parser.y Makefile
	perl mkparser.pl $(PROJ).cpp parser.y
	touch $(PROJ).pp

test: $(PROJ)$(EXESUFFIX)
	./$(PROJ)$(EXESUFFIX) test.asm
