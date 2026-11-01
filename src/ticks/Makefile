include ../Make.common

.DEFAULT_GOAL := all

LUA_SRC = ../../ext/lua
LUA_OBJS = lua_lapi.o lua_lcode.o lua_lctype.o lua_ldebug.o lua_ldo.o lua_ldump.o \
	lua_lfunc.o lua_lgc.o lua_llex.o lua_lmem.o lua_lobject.o lua_lopcodes.o \
	lua_lparser.o lua_lstate.o lua_lstring.o lua_ltable.o lua_ltm.o lua_lundump.o \
	lua_lvm.o lua_lzio.o lua_lauxlib.o lua_lbaselib.o lua_lcorolib.o lua_ldblib.o \
	lua_liolib.o lua_lmathlib.o lua_loslib.o lua_lstrlib.o lua_ltablib.o \
	lua_lutf8lib.o lua_loadlib.o lua_linit.o
OBJS = ticks.o rxk_inst.o r4k_inst.o i8085_inst.o vm1_inst.o z80n_inst.o gbz80_inst.o \
	r800_inst.o z180_inst.o zilog_inst.o ez80_inst.o kc160_inst.o cpu.o backend.o \
	hook_cpm.o hook_console.o hook_io.o hook_misc.o hook.o debugger.o breakpoints.o \
	profiler.o exp_engine.o debugger_ticks.o linenoise.o utf8.o syms.o ticks_lua.o \
	disassembler_alg.o memory.o am9511.o acia.o hook_rc2014.o debug.o srcfile.o \
	i8255.o ticks_main.o $(LUA_OBJS) \
	../common/dirname.o $(UNIXem_OBJS)
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
CFLAGS += -I../../ext/uthash/src/ -I$(LUA_SRC) -g -MMD $(UNIXem_CFLAGS)

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

$(LUA_OBJS): lua_%.o: $(LUA_SRC)/%.c
	$(CC) $(CFLAGS) -I$(LUA_SRC) -c -o $@ $<

clean:
	$(RM) z88dk-ticks$(EXESUFFIX) $(OBJS) core
	$(RM) $(LUA_OBJS)
	$(RM) z88dk-dis$(EXESUFFIX) $(DISOBJS) core
	$(RM) z88dk-gdb$(EXESUFFIX) $(GDBOBJS) core
	$(RM) $(LEXOBJS)
	$(RM) $(DEPENDS)
	$(RM) expressions.output
	$(RM) -rf Debug Release

-include $(DEPENDS)
