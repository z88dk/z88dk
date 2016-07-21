#------------------------------------------------------------------------------
# Makefile for z80asm
# Copyright (c) Paulo Custodio, 2015-2016
# License: http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# project
PROJ 		:= z80asm2

# platform - include defines needed by stlplus3
UNAME		:= $(shell uname -s)

ifeq ($(OS),Windows_NT)
  EXE		:= .exe
  ifneq ($(findstring MINGW,$(UNAME)),)
    PLATFORM := MINGW
	CXXFLAGS += -U__STRICT_ANSI__
	LDFLAGS  += -lWs2_32 -static
  else
    ifneq ($(findstring Cygwin,$(UNAME)),)
      PLATFORM := CYGWIN
	endif
  endif
else
  EXE 		:=
  ifneq ($(findstring Linux,$(UNAME)),)
    PLATFORM  := GNULINUX
	CXXFLAGS  += -fPIC
  else
    ifneq ($(findstring FreeBSD,$(UNAME)),)
      PLATFORM := FREEBSD
	else
	  ifneq ($(findstring OpenBSD,$(UNAME)),)
        PLATFORM := OPENBSD
      else
	    ifneq ($(findstring NetBSD,$(UNAME)),)
          PLATFORM := NETBSD
		  LDFLAGS  += -lm
		else
		  ifneq ($(findstring SunOS,$(UNAME)),)
		    PLATFORM := SOLARIS
			LDFLAGS  += -lsocket
		  else
			ifneq ($(findstring Darwin,$(UNAME)),)
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
CXXFLAGS += \
-D$(PLATFORM) \
-pedantic \
-MMD \
-I. \
-It \
-std=c++98 \
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
CXXFLAGS	+= -Iext/libtappp/include

# Lib STL Plus 3 for C++
EXT_SRCS	+= \
$(wildcard ext/stlplus3/containers/*.cpp) \
$(wildcard ext/stlplus3/persistence/*.cpp) \
$(wildcard ext/stlplus3/portability/*.cpp) \
$(wildcard ext/stlplus3/strings/*.cpp) \
$(wildcard ext/stlplus3/subsystems/*.cpp)
CXXFLAGS	+= \
-Iext/stlplus3/containers \
-Iext/stlplus3/persistence \
-Iext/stlplus3/portability \
-Iext/stlplus3/strings \
-Iext/stlplus3/subsystems

# external library
EXT_LIB		:= ext
EXT_OBJS 	:= $(EXT_SRCS:%.cpp=%.o)
DEPENDS		+= $(EXT_SRCS:%.cpp=%.d)

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

# do not delete intermediate targets
.SECONDARY:

# Targets
.PHONY: all preproc test clean install

# Default: all
all: 

# preprocessed files
preproc: messages.cpp messages.hpp
messages.cpp messages.hpp: messages.pl
	perl messages.pl

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
