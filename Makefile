#
#
#	The impromptu compilation makefile for z88dk
#
#	$Id: Makefile,v 1.57 2016-09-09 09:06:07 dom Exp $
#

# ---> Configurable parameters are below his point
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

prefix ?= /usr/local
prefix_share = $(prefix)/share/z88dk
git_rev ?= $(shell git rev-parse --short HEAD)
git_count ?= $(shell git rev-list --count HEAD)
version ?= $(shell date +%Y%m%d)

INSTALL ?= install
CFLAGS ?= -O2
CC ?= gcc
# Prefix for executables (eg z88dk-, hence z88dk-z80asm, z88dk-copt etc)
EXEC_PREFIX ?=
CROSS ?= 0

SDCC_PATH	= /tmp/sdcc
Z88DK_PATH	= $(shell pwd)

# --> End of Configurable Options

export CC INSTALL CFLAGS EXEC_PREFIX CROSS

all: 	setup appmake copt zcpp ucpp sccz80 z80asm zcc zpragma zx7 z80nm zobjcopy \
	lstmanip ticks z80svg font2pv1000 testsuite z88dk-lib zsdcc

setup:
	$(shell if [ "${git_count}" != "" ]; then \
	    echo '#define PREFIX "${prefix_share}"' > src/config.h; \
	    echo '#define UNIX 1' >> src/config.h; \
	    echo '#define EXEC_PREFIX "${EXEC_PREFIX}"' >> src/config.h; \
	    echo '#define Z88DK_VERSION "${git_count}-${git_rev}-${version}"' >> src/config.h; \
	fi)
	$(shell if [ ! -f src/config.h ]; then \
	    echo '#define PREFIX "${prefix_share}"' > src/config.h; \
	    echo '#define UNIX 1' >> src/config.h; \
	    echo '#define EXEC_PREFIX "${EXEC_PREFIX}"' >> src/config.h; \
	    echo '#define Z88DK_VERSION "unknown-unknown-${version}"' >> src/config.h; \
        fi)
	@mkdir -p bin

zsdcc: bin/zsdcc$(EXESUFFIX)

bin/zsdcc$(EXESUFFIX):
	svn checkout -r 9958 svn://svn.code.sf.net/p/sdcc/code/trunk/sdcc -q $(SDCC_PATH)
	cd $(SDCC_PATH) && patch -p0 < $(Z88DK_PATH)/src/zsdcc/sdcc-z88dk.patch
	cd $(SDCC_PATH) && ./configure --disable-mcs51-port --disable-gbz80-port \
				       --disable-avr-port --disable-ds390-port \
				       --disable-ds400-port --disable-hc08-port \
				       --disable-pic-port --disable-pic14-port \
                       		       --disable-pic16-port --disable-stm8-port \
				       --disable-tlcs90-port --disable-s08-port \
                       		       --disable-ucsim --disable-device-lib \
				       --disable-packihx
	cd $(SDCC_PATH) && $(MAKE)
	cd $(SDCC_PATH) && mv ./bin/sdcc  $(Z88DK_PATH)/bin/zsdcc
	cd $(SDCC_PATH) && mv ./bin/sdcpp $(Z88DK_PATH)/bin/zsdcpp
	$(RM) -fR $(SDCC_PATH)

appmake:
	$(MAKE) -C src/appmake
	$(MAKE) -C src/appmake PREFIX=`pwd` install

copt:
	$(MAKE) -C src/copt
	$(MAKE) -C src/copt PREFIX=`pwd` install

ucpp:
	$(MAKE) -C src/ucpp
	$(MAKE) -C src/ucpp PREFIX=`pwd` install

zcpp:
	$(MAKE) -C src/cpp
	$(MAKE) -C src/cpp PREFIX=`pwd` install

sccz80:
	$(MAKE) -C src/sccz80
	$(MAKE) -C src/sccz80 PREFIX=`pwd` install

z80asm:
	$(MAKE) -C src/z80asm
	$(MAKE) -C src/z80asm PREFIX=`pwd` PREFIX_SHARE=`pwd` install

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

zobjcopy:
	$(MAKE) -C src/zobjcopy
	$(MAKE) -C src/zobjcopy PREFIX=`pwd` install

lstmanip:
	$(MAKE) -C src/lstmanip
	$(MAKE) -C src/lstmanip PREFIX=`pwd` install

z80svg:
	$(MAKE) -C support/graphics
	$(MAKE) -C support/graphics PREFIX=`pwd` install

font2pv1000:
	$(MAKE) -C support/pv1000
	$(MAKE) -C support/pv1000 PREFIX=`pwd` install

ticks:
	$(MAKE) -C src/ticks
	$(MAKE) -C src/ticks PREFIX=`pwd` install

z88dk-lib:
	$(MAKE) -C src/z88dk-lib
	$(MAKE) -C src/z88dk-lib PREFIX=`pwd` install


libs:
	cd libsrc ; $(MAKE)
	cd libsrc ; $(MAKE) install

install: install-clean
	install -d $(DESTDIR)/$(prefix) $(DESTDIR)/$(prefix_share)/lib
	$(MAKE) -C src/appmake PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/copt PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/ucpp PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/cpp PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/sccz80 PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/z80asm  PREFIX=$(DESTDIR)/$(prefix) PREFIX_SHARE=$(DESTDIR)/$(prefix_share) install
	$(MAKE) -C src/zcc PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/zpragma PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/zx7 PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/z80nm PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/lstmanip PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/ticks PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C src/z88dk-lib PREFIX=$(DESTDIR)/$(prefix) install
	$(MAKE) -C support/graphics PREFIX=$(DESTDIR)/$(prefix) install
	find include -type d -exec $(INSTALL) -d -m 755 {,$(DESTDIR)/$(prefix_share)/}{}  \;
	find include -type f -exec $(INSTALL) -m 664 {,$(DESTDIR)/$(prefix_share)/}{}  \;
	find lib -type d -exec $(INSTALL) -d -m 755 {,$(DESTDIR)/$(prefix_share)/}{} \;
	find lib -type f -exec $(INSTALL) -m 664 {,$(DESTDIR)/$(prefix_share)/}{} \;
	find libsrc -type d -exec $(INSTALL) -d -m 755 {,$(DESTDIR)/$(prefix_share)/}{} \;
	find libsrc -type f -exec $(INSTALL) -m 664 {,$(DESTDIR)/$(prefix_share)/}{} \;


# Needs libs to have been installed, no dependency yet since rebuilding libsrc
# still does too many cleans
test:
	$(MAKE) -C test

testsuite:
	$(MAKE) -C testsuite

install-clean:
	$(MAKE) -C libsrc install-clean
	$(RM) lib/z80asm*.lib

clean: clean-bins
	$(MAKE) -C libsrc clean
	$(RM) lib/clibs/*.lib
	$(RM) lib/z80asm*.lib


clean-bins:
	$(MAKE) -C src/appmake clean
	$(MAKE) -C src/common clean
	$(MAKE) -C src/copt clean
	$(MAKE) -C src/cpp clean
	$(MAKE) -C src/lstmanip clean
	$(MAKE) -C src/sccz80 clean
	$(MAKE) -C src/ticks clean
	$(MAKE) -C src/ucpp clean
	$(MAKE) -C src/z80asm clean
	$(MAKE) -C src/z80nm clean
	$(MAKE) -C src/z88dk-lib clean
	$(MAKE) -C src/zcc clean
	$(MAKE) -C src/zobjcopy clean
	$(MAKE) -C src/zpragma clean
	$(MAKE) -C src/zx7 clean
	$(MAKE) -C support clean
	$(MAKE) -C test clean
	$(MAKE) -C testsuite clean
	$(MAKE) -C src/z88dk-lib clean
	#if [ -d bin ]; then find bin -type f -exec rm -f {} ';' ; fi

.PHONY: test testsuite
