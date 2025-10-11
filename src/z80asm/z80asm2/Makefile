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

TEST_DIR = unittests

SRCS := $(wildcard *.cpp)
OBJS := $(SRCS:.cpp=.o)
DEFS := $(wildcard *.def)
COMMON_SRCS := $(filter-out z80asm.cpp, $(SRCS)) $(TEST_DIR)/catch_amalgamated.cpp
COMMON_OBJS := $(COMMON_SRCS:.cpp=.o)

TEST_SRCS := $(wildcard $(TEST_DIR)/test_*.cpp)
TEST_BINS := $(patsubst $(TEST_DIR)/%.cpp, $(TEST_DIR)/%$(EXE), $(TEST_SRCS))
TEST_OBJS = $(TEST_SRCS:.cpp=.o)

DEPENDS := $(SRCS:.cpp=.d) $(COMMON_SRCS:.cpp=.d) $(TEST_SRCS:.cpp=.d)

ASTYLE	= astyle --style=attach --pad-oper --align-pointer=type \
		  --break-closing-braces --add-braces --attach-return-type \
		  --max-code-length=80 --lineend=linux --formatted \
		  --recursive "*.cpp" "*.h" "*.hpp"


all: $(PROJ)$(EXE) $(TEST_BINS)

$(PROJ)$(EXE): $(OBJS) $(DEFS)
	$(CXX) $(CXXFLAGS) -o $(PROJ)$(EXE) $(OBJS)

test:: $(PROJ)$(EXE)
	perl -S prove --state=slow,save t/*.t

test:: $(TEST_BINS)
	@for test in $(TEST_BINS); do \
		echo "Running $$test..."; \
		./$$test || exit 1; \
	done

x:
	echo $(COMMON_OBJS)

$(TEST_DIR)/test_%$(EXE): $(TEST_DIR)/test_%.o $(COMMON_OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(TEST_DIR)/%.o: $(TEST_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

astyle:
	$(ASTYLE)

cloc:
	perl -S cloc --fullpath --not-match-f="./unittests/catch_amalgamated.*" .

clean:
	$(RM) $(PROJ) $(PROJ)$(EXE) $(TEST_BINS) $(OBJS) $(DEPENDS) \
		  $(wildcard *.o *.d *.i *.exe *.orig *.core *.bak *~)

-include $(DEPENDS)
