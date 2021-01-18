
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

include ../Make.common

OBJS = ticks.o hook_cpm.o hook_console.o hook_io.o hook_misc.o hook.o debugger.o linenoise.o utf8.o syms.o disassembler_alg.o memory.o am9511.o acia.o hook_rc2014.o debug.o srcfile.o $(UNIXem_OBJS)


DISOBJS = disassembler_main.o  syms.o disassembler_alg.o debug.o

DEPENDS         := $(OBJS:.o=.d) $(DISOBJS:.o=.d)

INSTALL ?= install

CFLAGS += -I../../ext/uthash/src/ -g -MMD $(UNIXem_CFLAGS)
LDFLAGS = -lm

all: z88dk-ticks$(EXESUFFIX) z88dk-dis$(EXESUFFIX)

z88dk-ticks$(EXESUFFIX):	$(OBJS)
	$(CC) -o $@ $(CFLAGS) $(OBJS) $(LDFLAGS)

z88dk-dis$(EXESUFFIX):	$(DISOBJS)
	$(CC) -o $@ $(CFLAGS) $(DISOBJS)

install: z88dk-ticks$(EXESUFFIX) z88dk-dis$(EXESUFFIX)
	$(INSTALL) z88dk-ticks$(EXESUFFIX) $(PREFIX)/bin/z88dk-ticks$(EXESUFFIX)
	$(INSTALL) z88dk-dis$(EXESUFFIX) $(PREFIX)/bin/z88dk-dis$(EXESUFFIX)

clean:
	$(RM) z88dk-ticks$(EXESUFFIX) $(OBJS) core
	$(RM) z88dk-dis$(EXESUFFIX) $(DISOBJS) core
	$(RM) $(DEPENDS)
	$(RM) -rf Debug Release

-include $(DEPENDS)
