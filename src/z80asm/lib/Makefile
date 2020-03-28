#------------------------------------------------------------------------------
# Z88DK Z80 Module Assembler
#
# Collection of C library functions to be used in my C projects.
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

TARGET		= libclibrary.a

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

# UNIXem is needed in both Windows_NT and in a MinGW build in Unix
ifeq ($(EXESUFFIX),.exe)
  UNIXem_CFLAGS	:= -I../../../ext/UNIXem/include
  UNIXem_OBJS	:=   ../../../ext/UNIXem/src/glob.o \
				     ../../../ext/UNIXem/src/dirent.o
endif

CC		= gcc
CFLAGS		+= -g -Wall -Wextra -MMD -I. -I../../common -I../../../ext/uthash/src \
		   $(UNIXem_CFLAGS) \
		   $(OPTFLAGS)
LDLIBS		+= $(OPTLIBS) $(TARGET)
PREFIX  	?= /usr/local

INSTALL 	?= install

SOURCES		= $(wildcard *.c) ../../common/die.c ../../common/fileutil.c ../../common/strutil.c
OBJECTS		= $(patsubst %.c,%.o,$(SOURCES))
DEPENDS 	= $(patsubst %.c,%.d,$(SOURCES))

TEST_SRC	= $(wildcard t/test_*.c) $(wildcard t/uthash/test*.c)
TESTS		= $(patsubst %.c,%,$(TEST_SRC))

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
	$(RM) $(OBJECTS) $(TESTS) $(TARGET)
	$(RM) $(patsubst %,%.exe,$(TESTS))
	$(RM) $(patsubst %,%.out,$(TESTS))
	$(RM) $(patsubst %,%.o,$(TESTS))
	$(RM) t/tests.log
	$(RM) *.bak
	$(RM) -r win32/Debug win32/Release win32/ipch
	$(RM) $(DEPENDS)

# The Install
install: all
	$(INSTALL)        -d $(DESTDIR)/$(PREFIX)/lib/
	$(INSTALL) $(TARGET) $(DESTDIR)/$(PREFIX)/lib/

-include $(DEPENDS)
