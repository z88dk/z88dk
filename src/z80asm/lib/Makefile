# Z88DK Z80 Macro Assembler
#
# Collection of C library functions to be used in my C projects.
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm

TARGET	= libclibrary.a

CC		= gcc
CFLAGS	+= -g -Wall -Wextra -I. $(OPTFLAGS)
LDLIBS	+= $(OPTLIBS) $(TARGET)
PREFIX  ?= /usr/local

INSTALL ?= install

SOURCES	= $(wildcard *.c)
OBJECTS	= $(patsubst %.c,%.o,$(SOURCES))

TEST_SRC= $(wildcard t/test_*.c) $(wildcard t/uthash/test*.c)
TESTS	= $(patsubst %.c,%,$(TEST_SRC))

# The Target Build
all: $(TARGET)

# The Test Build
test: tests
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

alloc.o: alloc.h dbg.h types.h init.h utlist.h
array.o: array.h class.h alloc.h dbg.h types.h queue.h
class.o: alloc.h dbg.h types.h class.h queue.h init.h strpool.h
dbg.o: dbg.h
fileutil.o: alloc.h dbg.h types.h fileutil.h list.h class.h queue.h utarray.h
fileutil.o: strpool.h uthash.h
list.o: alloc.h dbg.h types.h list.h class.h queue.h
minunit.o: minunit.h dbg.h
srcfile.o: alloc.h dbg.h types.h srcfile.h class.h queue.h list.h utarray.h
srcfile.o: fileutil.h strpool.h
str.o: str.h alloc.h dbg.h types.h
strpool.o: alloc.h dbg.h types.h init.h strpool.h uthash.h
t/test_alloc.o: minunit.h dbg.h alloc.h types.h
t/test_dbg.o: minunit.h dbg.h
t/test_init.o: minunit.h dbg.h init.h types.h
t/test_str.o: minunit.h dbg.h str.h alloc.h types.h
t/test_strpool.o: minunit.h dbg.h strpool.h
t/test_types.o: minunit.h dbg.h types.h
t/uthash/test1.o: uthash.h dbg.h alloc.h types.h
t/uthash/test10.o: uthash.h dbg.h alloc.h types.h
t/uthash/test11.o: uthash.h dbg.h alloc.h types.h
t/uthash/test12.o: uthash.h dbg.h alloc.h types.h
t/uthash/test13.o: uthash.h dbg.h alloc.h types.h
t/uthash/test14.o: uthash.h dbg.h alloc.h types.h
t/uthash/test15.o: uthash.h dbg.h alloc.h types.h
t/uthash/test16.o: uthash.h dbg.h alloc.h types.h
t/uthash/test17.o: uthash.h dbg.h alloc.h types.h
t/uthash/test18.o: uthash.h dbg.h alloc.h types.h
t/uthash/test19.o: uthash.h dbg.h alloc.h types.h
t/uthash/test2.o: uthash.h dbg.h alloc.h types.h
t/uthash/test20.o: uthash.h dbg.h alloc.h types.h
t/uthash/test21.o: uthash.h dbg.h alloc.h types.h
t/uthash/test22.o: uthash.h dbg.h alloc.h types.h
t/uthash/test23.o: uthash.h dbg.h alloc.h types.h
t/uthash/test24.o: uthash.h dbg.h alloc.h types.h
t/uthash/test25.o: utlist.h
t/uthash/test26.o: utlist.h
t/uthash/test27.o: utlist.h
t/uthash/test28.o: utlist.h
t/uthash/test29.o: utlist.h
t/uthash/test3.o: uthash.h dbg.h alloc.h types.h
t/uthash/test30.o: utlist.h
t/uthash/test31.o: utlist.h
t/uthash/test32.o: utlist.h
t/uthash/test33.o: utlist.h
t/uthash/test34.o: utlist.h
t/uthash/test35.o: uthash.h dbg.h alloc.h types.h
t/uthash/test36.o: uthash.h dbg.h alloc.h types.h
t/uthash/test37.o: uthash.h dbg.h alloc.h types.h
t/uthash/test38.o: uthash.h dbg.h alloc.h types.h
t/uthash/test39.o: uthash.h dbg.h alloc.h types.h
t/uthash/test4.o: uthash.h dbg.h alloc.h types.h
t/uthash/test40.o: uthash.h dbg.h alloc.h types.h
t/uthash/test41.o: utlist.h
t/uthash/test42.o: utlist.h
t/uthash/test43.o: utarray.h dbg.h alloc.h types.h
t/uthash/test44.o: utarray.h dbg.h alloc.h types.h
t/uthash/test45.o: utarray.h dbg.h alloc.h types.h
t/uthash/test46.o: utarray.h dbg.h alloc.h types.h
t/uthash/test48.o: utarray.h dbg.h alloc.h types.h
t/uthash/test49.o: utarray.h dbg.h alloc.h types.h
t/uthash/test5.o: uthash.h dbg.h alloc.h types.h
t/uthash/test50.o: utarray.h dbg.h alloc.h types.h
t/uthash/test51.o: utarray.h dbg.h alloc.h types.h
t/uthash/test52.o: utarray.h dbg.h alloc.h types.h
t/uthash/test57.o: uthash.h dbg.h alloc.h types.h
t/uthash/test58.o: uthash.h dbg.h alloc.h types.h
t/uthash/test59.o: uthash.h dbg.h alloc.h types.h
t/uthash/test6.o: uthash.h dbg.h alloc.h types.h
t/uthash/test60.o: uthash.h dbg.h alloc.h types.h
t/uthash/test61.o: utarray.h dbg.h alloc.h types.h
t/uthash/test62.o: uthash.h dbg.h alloc.h types.h
t/uthash/test63.o: utlist.h
t/uthash/test64.o: utlist.h
t/uthash/test65.o: uthash.h dbg.h alloc.h types.h
t/uthash/test66.o: uthash.h dbg.h alloc.h types.h
t/uthash/test67.o: utarray.h dbg.h alloc.h types.h
t/uthash/test68.o: utlist.h
t/uthash/test69.o: utlist.h
t/uthash/test7.o: uthash.h dbg.h alloc.h types.h
t/uthash/test70.o: utlist.h
t/uthash/test71.o: utlist.h
t/uthash/test72.o: utlist.h
t/uthash/test73.o: utlist.h
t/uthash/test78.o: utlist.h
t/uthash/test79.o: uthash.h dbg.h alloc.h types.h
t/uthash/test8.o: uthash.h dbg.h alloc.h types.h
t/uthash/test80.o: utarray.h dbg.h alloc.h types.h
t/uthash/test81.o: utarray.h dbg.h alloc.h types.h
t/uthash/test82.o: utarray.h dbg.h alloc.h types.h
t/uthash/test83.o: uthash.h dbg.h alloc.h types.h
t/uthash/test84.o: uthash.h dbg.h alloc.h types.h
t/uthash/test9.o: uthash.h dbg.h alloc.h types.h
