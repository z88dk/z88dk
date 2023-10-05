include ../Make.common

OBJS = ticks.o rxk_inst.o r4k_inst.o i8085_inst.o z80n_inst.o gbz80_inst.o r800_inst.o z180_inst.o zilog_inst.o ez80_inst.o kc160_inst.o cpu.o backend.o hook_cpm.o hook_console.o hook_io.o hook_misc.o hook.o debugger.o breakpoints.o profiler.o exp_engine.o debugger_ticks.o linenoise.o utf8.o syms.o disassembler_alg.o memory.o am9511.o acia.o hook_rc2014.o debug.o srcfile.o ../common/dirname.o $(UNIXem_OBJS)
GDBOBJS = cpu.o backend.o syms.o disassembler_alg.o debug.o exp_engine.o debugger.o breakpoints.o profiler.o debugger_gdb.o debugger_mi2.o debugger_gdb_packets.o linenoise.o srcfile.o ../common/dirname.o sxmlc.o sxmlsearch.o $(UNIXem_OBJS)
DISOBJS = disassembler_main.o syms.o disassembler_alg.o debug.o exp_engine.o backend.o
LEXOBJS = lex.yy.o expressions.tab.o

DEPENDS         := $(OBJS:.o=.d) $(DISOBJS:.o=.d) $(GDBOBJS:.o=.d)

INSTALL ?= install

LEX     = flex
YACC    = bison -y
YFLAGS  = -d
ifneq ($(findstring m68k-atari-mint,$(CC)),)
  HAVE_PTHREAD=0
else
 HAVE_PTHREAD=1
 GDBLDFLAGS = -lpthread
endif
CFLAGS += -I../../ext/uthash/src/ -g -MMD $(UNIXem_CFLAGS)
LDFLAGS = -lm


ifeq ($(EXESUFFIX),.exe)
  GDBLDFLAGS += -lws2_32
endif


PROGRAMS = z88dk-ticks$(EXESUFFIX) z88dk-dis$(EXESUFFIX)
ifeq ($(HAVE_PTHREAD),1)
    PROGRAMS += z88dk-gdb$(EXESUFFIX)
endif

all: $(PROGRAMS)

z88dk-ticks$(EXESUFFIX):	$(OBJS) $(LEXOBJS)
	$(CC) -o $@ $(CFLAGS) $(OBJS) $(LEXOBJS) $(LDFLAGS) $(GDBLDFLAGS)

z88dk-gdb$(EXESUFFIX):	$(GDBOBJS) $(LEXOBJS)
	$(CC) -o $@ $(CFLAGS) $(GDBOBJS) $(LEXOBJS) $(LDFLAGS) $(GDBLDFLAGS)

z88dk-dis$(EXESUFFIX):	$(DISOBJS)
	$(CC) -o $@ $(CFLAGS) $(DISOBJS)

install: $(PROGRAMS)
	$(INSTALL) z88dk-ticks$(EXESUFFIX) $(PREFIX)/bin/z88dk-ticks$(EXESUFFIX)
	$(INSTALL) z88dk-dis$(EXESUFFIX) $(PREFIX)/bin/z88dk-dis$(EXESUFFIX)
ifeq ($(HAVE_PTHREAD),1)
	$(INSTALL) z88dk-gdb$(EXESUFFIX) $(PREFIX)/bin/z88dk-gdb$(EXESUFFIX)
endif

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
