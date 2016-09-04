#------------------------------------------------------------------------------
# Makefile for z80asm
# Copyright (c) Paulo Custodio, 2015-2016
# License: http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

PROJ 		:= 	z80asm2

ifeq ($(OS),Windows_NT)
  EXE		:= 	.exe
else
  EXE 		:=
endif

MYCXXFLAGS 	+= 	-pedantic -Wall -Wextra \
				-MMD -I. -It -It/libtappp/include -O3

CC 			?=	gcc
INSTALL 	?=	install

CFLAGS 		+= 	-std=c99   $(MYCXXFLAGS)
CXXFLAGS 	+= 	-std=c++98 $(MYCXXFLAGS)

LDFLAGS 	+= 	-L. -l$(PROJ)
LIB_FILES	+=	lib$(PROJ).a

SRCS 		:=	$(wildcard *.cpp) \
				$(wildcard t/libtappp/src/*.cpp)
OBJS		:= 	$(SRCS:%.cpp=%.o)
DEPENDS		+= 	$(SRCS:%.cpp=%.d)

# test programs
T_SRCS		:= 	$(wildcard t/libtappp/t/*.cpp) \
				$(wildcard t/*.cpp)
T_OBJS		:= 	$(T_SRCS:%.cpp=%.o)
TESTS	 	:= 	$(T_SRCS:%.cpp=%)
DEPENDS		+= 	$(T_SRCS:%.cpp=%.d)

RUNTESTS_C	:= perl t/libtappp/run_tests.pl
RUNTESTS_T	:= perl -S prove --color

# do not delete intermediate targets
.SECONDARY:

# Targets
.PHONY: all preproc test clean install

# Default: all
all: preproc

all: $(PROJ)$(EXE)
$(PROJ)$(EXE): main.o $(LIB_FILES); $(CXX) $< $(LDFLAGS) -o $@
clean::; rm -f $(PROJ)$(EXE) main.o

# Build targets for test executable
define make-exe
  all: $(1)$(EXE)
  $(1)$(EXE): $(1).o $(LIB_FILES); $(CXX) $(1).o $(LDFLAGS) -o $(1)$(EXE)
  clean::; rm -f $(1)$(EXE) $(1).o
endef
$(foreach exe,$(TESTS),$(eval $(call make-exe,$(exe))))

# Build targets for libraries
define make-lib
  all: lib$(1).a
  lib$(1).a: $(2); ar rcs lib$(1).a $(2)
  clean::; rm -f lib$(1).a $(2)
endef
$(eval $(call make-lib,$(PROJ),$(OBJS)))

# preprocessed files
preproc:

# Target: test
test: all
	$(RUNTESTS_C) $(TESTS)
	$(RUNTESTS_T) $(wildcard t/*.t)

# Target: clean
clean::
	rm -f $(DEPENDS)

# Target: install - postponed
install:
#	$(INSTALL) $(PROJ)$(EXE) $(PREFIX)/bin/

-include $(DEPENDS)
