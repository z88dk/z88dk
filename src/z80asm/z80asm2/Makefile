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
CXXFLAGS_BASE = -std=gnu++17 -Itest -MMD -Wall -Wextra -Wpedantic -Werror
ifeq ($(COVERAGE),1)
  CXXFLAGS_DEBUG = $(CXXFLAGS_BASE) -D_DEBUG --coverage -O0 -g
else
  CXXFLAGS_DEBUG = $(CXXFLAGS_BASE) -D_DEBUG -O0 -g
endif
CXXFLAGS_RELEASE = $(CXXFLAGS_BASE) -DNDEBUG -O3

# re2c: generate C/C++ sources from .re files
RE2C ?= re2c
RE2CFLAGS ?= -W --no-debug-info --no-generation-date --tags

INSTALL ?= install

DEBUG_DIR   = build/Debug
RELEASE_DIR = build/Release

SRCS := $(wildcard *.cpp)
DEBUG_SRCS := $(wildcard test/*.cpp)
DEFS := $(wildcard *.def test/*.def)

DEBUG_OBJS    := $(patsubst %.cpp,$(DEBUG_DIR)/%.o,$(SRCS) $(DEBUG_SRCS))
RELEASE_OBJS  := $(patsubst %.cpp,$(RELEASE_DIR)/%.o,$(SRCS))
DEBUG_DEPENDS   := $(DEBUG_OBJS:.o=.d)
RELEASE_DEPENDS := $(RELEASE_OBJS:.o=.d)

DEBUG_EXE   = $(DEBUG_DIR)/$(PROJ)$(EXE)
RELEASE_EXE = $(RELEASE_DIR)/$(PROJ)$(EXE)

STYLE_WIDTH = 80
ASTYLE	= astyle --style=attach --pad-oper --align-pointer=type \
		  --break-closing-braces --add-braces --attach-return-type \
		  --max-code-length=$(STYLE_WIDTH) --lineend=linux --formatted 
PERLTIDY = perltidy --indent-columns=4 --continuation-indentation=4 \
		  --maximum-line-length=$(STYLE_WIDTH) -b
TIDY_STAMP = .tidy-stamp

all: $(DEBUG_EXE) $(RELEASE_EXE)

$(DEBUG_EXE): $(DEBUG_OBJS) $(DEFS)
	$(CXX) $(CXXFLAGS_DEBUG) $(DEBUG_OBJS) -o $@

$(RELEASE_EXE): $(RELEASE_OBJS) $(DEFS)
	$(CXX) $(CXXFLAGS_RELEASE) $(RELEASE_OBJS) -o $@
	strip $@

$(DEBUG_DIR)/%.o: %.cpp | $(DEBUG_DIR) $(DEBUG_DIR)/test
	$(CXX) $(CXXFLAGS_DEBUG) -c $< -o $@

$(RELEASE_DIR)/%.o: %.cpp | $(RELEASE_DIR)
	$(CXX) $(CXXFLAGS_RELEASE) -c $< -o $@

$(DEBUG_DIR) $(DEBUG_DIR)/test $(RELEASE_DIR):
	mkdir -p $@

# Rule to produce .cpp from .re using re2c
lexer_scan.cpp: lexer_scan.re Makefile
	$(RE2C) $(RE2CFLAGS) lexer_scan.re -o lexer_scan.cpp
	dos2unix lexer_scan.cpp

# Rules to generate opcodes tables
$(DEBUG_DIR)/opcodes.o $(RELEASE_DIR)/opcodes.o: opcodes_trie_token.h
$(DEBUG_DIR)/opcodes_trie_token.o $(RELEASE_DIR)/opcodes_trie_token.o: opcodes_trie_token.cpp opcodes_trie_token.h

opcodes_trie_token.h opcodes_trie_token.cpp \
opcodes_synth_trie.h opcodes_synth_trie.cpp \
opcodes_parse_trie.h opcodes_parse_trie.cpp &: \
		$(wildcard *.def) \
		$(wildcard cpu/*.dat cpu/*.pl cpu/*.pm) \
		Makefile cpu/Makefile 
	$(MAKE) -C cpu

# test
$(DEBUG_DIR)/test/test_driver.o : test/test_driver.def

test/test_driver.def : $(wildcard test/*.cpp) tools/make_tests.pl Makefile
	perl tools/make_tests.pl test $@
	dos2unix $@

test: $(DEBUG_EXE) $(RELEASE_EXE)
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
	gcov $(DEBUG_DIR)/*.gcno | perl tools/parse_gcov.pl | tee tools/coverage.txt

CLEAN_PATTERNS = *.o *.gcov *.exe *.orig *.core *.bak *.new *~
CLEAN_DIRS = . t t/* t/*/*
CLEAN_FILES = \
  $(foreach d,$(CLEAN_DIRS), \
    $(foreach p,$(CLEAN_PATTERNS), \
      $(wildcard $(d)/$(p)) \
    ) \
  )

clean:
	$(RM) $(CLEAN_FILES) $(TIDY_STAMP)
	$(RM) -r build

install: $(RELEASE_EXE)
	$(INSTALL) $(RELEASE_EXE) $(PREFIX)/bin/$(PROJ)$(EXE)
	$(INSTALL) tools/ObjModule.pm $(PREFIX)/bin/ObjModule.pm
	$(INSTALL) tools/z88dk-z80objcopy.pl $(PREFIX)/bin/z88dk-z80objcopy.pl

-include $(DEBUG_DEPENDS) $(RELEASE_DEPENDS)
