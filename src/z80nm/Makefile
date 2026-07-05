#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

PROJ		:= z88dk-z80nm

include ../Make.common

OPT 	:= -O3
#OPT 	:= -O3 -pg

CC 			?= gcc
CXX			?= g++
COMMON_FLAGS = -MMD -Wall $(OPT) \
			-I../common -I../../ext/uthash/src -I../../ext/regex -I../z80asm \
			$(UNIXem_CFLAGS)
CFLAGS		+= -std=gnu11 $(COMMON_FLAGS)
CXXFLAGS 	+= -std=gnu++17 $(COMMON_FLAGS)			

INSTALL ?= install

CXXSRCS		:= $(wildcard *.cpp ../common/*.cpp)
CSRCS		:= \
			../common/die.c \
			../common/fileutil.c \
			../common/objfile.c \
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

# Use these flags both in Windows_NT and in a MinGW build in Unix
ifeq ($(EXESUFFIX),.exe)
CFLAGS		+= -std=gnu11 $(COMMON_FLAGS)
CXXFLAGS	+= -I../../ext/getopt 
OBJS		+= ../../ext/getopt/getopt.o
endif

STYLE_WIDTH = 80
ASTYLE	= astyle --style=attach --pad-oper --align-pointer=type \
		  --break-closing-braces --add-braces --attach-return-type \
		  --max-code-length=$(STYLE_WIDTH) --lineend=linux --formatted 
PERLTIDY = perltidy --indent-columns=4 --continuation-indentation=4 \
		  --maximum-line-length=$(STYLE_WIDTH) -b
TIDY_STAMP = .tidy-stamp


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
	perl -S prove -j9 --state=slow,save t/*.t

#------------------------------------------------------------------------------
tidy:
	@[ -f $(TIDY_STAMP) ] || touch -t 197001010000 $(TIDY_STAMP)
	find . \( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.re' \) \
		-newer $(TIDY_STAMP) -exec $(ASTYLE) {} +
	find . \( -name '*.pl' -o -name '*.pm' -o -name '*.t' \) \
		-newer $(TIDY_STAMP) -exec $(PERLTIDY) {} +
	touch $(TIDY_STAMP)


#------------------------------------------------------------------------------
clean::
	$(RM) $(OBJS) $(DEPENDS) *.bak t/*.bak core

#------------------------------------------------------------------------------
install:  $(PROJ)$(EXESUFFIX)
	$(INSTALL) $(PROJ)$(EXESUFFIX) $(PREFIX)/bin/$(PROJ)$(EXESUFFIX)

-include $(DEPENDS)
