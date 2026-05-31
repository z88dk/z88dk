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

CXX = g++
CXXFLAGS_BASE = -std=gnu++17 -MMD -Wall -Wextra -Wpedantic -Werror 
ifeq ($(COVERAGE),1)
  CXXFLAGS = $(CXXFLAGS_BASE) --coverage -O0 -g
else
  CXXFLAGS = $(CXXFLAGS_BASE) -O3
endif

# re2c: generate C/C++ sources from .re files
RE2C ?= re2c
RE2CFLAGS ?= -W --no-debug-info --no-generation-date --tags

OBJ_DIR = obj

SRCS := $(wildcard *.cpp)
OBJS := $(patsubst %.cpp,$(OBJ_DIR)/%.o,$(SRCS))
DEFS := $(wildcard *.def)

# Dependency files
DEPENDS := $(OBJS:.o=.d)

STYLE_WIDTH = 100
ASTYLE	= astyle --style=attach --pad-oper --align-pointer=type \
		  --break-closing-braces --add-braces --attach-return-type \
		  --max-code-length=$(STYLE_WIDTH) --lineend=linux --formatted 
PERLTIDY = perltidy --indent-columns=4 --continuation-indentation=4 \
		  --maximum-line-length=$(STYLE_WIDTH) -b
TIDY_STAMP = .tidy-stamp

all: $(PROJ)$(EXE)

$(PROJ)$(EXE): $(OBJS) $(DEFS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(PROJ)$(EXE)

$(OBJ_DIR)/%.o: %.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@ 

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Rule to produce .cpp from .re using re2c
$(PROJ)$(EXE): $(OBJ_DIR)/lexer_scan.o

lexer_scan.cpp: lexer_scan.re Makefile
	$(RE2C) $(RE2CFLAGS) lexer_scan.re -o lexer_scan.cpp
	dos2unix lexer_scan.cpp

# Rules to generate opcodes tables
$(PROJ)$(EXE): $(OBJ_DIR)/opcodes.o $(OBJ_DIR)/opcodes_trie_token.o
$(OBJ_DIR)/opcodes.o: opcodes_trie_token.h
$(OBJ_DIR)/opcodes_trie_token.o: opcodes_trie_token.cpp opcodes_trie_token.h

opcodes_trie_token.h opcodes_trie_token.cpp \
opcodes_synth_trie.h opcodes_synth_trie.cpp \
opcodes_parse_trie.h opcodes_parse_trie.cpp &: \
		$(wildcard *.def) \
		$(wildcard cpu/*.dat cpu/*.pl cpu/*.pm) \
		Makefile cpu/Makefile 
	$(MAKE) -C cpu

test:: $(PROJ)$(EXE)
	perl -S prove -j9 --state=slow,save t/*.t t/*/*.t

tidy:
	@[ -f $(TIDY_STAMP) ] || touch -t 197001010000 $(TIDY_STAMP)
	find . \( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.re' \) \
		-newer $(TIDY_STAMP) -exec $(ASTYLE) {} +
	find . \( -name '*.pl' -o -name '*.pm' -o -name '*.t' \) \
		-newer $(TIDY_STAMP) -exec $(PERLTIDY) {} +
	touch $(TIDY_STAMP)

cloc:
	perl -S cloc --fullpath .

# test code coverage
coverage:
	$(MAKE) clean tidy
	$(MAKE) COVERAGE=1 test
	gcov $(OBJ_DIR)/*.gcno | perl tools/parse_gcov.pl | tee tools/coverage.txt

CLEAN_PATTERNS = *.o *.d *.gcov *.exe *.orig *.core *.bak *.new *~
CLEAN_DIRS = . t t/* t/*/*
CLEAN_FILES = \
  $(foreach d,$(CLEAN_DIRS), \
    $(foreach p,$(CLEAN_PATTERNS), \
      $(wildcard $(d)/$(p)) \
    ) \
  )

clean:
	$(RM) $(PROJ) $(PROJ)$(EXE) $(CLEAN_FILES) $(TIDY_STAMP)
	$(RM) -r $(OBJ_DIR)

-include $(DEPENDS)
