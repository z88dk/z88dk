#-----------------------------------------------------------------------------
# appmake - Z88dk application creator
#-----------------------------------------------------------------------------
PROJ		:= appmake

ifeq ($(OS),Windows_NT)
  EXE	:= .exe
else
  EXE 	:= $(EXESUFFIX)
endif

CC			?= gcc
CFLAGS		+= -Wall -std=gnu11 -MMD 

INSTALL 	?= install

SRCS 		:= $(wildcard *.c)

OBJS_ALL	:= $(SRCS:.c=.o)
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
install: $(PROJ)$(EXE)
	$(INSTALL) $(PROJ)$(EXE) $(PREFIX)/bin/$(PROJ)$(EXE)

-include $(DEPENDS)
