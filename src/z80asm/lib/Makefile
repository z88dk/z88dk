#------------------------------------------------------------------------------
# Z88DK Z80 Module Assembler
#
# Collection of C library functions to be used in my C projects.
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#------------------------------------------------------------------------------

TARGET	= libclibrary.a

CC		= gcc
CFLAGS	+= -g -Wall -Wextra -MMD -I. -I../../common -I../../../ext/uthash/src $(OPTFLAGS)
LDLIBS	+= $(OPTLIBS) $(TARGET)
PREFIX  ?= /usr/local

INSTALL ?= install

SOURCES	= $(wildcard *.c) ../../common/die.c ../../common/fileutil.c ../../common/strutil.c
OBJECTS	= $(patsubst %.c,%.o,$(SOURCES))
DEPENDS = $(patsubst %.c,%.d,$(SOURCES))

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
		-rm -f $(DEPENDS)

# The Install
install: all
		$(INSTALL)        -d $(DESTDIR)/$(PREFIX)/lib/
		$(INSTALL) $(TARGET) $(DESTDIR)/$(PREFIX)/lib/

# The Checker
BADFUNCS='[^_.>a-zA-Z0-9](str(n?cpy|n?cat|xfrm|n?dup|str|pbrk|tok|_)|stpn?cpy|a?sn?printf|byte_)'
check:
		@echo Files with potentially dangerous functions.
		@egrep $(BADFUNCS) $(SOURCES) || true

-include $(DEPENDS)
