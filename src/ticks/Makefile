
OBJS = ticks.o hook_console.o hook_io.o hook_misc.o hook.o disassembler.o debugger.o linenoise.o utf8.o syms.o

DISOBJS = disassembler_main.o disassembler.o syms.o

INSTALL ?= install

all: ticks$(EXESUFFIX) z88dk-dis$(EXESUFFIX)

ticks$(EXESUFFIX):	$(OBJS)
	$(CC) -o ticks$(EXESUFFIX) $(CFLAGS) $(OBJS)

z88dk-dis$(EXESUFFIX):	$(DISOBJS)
	$(CC) -o z88dk-dis$(EXESUFFIX) $(CFLAGS) $(DISOBJS)

install:
	$(INSTALL) ticks$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)ticks$(EXESUFFIX)
	$(INSTALL) z88dk-dis$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)z88dk-dis$(EXESUFFIX)

clean:
	$(RM) ticks$(EXESUFFIX) $(OBJS) core
	$(RM) z88dk-dis$(EXESUFFIX) $(DISOBJS) core
	$(RM) -rf Debug Release


