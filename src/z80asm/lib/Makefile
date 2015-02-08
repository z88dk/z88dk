# Collection of C library functions to be used in my C projects.
#
# Copyright (C) Paulo Custodio, 2011-2015
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Makefile,v 1.3 2015-02-08 23:52:31 pauloscustodio Exp $

TARGET	= libclibrary.a

CFLAGS	+= -g -Wall -Wextra -I. $(OPTFLAGS)
LDLIBS	+= $(OPTLIBS) $(TARGET)
PREFIX  ?= /usr/local

INSTALL ?= install

SOURCES	= $(wildcard *.c)
OBJECTS	= $(patsubst %.c,%.o,$(SOURCES))

TEST_SRC1= $(wildcard t/test_*.c) $(wildcard t/uthash/test*.c)
TEST_SRC = $(TEST_SRC1:t/test_xmalloc.c=)
TESTS	= $(patsubst %.c,%,$(TEST_SRC))

# The Target Build
all: $(TARGET) tests
	perl -S prove t/*.t

release:
	$(MAKE) clean
	$(MAKE) OPTFLAGS="-DNDEBUG -O2" all

$(TARGET): $(OBJECTS)
		ar rcs $@ $(OBJECTS)
		ranlib $@

$(TESTS): $(TARGET)

# The Unit Tests
.PHONY: tests

tests: $(TESTS)
		sh ./t/runtests.sh

# The Cleaner
clean:
		-rm -f $(OBJECTS) $(TESTS) $(TARGET)
		-rm -f $(patsubst %,%.exe,$(TESTS))
		-rm -f $(patsubst %,%.out,$(TESTS))
		-rm -f $(patsubst %,%.o,$(TESTS))
		-rm -f t/tests.log
		-rm -f *.bak
		-rm -rf win32/Debug win32/Release win32/ipch

# The Install
install: all
		$(INSTALL)        -d $(DESTDIR)/$(PREFIX)/lib/
		$(INSTALL) $(TARGET) $(DESTDIR)/$(PREFIX)/lib/

# The Checker
BADFUNCS='[^_.>a-zA-Z0-9](str(n?cpy|n?cat|xfrm|n?dup|str|pbrk|tok|_)|stpn?cpy|a?sn?printf|byte_)'
check:
		@echo Files with potentially dangerous functions.
		@egrep $(BADFUNCS) $(SOURCES) || true

depend:
		makedepend -Y -I. $(SOURCES) $(TEST_SRC)

# DO NOT DELETE

array.o: xmalloc.h array.h class.h queue.h types.h strutil.h
class.o: xmalloc.h class.h queue.h types.h init.h dbg.h strpool.h
dbg.o: dbg.h
dlist.o: xmalloc.h dlist.h
fileutil.o: xmalloc.h fileutil.h list.h class.h queue.h types.h strutil.h
fileutil.o: utarray.h dbg.h strpool.h uthash.h
list.o: xmalloc.h list.h class.h queue.h types.h
minunit.o: minunit.h dbg.h
srcfile.o: xmalloc.h srcfile.h class.h queue.h types.h list.h strutil.h
srcfile.o: utarray.h dbg.h fileutil.h strpool.h
strhash.o: xmalloc.h strhash.h types.h class.h queue.h uthash.h dbg.h
strhash.o: strpool.h strutil.h
strpool.o: xmalloc.h init.h types.h dbg.h queue.h strpool.h uthash.h
strutil.o: xmalloc.h strpool.h strutil.h class.h queue.h types.h
xmalloc.o: xmalloc.h dlist.h init.h types.h dbg.h
t/test_dbg.o: minunit.h dbg.h
t/test_dlist.o: xmalloc.h dbg.h dlist.h
t/test_init.o: xmalloc.h init.h types.h dbg.h
t/test_xmalloc.o: xmalloc.h dbg.h
