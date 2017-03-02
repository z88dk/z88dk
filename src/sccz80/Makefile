#
# Makefile for sccz80
#
# $Id: Makefile,v 1.17 2016-07-10 16:09:00 dom Exp $
#

INSTALL ?= install

OBJS =	callfunc.o     	\
	codegen.o	\
	const.o		\
	data.o		\
	declfunc.o	\
	declinit.o	\
	declvar.o	\
	error.o		\
	expr.o		\
	goto.o		\
	io.o		\
	lex.o		\
	main.o		\
	misc.o		\
	plunge.o	\
	preproc.o	\
	primary.o	\
	stmt.o		\
	sym.o		\
	while.o

all: sccz80$(EXESUFFIX)

CFLAGS +=  -Wall -g

sccz80$(EXESUFFIX): $(OBJS)
	$(CC) $(LDFLAGS) -o sccz80$(EXESUFFIX) $(OBJS) -lm

install:
	$(INSTALL) -m 755 sccz80$(EXESUFFIX) $(PREFIX)/bin/

clean :
	$(RM) *.o *~ core sccz80$(EXESUFFIX)
	$(RM) -rf Debug Release

# Dependencies (gcc -MM)
callfunc.o: callfunc.c ccdefs.h define.h codegen.h \
  const.h data.h declvar.h declfunc.h declinit.h error.h expr.h  \
  io.h lex.h main.h misc.h preproc.h primary.h stmt.h sym.h \
  while.h
codegen.o: codegen.c ccdefs.h define.h codegen.h \
  const.h data.h declvar.h declfunc.h declinit.h error.h expr.h   \
  io.h lex.h main.h misc.h preproc.h primary.h stmt.h sym.h \
  while.h
const.o: const.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
data.o: data.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
declfunc.o: declfunc.c ccdefs.h define.h codegen.h \
  const.h data.h declvar.h declfunc.h declinit.h error.h expr.h   \
  io.h lex.h main.h misc.h preproc.h primary.h stmt.h sym.h \
  while.h
declinit.o: declinit.c ccdefs.h define.h codegen.h \
  const.h data.h declvar.h declfunc.h declinit.h error.h expr.h   \
  io.h lex.h main.h misc.h preproc.h primary.h stmt.h sym.h \
  while.h
declvar.o: declvar.c ccdefs.h define.h codegen.h \
  const.h data.h declvar.h declfunc.h declinit.h error.h expr.h   \
  io.h lex.h main.h misc.h preproc.h primary.h stmt.h sym.h \
  while.h
error.o: error.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
expr.o: expr.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
goto.o: goto.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
io.o: io.c ccdefs.h define.h codegen.h const.h data.h \
  declvar.h declfunc.h declinit.h error.h expr.h io.h lex.h \
  main.h misc.h preproc.h primary.h stmt.h sym.h while.h
lex.o: lex.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
main.o: main.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
misc.o: misc.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
plunge.o: plunge.c ccdefs.h define.h codegen.h \
  const.h data.h declvar.h declfunc.h declinit.h error.h expr.h   \
  io.h lex.h main.h misc.h preproc.h primary.h stmt.h sym.h \
  while.h
preproc.o: preproc.c ccdefs.h define.h codegen.h \
  const.h data.h declvar.h declfunc.h declinit.h error.h expr.h   \
  io.h lex.h main.h misc.h preproc.h primary.h stmt.h sym.h \
  while.h
primary.o: primary.c ccdefs.h define.h codegen.h \
  const.h data.h declvar.h declfunc.h declinit.h error.h expr.h   \
  io.h lex.h main.h misc.h preproc.h primary.h stmt.h sym.h \
  while.h
stmt.o: stmt.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
sym.o: sym.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
while.o: while.c ccdefs.h define.h codegen.h const.h \
  data.h declvar.h declfunc.h declinit.h error.h expr.h io.h \
  lex.h main.h misc.h preproc.h primary.h stmt.h sym.h while.h
