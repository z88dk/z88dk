#-----------------------------------------------------------------------------
# zobjcopy - manipulate z80asm object files
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------
PROJ		:= z88dk-zobjcopy

include ../Make.common

OPT 	:= -O3
#OPT 	:= -O3 -pg

CC			?= gcc
CXX			?= g++
COMMON_FLAGS = -MMD -Wall $(OPT) \
			-I../common -I../../ext/uthash/src -I../../ext/regex \
			-I../../ext/optparse $(UNIXem_CFLAGS)
CFLAGS		+= -std=gnu11 $(COMMON_FLAGS)
CXXFLAGS 	+= -std=gnu++17 $(COMMON_FLAGS)			

INSTALL 	?= install

CXXSRCS		:= $(wildcard *.cpp)
CSRCS		:= \
			../common/die.c \
			../common/fileutil.c \
			../common/objfile.c \
			../common/optparse.c \
			../common/strutil.c \
			../common/strtable.c \
			../common/strpool.c \
			../common/xassert.c \
			../common/xmalloc.c \
			../common/z80asm_defs.c \
			$(wildcard ../../ext/regex/reg*.c)

OBJS	:= $(CXXSRCS:.cpp=.o) $(CSRCS:.c=.o) \
			$(UNIXem_OBJS)

DEPENDS	:= $(CXXSRCS:.cpp=.d) $(CSRCS:.c=.d)

#------------------------------------------------------------------------------
.PHONY: all clean test install

#------------------------------------------------------------------------------
define MAKE_EXE
all: $(1)$(EXESUFFIX)

$(1)$(EXESUFFIX): $(2)
	$(CXX) $(CXXFLAGS) -o $(1)$(EXESUFFIX) $(2) $(LDFLAGS)
	
clean::
	$(RM) $(1)$(EXESUFFIX) $(2)

test:: $(1)$(EXESUFFIX)
ifeq ($(3),1)
	./$(1)$(EXESUFFIX)
endif
endef

#------------------------------------------------------------------------------
$(eval $(call MAKE_EXE,$(PROJ),$(OBJS),0))

#------------------------------------------------------------------------------
test:: $(PROJ)$(EXESUFFIX)
	perl -S prove t/*.t

#------------------------------------------------------------------------------
clean::
	$(RM) $(OBJS) $(DEPENDS) *.bak t/*.bak core

#------------------------------------------------------------------------------
install: $(PROJ)$(EXESUFFIX)
	$(INSTALL) $(PROJ)$(EXESUFFIX) $(PREFIX)/bin/$(PROJ)$(EXESUFFIX)

-include $(DEPENDS)

#------------------------------------------------------------------------------
# rebuild the three tools needed for the tests
rebuild:
	$(MAKE) -C ../z80asm rebuild

retest: rebuild
	$(MAKE) -C ../z80asm retest
