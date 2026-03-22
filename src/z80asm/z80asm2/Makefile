#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

EXE =
ifeq ($(OS),Windows_NT)
  EXE = .exe
endif

PROJ = z88dk-z80asm

PERL = perl
DOS2UNIX = dos2unix
CXX = g++
CXXFLAGS = -std=gnu++17 -MMD -Wall -Wextra -Wpedantic -Werror -O3

# re2c: generate C/C++ sources from .re files
RE2C ?= re2c
RE2CFLAGS ?= -W --no-debug-info --no-generation-date 

OBJ_DIR = obj

SRCS := $(wildcard *.cpp)
OBJS := $(patsubst %.cpp,$(OBJ_DIR)/%.o,$(SRCS))
DEFS := $(wildcard *.def)

# Dependency files
DEPENDS := $(OBJS:.o=.d)

ASTYLE	= astyle --style=attach --pad-oper --align-pointer=type \
		  --break-closing-braces --add-braces --attach-return-type \
		  --max-code-length=100 --lineend=linux --formatted \
		  --recursive "*.cpp" "*.h" "*.re"

all: $(PROJ)$(EXE)

$(PROJ)$(EXE): $(OBJS) $(DEFS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(PROJ)$(EXE)

$(OBJ_DIR)/%.o: %.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@ 

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Rule to produce .cpp from .re using re2c
$(PROJ)$(EXE): $(OBJ_DIR)/scan.o

scan.cpp: scan.re Makefile
	$(RE2C) $(RE2CFLAGS) scan.re -o scan.cpp
	$(DOS2UNIX) scan.cpp


test:: $(PROJ)$(EXE)
	$(PERL) -S prove -j9 --state=slow,save t/*.t

astyle:
	$(ASTYLE)

cloc:
	$(PERL) -S cloc --fullpath .

CLEAN_PATTERNS = *.o *.d *.i *.exe *.orig *.core *.bak *~
CLEAN_DIRS = . t
CLEAN_FILES = \
  $(foreach d,$(CLEAN_DIRS), \
    $(foreach p,$(CLEAN_PATTERNS), \
      $(wildcard $(d)/$(p)) \
    ) \
  )

clean:
	$(RM) $(PROJ) $(PROJ)$(EXE) $(CLEAN_FILES)
	$(RM) -r $(OBJ_DIR)

-include $(DEPENDS)
