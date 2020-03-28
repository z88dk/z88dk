#-----------------------------------------------------------------------------
# zcpp - C89 preprocessor for sccz80 (unused)
#-----------------------------------------------------------------------------
PROJ		:= z88dk-zcpp

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

CC			?= gcc
CFLAGS		+= -Wall -std=gnu11 -MMD \
-I../../ext/optparse \
-I../../ext/regex \

INSTALL 	?= install

SRCS 		:= $(wildcard *.c)

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
test:: $(PROJ)$(EXESUFFIX)
	perl -S prove t/*.t

#------------------------------------------------------------------------------
clean::
	$(RM) $(OBJS) $(DEPENDS) *.bak t/*.bak

#------------------------------------------------------------------------------
install: $(PROJ)$(EXESUFFIX)
	$(INSTALL) $(PROJ)$(EXESUFFIX) $(PREFIX)/bin/$(PROJ)$(EXESUFFIX)

-include $(DEPENDS)
