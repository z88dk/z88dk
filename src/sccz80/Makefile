#
# Makefile for sccz80
#
# Hacked together out of one I found elsewhere (I hate writing
# makefiles - they never work for me!)
#
# These needs gnu make!!!
#

CC=gcc
CFLAGS = -g -O2 -DUSEFRAME -Wall
LDFLAGS=

OBJS =	callfunc.o     	\
	codegen.o	\
	const.o		\
	data.o		\
	declfunc.o	\
	declinit.o	\
	declvar.o	\
	error.o		\
	expr.o		\
	float.o		\
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

EXECS = scc


.PHONY: all
ifeq (.depend,$(wildcard .depend))
all : $(EXECS)
include .depend
else
all:	depend
	@echo
	@echo Just say make again...
	@echo
endif


scc : $(OBJS)
	$(CC) $(LDFLAGS) -o ../../bin/sccz80 $(CFLAGS) $(OBJS)


clean :
	rm -f *.o *~ core $(EXECS) *.map

# ------------------------------------------------------------------------------
# Make the dependencies

.PHONY: depend dep
depend dep:	$(OBJS:.o=.c)
	@echo "Creating dependency information"
	$(CC) -MM $^ > .depend


