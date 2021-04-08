#-----------------------------------------------------------------------------
# appmake - Z88dk application creator
#-----------------------------------------------------------------------------
PROJ		:= z88dk-appmake

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

CC			?= gcc
CFLAGS		+= -Wall -std=gnu11 -MMD -pedantic -I../common

INSTALL 	?= install

SRCS 		:= $(wildcard *.c) ../common/dirname.c

OBJS_ALL	:= $(SRCS:.c=.o)
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
clean::
	$(RM) $(OBJS) $(DEPENDS) 

#------------------------------------------------------------------------------
install: $(PROJ)$(EXESUFFIX)
	$(INSTALL) $(PROJ)$(EXESUFFIX) $(PREFIX)/bin/$(PROJ)$(EXESUFFIX)

-include $(DEPENDS)
