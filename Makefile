#
#
#	The impromptu compilation makefile for z88dk
#
#	$Id: Makefile,v 1.57 2016-09-09 09:06:07 dom Exp $
#

# ---> Configurable parameters are below his point

# EXESUFFIX is passed when cross-compiling Win32 on Linux
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

ifneq (, $(shell which ccache))
   OCC := $(CC)
   CC := ccache $(CC)
endif

SDCC_PATH	= /tmp/sdcc
Z88DK_PATH	= $(shell pwd)

# --> End of Configurable Options

export CC INSTALL CFLAGS EXEC_PREFIX CROSS

ALL = setup bin/appmake$(EXESUFFIX) bin/z88dk-copt$(EXESUFFIX) bin/z88dk-zcpp$(EXESUFFIX) \
	bin/z88dk-ucpp$(EXESUFFIX) bin/sccz80$(EXESUFFIX) bin/z80asm$(EXESUFFIX) \
	bin/zcc$(EXESUFFIX) bin/z88dk-zpragma$(EXESUFFIX) bin/z88dk-zx7$(EXESUFFIX) \
	bin/z80nm$(EXESUFFIX) bin/zobjcopy$(EXESUFFIX)  \
	bin/z88dk-ticks$(EXESUFFIX) bin/z88dk-z80svg$(EXESUFFIX) \
	bin/z88dk-font2pv1000$(EXESUFFIX) bin/z88dk-basck$(EXESUFFIX) \
	testsuite bin/z88dk-lib$(EXESUFFIX) 
ALL_EXT = bin/zsdcc$(EXESUFFIX)

.PHONY: $(ALL)
all: 	$(ALL) $(ALL_EXT)

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


bin/zsdcc$(EXESUFFIX):
	svn checkout -r 11369 svn://svn.code.sf.net/p/sdcc/code/trunk/sdcc -q $(SDCC_PATH)
	cd $(SDCC_PATH) && patch -p0 < $(Z88DK_PATH)/src/zsdcc/sdcc-z88dk.patch
	cd $(SDCC_PATH) && CC=$(OCC) ./configure \
		--disable-ds390-port --disable-ds400-port \
		--disable-hc08-port --disable-s08-port --disable-mcs51-port \
		--disable-pic-port --disable-pic14-port --disable-pic16-port \
		--disable-tlcs90-port --disable-xa51-port --disable-stm8-port \
		--disable-pdk13-port --disable-pdk14-port \
		--disable-pdk15-port --disable-pdk16-port \
		--disable-ucsim --disable-device-lib --disable-packihx
	cd $(SDCC_PATH) && $(MAKE)
	cd $(SDCC_PATH) && mv ./bin/sdcc  $(Z88DK_PATH)/bin/zsdcc
	cd $(SDCC_PATH) && mv ./bin/sdcpp $(Z88DK_PATH)/bin/zsdcpp
	$(RM) -fR $(SDCC_PATH)

bin/appmake$(EXESUFFIX):
	$(MAKE) -C src/appmake PREFIX=`pwd` install

bin/z88dk-copt$(EXESUFFIX):
	$(MAKE) -C src/copt PREFIX=`pwd` install

bin/z88dk-ucpp$(EXESUFFIX):
	$(MAKE) -C src/ucpp PREFIX=`pwd` install

bin/z88dk-zcpp$(EXESUFFIX):
	$(MAKE) -C src/cpp PREFIX=`pwd` install

bin/sccz80$(EXESUFFIX):
	$(MAKE) -C src/sccz80 PREFIX=`pwd` install

bin/z80asm$(EXESUFFIX):
	$(MAKE) -C src/z80asm PREFIX=`pwd` PREFIX_SHARE=`pwd` install

bin/zcc$(EXESUFFIX):
	$(MAKE) -C src/zcc PREFIX=`pwd` install

bin/z88dk-zpragma$(EXESUFFIX):
	$(MAKE) -C src/zpragma PREFIX=`pwd` install

bin/z88dk-zx7$(EXESUFFIX):
	$(MAKE) -C src/zx7 PREFIX=`pwd` install

bin/z80nm$(EXESUFFIX):
	$(MAKE) -C src/z80nm PREFIX=`pwd` install

bin/zobjcopy$(EXESUFFIX):
	$(MAKE) -C src/zobjcopy PREFIX=`pwd` install

bin/z88dk-z80svg$(EXESUFFIX):
	$(MAKE) -C support/graphics PREFIX=`pwd` install

bin/z88dk-basck$(EXESUFFIX):
	$(MAKE) -C support/basck PREFIX=`pwd` install

bin/z88dk-font2pv1000$(EXESUFFIX):
	$(MAKE) -C support/pv1000 PREFIX=`pwd` install

bin/z88dk-ticks$(EXESUFFIX):
	$(MAKE) -C src/ticks PREFIX=`pwd` install

bin/z88dk-lib$(EXESUFFIX):
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
