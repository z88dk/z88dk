#-----------------------------------------------------------------------------
# zobjcopy - manipulate z80asm object files
# Copyright (C) Paulo Custodio, 2011-2018
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------
PROJ		:= zobjcopy

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
all: $(1)$(EXE)

$(1)$(EXE): $(2)
	$(CC) $(CFLAGS) -o $(1)$(EXE) $(2) $(LDFLAGS)
	
clean::
	$(RM) $(1)$(EXE) $(2)

test:: $(1)$(EXE)
ifeq ($(3),1)
	./$(1)$(EXE)
endif

valgrind:: $(1)$(EXE)
	$(VALGRIND) $(1)$(EXE)
endef

#------------------------------------------------------------------------------
$(eval $(call MAKE_EXE,$(PROJ),$(OBJS_ALL),0))

#------------------------------------------------------------------------------
test:: $(PROJ)$(EXE)
	perl -S prove t/*.t

#------------------------------------------------------------------------------
clean::
	$(RM) $(OBJS) $(DEPENDS) *.bak t/*.bak

#------------------------------------------------------------------------------
install: $(PROJ)$(EXESUFFIX)
	$(INSTALL) $(PROJ)$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)$(PROJ)$(EXESUFFIX)

-include $(DEPENDS)
