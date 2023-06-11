include ../Make.common

OBJS = ticks.o cpu.o backend.o hook_cpm.o hook_console.o hook_io.o hook_misc.o hook.o debugger.o breakpoints.o profiler.o exp_engine.o debugger_ticks.o linenoise.o utf8.o syms.o disassembler_alg.o memory.o am9511.o acia.o hook_rc2014.o debug.o srcfile.o ../common/dirname.o $(UNIXem_OBJS)
GDBOBJS = cpu.o backend.o syms.o disassembler_alg.o debug.o exp_engine.o debugger.o breakpoints.o profiler.o debugger_gdb.o debugger_mi2.o debugger_gdb_packets.o linenoise.o srcfile.o ../common/dirname.o sxmlc.o sxmlsearch.o $(UNIXem_OBJS)
DISOBJS = disassembler_main.o syms.o disassembler_alg.o debug.o exp_engine.o backend.o
LEXOBJS = lex.yy.o expressions.tab.o

DEPENDS         := $(OBJS:.o=.d) $(DISOBJS:.o=.d) $(GDBOBJS:.o=.d)

INSTALL ?= install

LEX     = flex
YACC    = bison -y
YFLAGS  = -d
GDBLDFLAGS = -lpthread
CFLAGS += -I../../ext/uthash/src/ -g -MMD $(UNIXem_CFLAGS)
LDFLAGS = -lm


ifeq ($(EXESUFFIX),.exe)
  GDBLDFLAGS += -lws2_32
endif

all: z88dk-ticks$(EXESUFFIX) z88dk-dis$(EXESUFFIX) z88dk-gdb$(EXESUFFIX)

z88dk-ticks$(EXESUFFIX):	$(OBJS) $(LEXOBJS)
	$(CC) -o $@ $(CFLAGS) $(OBJS) $(LEXOBJS) $(LDFLAGS) $(GDBLDFLAGS)

z88dk-gdb$(EXESUFFIX):	$(GDBOBJS) $(LEXOBJS)
	$(CC) -o $@ $(CFLAGS) $(GDBOBJS) $(LEXOBJS) $(LDFLAGS) $(GDBLDFLAGS)

z88dk-dis$(EXESUFFIX):	$(DISOBJS)
	$(CC) -o $@ $(CFLAGS) $(DISOBJS)

install: z88dk-ticks$(EXESUFFIX) z88dk-dis$(EXESUFFIX) z88dk-gdb$(EXESUFFIX)
	$(INSTALL) z88dk-ticks$(EXESUFFIX) $(PREFIX)/bin/z88dk-ticks$(EXESUFFIX)
	$(INSTALL) z88dk-dis$(EXESUFFIX) $(PREFIX)/bin/z88dk-dis$(EXESUFFIX)
	$(INSTALL) z88dk-gdb$(EXESUFFIX) $(PREFIX)/bin/z88dk-gdb$(EXESUFFIX)

expressions.tab.c expressions.tab.h: expressions.y
	bison -t -v -d expressions.y

lex.yy.c: expressions.l expressions.tab.h
	flex expressions.l

clean:
	$(RM) z88dk-ticks$(EXESUFFIX) $(OBJS) core
	$(RM) z88dk-dis$(EXESUFFIX) $(DISOBJS) core
	$(RM) z88dk-gdb$(EXESUFFIX) $(GDBOBJS) core
	$(RM) $(LEXOBJS)
	$(RM) $(DEPENDS)
	$(RM) expressions.output
	$(RM) -rf Debug Release

-include $(DEPENDS)
