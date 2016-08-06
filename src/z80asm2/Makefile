#------------------------------------------------------------------------------
# Makefile for z80asm
# Copyright (c) Paulo Custodio, 2015-2016
# License: http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# project
PROJ 		:= z80asm2

# platform - include defines needed by stlplus3
UNAME		:= $(shell uname -s | tr a-z A-Z)

ifeq ($(OS),Windows_NT)
  EXE		:= .exe
  ifneq ($(findstring MINGW,$(UNAME)),)
    PLATFORM := MINGW
	MYCXXFLAGS += -U__STRICT_ANSI__
	LDFLAGS  += -lWs2_32 -static
  else
    ifneq ($(findstring CYGWIN,$(UNAME)),)
      PLATFORM := CYGWIN
	endif
  endif
else
  EXE 		:=
  ifneq ($(findstring LINUX,$(UNAME)),)
    PLATFORM  := GNULINUX
	MYCXXFLAGS  += -fPIC
  else
    ifneq ($(findstring FREEBSD,$(UNAME)),)
      PLATFORM := FREEBSD
	else
	  ifneq ($(findstring OPENBSD,$(UNAME)),)
        PLATFORM := OPENBSD
      else
	    ifneq ($(findstring NETBSD,$(UNAME)),)
          PLATFORM := NETBSD
		  LDFLAGS  += -lm
		else
		  ifneq ($(findstring SUNOS,$(UNAME)),)
		    PLATFORM := SOLARIS
			LDFLAGS  += -lsocket
		  else
			ifneq ($(findstring DARWIN,$(UNAME)),)
			  PLATFORM := MACOS
			endif
		  endif
		endif
	  endif
	endif
  endif
endif

ifeq ($(PLATFORM),)
  $(error you need to configure the make system for platform $(UNAME))
endif

# build flags
MYCXXFLAGS += \
		-D$(PLATFORM) \
		-pedantic \
		-MMD \
		-I. \
		-It \
		-Wall -Wextra \
		-O3

LDFLAGS += \
		-L.

INSTALL ?= install

# project library
PROJ_SRCS 	:= $(wildcard *.cpp)
PROJ_OBJS	:= $(PROJ_SRCS:%.cpp=%.o)
DEPENDS		+= $(PROJ_SRCS:%.cpp=%.d)

LDFLAGS		+= -l$(PROJ)
LIB_FILES	+= lib$(PROJ).a

# Lib TAP C++
EXT_SRCS	+= $(wildcard ext/libtappp/src/*.cpp)
MYCXXFLAGS	+= -Iext/libtappp/include

# Lib STL Plus 3 for C++
EXT_SRCS	+= \
		$(wildcard ext/stlplus3/containers/*.cpp) \
		$(wildcard ext/stlplus3/persistence/*.cpp) \
		$(wildcard ext/stlplus3/portability/*.cpp) \
		$(wildcard ext/stlplus3/strings/*.cpp) \
		$(wildcard ext/stlplus3/subsystems/*.cpp)
MYCXXFLAGS	+= \
		-Iext/stlplus3/containers \
		-Iext/stlplus3/persistence \
		-Iext/stlplus3/portability \
		-Iext/stlplus3/strings \
		-Iext/stlplus3/subsystems

# Lib snprintf
EXT_C_SRCS	+= \
		$(wildcard ext/snprintf/*.c)
MYCXXFLAGS	+= \
		-Iext/snprintf

CFLAGS		+= -std=c99   $(MYCXXFLAGS)
CXXFLAGS	+= -std=c++98 $(MYCXXFLAGS)

# external library
EXT_LIB		:= ext
EXT_OBJS 	:= $(EXT_SRCS:%.cpp=%.o) $(EXT_C_SRCS:%.c=%.o)
DEPENDS		+= $(EXT_SRCS:%.cpp=%.d) $(EXT_C_SRCS:%.c=%.d)

LDFLAGS		+= -l$(EXT_LIB)
LIB_FILES	+= lib$(EXT_LIB).a

# test programs
TEST_SRCS	:= $(wildcard ext/libtappp/t/*.cpp) \
			   $(wildcard t/*.cpp)
TEST_OBJS	:= $(TEST_SRCS:%.cpp=%.o)
TESTS	 	:= $(TEST_SRCS:%.cpp=%)
DEPENDS		+= $(TEST_SRCS:%.cpp=%.d)

RUNTESTS_C	:= perl ext/libtappp/run_tests.pl
RUNTESTS_T	:= perl -S prove

RE2C		:= re2c -c -i --no-generation-date --no-version 

# do not delete intermediate targets
.SECONDARY:

# Targets
.PHONY: all preproc test clean install

# Default: all
all: preproc

# preprocessed files
preproc: messages.cpp messages.hpp
messages.cpp messages.hpp: messages.pl; perl $<

preproc: cmdline.cpp
cmdline.cpp: cmdline.re messages.hpp; $(RE2C) -o $@ $<

# Build targets for each executable
define make-exe
  $(1)$(EXE): $(1).o $(LIB_FILES); $(CXX) $(1).o $(LDFLAGS) -o $(1)$(EXE)
  all: $(1)$(EXE)
  clean::; rm -f $(1)$(EXE) $(1).o
endef
$(foreach exe,$(PROJ) $(TESTS),$(eval $(call make-exe,$(exe))))

# Build targets for libraries
define make-lib
  lib$(1).a: $(2); ar rcs lib$(1).a $(2)
  all: lib$(1).a
  clean::; rm -f lib$(1).a $(2)
endef
$(eval $(call make-lib,$(EXT_LIB),$(EXT_OBJS)))
$(eval $(call make-lib,$(PROJ),$(PROJ_OBJS)))

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
