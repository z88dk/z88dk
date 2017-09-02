#
#
#	The impromptu compilation makefile for z88dk
#
#	$Id: Makefile,v 1.57 2016-09-09 09:06:07 dom Exp $
#

# ---> Configurable parameters are below his point

prefix = /usr/local
prefix_share = $(prefix)/share
git_rev = $(shell git rev-parse --short HEAD)
git_count = $(shell git rev-list --count HEAD)
version := $(shell date +%Y%m%d)

INSTALL ?= install
CFLAGS ?= -O2
CC ?= gcc
EXEC_PREFIX ?= 

# --> End of Configurable Options

export CC INSTALL CFLAGS EXEC_PREFIX

all: setup appmake copt zcpp sccz80 z80asm zcc zpragma zx7 z80nm ticks z80svg testsuite z88dk-install

setup:
	$(shell if [ "${git_count}" != "" ]; then \
	    echo '#define PREFIX "${prefix_share}$"/z88dk"' > src/config.h; \
	    echo '#define UNIX 1' >> src/config.h; \
	    echo '#define EXEC_PREFIX "${EXEC_PREFIX}"' >> src/config.h; \
	    echo '#define Z88DK_VERSION "${git_count}-${git_rev}-${version}"' >> src/config.h; \
	fi)
	$(shell if [ ! -f src/config.h ]; then \
	    echo '#define PREFIX "${prefix_share}$"/z88dk"' > src/config.h; \
	    echo '#define UNIX 1' >> src/config.h; \
	    echo '#define EXEC_PREFIX "${EXEC_PREFIX}"' >> src/config.h; \
	    echo '#define Z88DK_VERSION "unknown-unknown-${version}"' >> src/config.h; \
        fi)
	@mkdir -p bin


appmake:
	$(MAKE) -C src/appmake
	$(MAKE) -C src/appmake PREFIX=`pwd` install

copt:
	$(MAKE) -C src/copt
	$(MAKE) -C src/copt PREFIX=`pwd` install

zcpp:
	$(MAKE) -C src/cpp
	$(MAKE) -C src/cpp PREFIX=`pwd` install

sccz80:
	$(MAKE) -C src/sccz80
	$(MAKE) -C src/sccz80 PREFIX=`pwd` install

z80asm:
	$(MAKE) -C src/z80asm
	$(MAKE) -C src/z80asm PREFIX=`pwd` install

zcc:
	$(MAKE) -C src/zcc
	$(MAKE) -C src/zcc PREFIX=`pwd` install

zpragma:
	$(MAKE) -C src/zpragma
	$(MAKE) -C src/zpragma PREFIX=`pwd` install

zx7:
	$(MAKE) -C src/zx7
	$(MAKE) -C src/zx7 PREFIX=`pwd` install

z80nm:
	$(MAKE) -C src/z80nm
	$(MAKE) -C src/z80nm PREFIX=`pwd` install

z80svg:
	$(MAKE) -C support/graphics
	$(MAKE) -C support/graphics PREFIX=`pwd` install

ticks:
	$(MAKE) -C src/ticks
	$(MAKE) -C src/ticks PREFIX=`pwd` install

z88dk-install:
	$(MAKE) -C src/z88dk-install
	$(MAKE) -C src/z88dk-install PREFIX=`pwd` install


libs:
	cd libsrc ; $(MAKE)
	cd libsrc ; $(MAKE) install

install: install-clean
	cd src/appmake ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/copt ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/cpp ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/sccz80 ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/z80asm ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/zcc ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/zpragma ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/zx7 ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/z80nm ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/ticks ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/z88dk-install ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd support/graphics; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	find include -type d -exec $(INSTALL) -d -m 755 {,$(DESTDIR)/$(prefix_share)/z88dk/}{}  \;
	find include -type f -exec $(INSTALL) -m 664 {,$(DESTDIR)/$(prefix_share)/z88dk/}{}  \;
	find lib -type d -exec $(INSTALL) -d -m 755 {,$(DESTDIR)/$(prefix_share)/z88dk/}{} \;
	find lib -type f -exec $(INSTALL) -m 664 {,$(DESTDIR)/$(prefix_share)/z88dk/}{} \;
	find libsrc -type d -exec $(INSTALL) -d -m 755 {,$(DESTDIR)/$(prefix_share)/z88dk/}{} \;
	find libsrc -type f -exec $(INSTALL) -m 664 {,$(DESTDIR)/$(prefix_share)/z88dk/}{} \;


# Needs libs to have been installed, no dependency yet since rebuilding libsrc
# still does too many cleans
test:
	$(MAKE) -C test

testsuite: 
	$(MAKE) -C testsuite

install-clean:
	$(MAKE) -C libsrc install-clean

clean: clean-bins
	$(MAKE) -C libsrc clean
	$(RM) lib/clibs/*.lib


clean-bins:
	$(MAKE) -C src/appmake clean
	$(MAKE) -C src/copt clean
	$(MAKE) -C src/cpp clean
	$(MAKE) -C src/sccz80 clean
	$(MAKE) -C src/z80asm clean
	$(MAKE) -C src/z80nm clean
	$(MAKE) -C src/zcc clean
	$(MAKE) -C src/zpragma clean
	$(MAKE) -C src/ticks clean
	$(MAKE) -C src/zx7 clean
	$(MAKE) -C test clean
	$(MAKE) -C testsuite clean
	$(MAKE) -C src/z88dk-install clean
	#if [ -d bin ]; then find bin -type f -exec rm -f {} ';' ; fi

.PHONY: test testsuite
