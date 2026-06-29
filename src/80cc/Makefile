#
# Makefile for 80cc
#
# $Id: Makefile,v 1.17 2016-07-10 16:09:00 dom Exp $
#

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

INSTALL ?= install

OBJS =	callfunc.o     	\
	cdbfile.o     	\
	codegen.o	\
	const.o		\
	data.o		\
	declinit.o	\
	error.o		\
	expr.o		\
	goto.o		\
	io.o		\
	lex.o		\
	main.o		\
	misc.o		\
	plunge.o	\
	preproc.o	\
	cpp_invoke.o	\
	primary.o	\
	stmt.o		\
	sym.o		\
	while.o 	\
	declparse.o	\
	../common/option.o \
	node.o		\
	ast_codegen2.o  \
	ast_opt.o	\
	ast_iter.o	\
	ir.o		\
	ir_lower.o	\
	ir_build.o	\
	ir_analysis.o	\
	ir_alloc.o	\
	ir_opt.o	\
	ir_compiler_glue.o \
	tokeniser.o

DEPENDS := $(OBJS:.o=.d)

all: z88dk-80cc$(EXESUFFIX)

CFLAGS += -MMD -Wall -I../common -I../../ext/uthash/src/ -g -pedantic -std=gnu11

z88dk-80cc$(EXESUFFIX): $(OBJS)
	$(CC) $(LDFLAGS) -o z88dk-80cc$(EXESUFFIX) $(OBJS) -lm

install: z88dk-80cc$(EXESUFFIX)
	$(INSTALL) -m 755 z88dk-80cc$(EXESUFFIX) $(PREFIX)/bin/z88dk-80cc$(EXESUFFIX)

clean :
	$(RM) *.o *~ core z88dk-80cc$(EXESUFFIX)
	$(RM) -rf Debug Release
	$(RM) $(DEPENDS)


-include $(DEPENDS)
