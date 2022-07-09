#-----------------------------------------------------------------------------
# zobjcopy - manipulate z80asm object files
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------
PROJ		:= z88dk-zobjcopy

include ../Make.common

CC			?= gcc
CFLAGS		+= -Wall -std=gnu11 -MMD \
			-I../common \
			-I../../ext/uthash/src \
			-I../../ext/optparse \
			-I../../ext/regex  \
			$(UNIXem_CFLAGS)

INSTALL 	?= install

SRCS 		:= $(wildcard *.c) \
$(wildcard ../common/*.c) \
$(wildcard ../../ext/regex/reg*.c)

OBJS_ALL	:= $(SRCS:.c=.o) \
			$(UNIXem_OBJS)

OBJS		:= $(OBJS_ALL:$(PROJ).o=)

DEPENDS		:= $(SRCS:.c=.d) $(T_SRCS:.c=.d)

#------------------------------------------------------------------------------
.PHONY: all clean test install

#------------------------------------------------------------------------------
define MAKE_EXE
all: $(1)$(EXESUFFIX)

$(1)$(EXESUFFIX): $(2)
	$(CC) $(CFLAGS) -o $(1)$(EXESUFFIX) $(2) $(LDFLAGS)
	
clean::
	$(RM) $(1)$(EXESUFFIX) $(2)

test:: $(1)$(EXESUFFIX)
ifeq ($(3),1)
	./$(1)$(EXESUFFIX)
endif

valgrind:: $(1)$(EXESUFFIX)
	$(VALGRIND) $(1)$(EXESUFFIX)
endef

#------------------------------------------------------------------------------
$(eval $(call MAKE_EXE,$(PROJ),$(OBJS_ALL),0))

#------------------------------------------------------------------------------
test:: $(PROJ)$(EXESUFFIX)
	perl -S prove t/*.t

#------------------------------------------------------------------------------
clean::
	$(RM) $(OBJS) $(DEPENDS) *.bak t/*.bak

#------------------------------------------------------------------------------
install: $(PROJ)$(EXESUFFIX)
	$(INSTALL) $(PROJ)$(EXESUFFIX) $(PREFIX)/bin/$(PROJ)$(EXESUFFIX)

-include $(DEPENDS)
