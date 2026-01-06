#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# windows portability layer
PERL     = perl
CP       = $(PERL) ../tools/posix.pl cp
RM       = $(PERL) ../tools/posix.pl rm
MV       = $(PERL) ../tools/posix.pl mv
MKDIR    = $(PERL) ../tools/posix.pl mkdir
TOUCH    = $(PERL) ../tools/posix.pl touch
INSTALL  = $(PERL) ../tools/posix.pl install
DOS2UNIX = $(PERL) ../tools/posix.pl dos2unix

EXE =
ifeq ($(OS),Windows_NT)
  EXE = .exe
endif

PROJ = z88dk-z80asm


CXX = g++
CXXFLAGS = -std=gnu++17 -MMD -Wall -Wextra -Wpedantic -Werror -O3

# re2c: generate C/C++ sources from .re files
RE2C ?= re2c
RE2CFLAGS ?= -W --tags --no-debug-info --no-generation-date 

TEST_DIR = unittests
OBJ_DIR = obj
TEST_OBJ_DIR = $(TEST_DIR)/obj

SRCS := $(wildcard *.cpp)
OBJS := $(patsubst %.cpp,$(OBJ_DIR)/%.o,$(SRCS))
DEFS := $(wildcard *.def)

# Common sources (excluding main) for unit tests
COMMON_SRCS := $(filter-out z80asm.cpp, $(SRCS))
COMMON_TEST_OBJS := $(patsubst %.cpp,$(TEST_OBJ_DIR)/%.o,$(COMMON_SRCS))

# Catch framework
CATCH_OBJ := $(TEST_OBJ_DIR)/catch_amalgamated.o

# Test sources and binaries
TEST_SRCS := $(wildcard $(TEST_DIR)/test_*.cpp)
TEST_BINS := $(patsubst $(TEST_DIR)/%.cpp, $(TEST_DIR)/%$(EXE), $(TEST_SRCS))
TEST_OBJS := $(patsubst $(TEST_DIR)/%.cpp,$(TEST_OBJ_DIR)/%.o,$(TEST_SRCS))

# Dependency files
DEPENDS := $(OBJS:.o=.d) $(COMMON_TEST_OBJS:.o=.d) $(TEST_OBJS:.o=.d) $(CATCH_OBJ:.o=.d)

ASTYLE	= astyle --style=attach --pad-oper --align-pointer=type \
		  --break-closing-braces --add-braces --attach-return-type \
		  --max-code-length=120 --lineend=linux --formatted \
		  --exclude="opcodes_tables.h" \
		  --exclude="opcodes_tables.cpp" \
		  --exclude="unittests/catch_amalgamated.hpp" \
		  --exclude="unittests/catch_amalgamated.cpp" \
		  --recursive "*.cpp" "*.h"

all: $(PROJ)$(EXE) $(TEST_BINS)

# Main executable (no -DUNIT_TESTS)
$(PROJ)$(EXE): $(OBJS) $(DEFS)
	$(CXX) $(CXXFLAGS) -o $(PROJ)$(EXE) $(OBJS)

# Object files for main executable (no -DUNIT_TESTS)
$(OBJ_DIR)/%.o: %.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Object files for unit tests (with -DUNIT_TESTS)
$(TEST_OBJ_DIR)/%.o: %.cpp | $(TEST_OBJ_DIR)
	$(CXX) $(CXXFLAGS) -DUNIT_TESTS -c -o $@ $<

# Test driver object files (with -DUNIT_TESTS)
$(TEST_OBJ_DIR)/%.o: $(TEST_DIR)/%.cpp | $(TEST_OBJ_DIR)
	$(CXX) $(CXXFLAGS) -DUNIT_TESTS -c -o $@ $<

# Link test executables
$(TEST_DIR)/test_%$(EXE): $(TEST_OBJ_DIR)/test_%.o $(COMMON_TEST_OBJS) $(CATCH_OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^

# Create output directories
$(OBJ_DIR):
	$(MKDIR) -p $(OBJ_DIR)

$(TEST_OBJ_DIR):
	$(MKDIR) -p $(TEST_OBJ_DIR)

# Rule to produce .cpp from .re using re2c
$(PROJ)$(EXE): $(OBJ_DIR)/scan.o

scan.cpp: scan.re Makefile
	$(RE2C) $(RE2CFLAGS) -o scan.cpp scan.re
	$(DOS2UNIX) scan.cpp 2> /dev/null

# Rule to procude opcodes_tables.cpp
$(PROJ)$(EXE): $(OBJ_DIR)/opcodes_tables.o
$(OBJ_DIR)/opcodes.o: opcodes_tables.h

opcodes_tables.cpp opcodes_tables.h opcodes_tables.inc: \
		lexer.h $(wildcard *.def) \
		$(wildcard cpu/*.dat cpu/*.pl cpu/*.pm) \
		Makefile cpu/Makefile 
	$(MAKE) -C cpu

# Rule to produce keywords.def filters
$(OBJ_DIR)/preprocessor.o: keywords_preproc_directive.inc

keywords_8bit_register.inc \
keywords_asm_directive.inc \
keywords_conditional_directive.inc \
keywords_flag.inc \
keywords_hla_directive.inc \
keywords_opcode.inc \
keywords_preproc_directive.inc \
keywords_preproc_name_directive.inc \
keywords_register.inc \
keywords_segment_register.inc \
keywords_x_register: \
		make_keywords_filters.pl keywords.def Makefile
	$(PERL) make_keywords_filters.pl keywords.def
	$(DOS2UNIX) keywords*.inc

define run-tests
  $(foreach t,$(1), \
    echo Running $(CURDIR)/$(t)... ; \
    $(CURDIR)/$(t) || exit 1; \
  )
endef

test:: $(TEST_BINS)
	$(call run-tests,$(TEST_BINS))

test:: $(PROJ)$(EXE)
	$(PERL) -S prove --state=slow,save t/*.t

astyle:
	$(ASTYLE)

cloc:
	$(PERL) -S cloc --fullpath --not-match-f="./unittests/catch_amalgamated.*" .

CLEAN_PATTERNS = *.o *.d *.i *.exe *.orig *.core *.bak *~
CLEAN_DIRS = . $(TEST_DIR) t
CLEAN_FILES = \
  $(foreach d,$(CLEAN_DIRS), \
    $(foreach p,$(CLEAN_PATTERNS), \
      $(wildcard $(d)/$(p)) \
    ) \
  )

clean:
	$(RM) -f $(PROJ) $(PROJ)$(EXE) $(TEST_BINS) $(CLEAN_FILES)
	$(RM) -rf $(OBJ_DIR) $(TEST_OBJ_DIR) $(wildcard test_t_*)

-include $(DEPENDS)
