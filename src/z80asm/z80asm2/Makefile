#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

PROJ = z88dk-z80asm

EXE =
ifeq ($(OS),Windows_NT)
  EXE = .exe
endif

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
		  --exclude="opcodes_tables_1.cpp" \
		  --exclude="opcodes_tables_2.cpp" \
		  --exclude="opcodes_tables_3.cpp" \
		  --exclude="opcodes_tables_4.cpp" \
		  --exclude="opcodes_tables_5.cpp" \
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
	mkdir -p $(OBJ_DIR)

$(TEST_OBJ_DIR):
	mkdir -p $(TEST_OBJ_DIR)

# Rule to produce .cpp from .re using re2c
$(PROJ)$(EXE): $(OBJ_DIR)/scan.o

scan.cpp: scan.re Makefile
	$(RE2C) $(RE2CFLAGS) -o scan.cpp scan.re
	dos2unix scan.cpp 2> /dev/null

# Rule to procude opcodes_tables.cpp
$(PROJ)$(EXE): $(OBJ_DIR)/opcodes_tables.o

opcodes_tables.cpp: $(wildcard *.def cpu/*.pl cpu/*.pm) Makefile cpu/Makefile 
	$(MAKE) -C cpu

test:: $(TEST_BINS)
	@for test in $(TEST_BINS); do \
		echo "Running $$test..."; \
		./$$test || exit 1; \
	done

test:: $(PROJ)$(EXE)
	perl -S prove --state=slow,save t/*.t

astyle:
	$(ASTYLE)

cloc:
	perl -S cloc --fullpath --not-match-f="./unittests/catch_amalgamated.*" .

clean:
	$(RM) $(PROJ) $(PROJ)$(EXE) $(TEST_BINS) \
		  $(wildcard *.o *.d *.i *.exe *.orig *.core *.bak *~) \
		  $(wildcard $(TEST_DIR)/*.o $(TEST_DIR)/*.d $(TEST_DIR)/*.i $(TEST_DIR)/*.exe $(TEST_DIR)/*.orig $(TEST_DIR)/*.core $(TEST_DIR)/*.bak $(TEST_DIR)/*~) \
		  $(wildcard t/*.o t/*.d t/*.i t/*.exe t/*.orig t/*.core t/*.bak t/*~)
	$(RM) -r $(OBJ_DIR) $(TEST_OBJ_DIR) $(wildcard test_t_*)

-include $(DEPENDS)
