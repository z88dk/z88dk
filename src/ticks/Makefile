
OBJS = ticks.o hook_console.o hook_io.o hook_misc.o hook.o disassembler.o debugger.o linenoise.o utf8.o

INSTALL ?= install

all: ticks$(EXESUFFIX)

ticks$(EXESUFFIX):	$(OBJS)
	$(CC) -o ticks$(EXESUFFIX) $(CFLAGS) $(OBJS)

install:
	$(INSTALL) ticks$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)ticks$(EXESUFFIX)

clean:
	$(RM) ticks$(EXESUFFIX) $(OBJS) core
	$(RM) -rf Debug Release


