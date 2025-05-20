#
#
#	The impromptu compilation makefile for z88dk
#
#	$Id: Makefile,v 1.57 2016-09-09 09:06:07 dom Exp $
#

# ---> Configurable parameters are below his point

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 	:= .exe
else
  EXESUFFIX 	?=
endif

PREFIX ?= /usr/local

prefix_share = $(PREFIX)/share/z88dk
bin_dir = $(PREFIX)/bin
git_rev ?= $(shell git rev-parse --short HEAD)
git_count ?= $(shell git rev-list --count HEAD)
version ?= $(shell date +%Y%m%d)

INSTALL ?= install
CFLAGS ?= -O2
CC ?= gcc
# Prefix for executables (eg z88dk-, hence z88dk-z80asm, z88dk-copt etc)
CROSS ?= 0

OCC := $(CC)
ifneq (, $(shell which ccache))
   CC := ccache $(CC)
endif

Z88DK_PATH	= $(shell pwd)
SDCC_PATH	= $(Z88DK_PATH)/src/sdcc-build
SDCC_VERSION	= 15248

ifdef BUILD_SDCC
ifdef BUILD_SDCC_HTTP
SDCC_DEPS	= zsdcc_r$(SDCC_VERSION)_src.tar.gz
endif
endif

# --> End of Configurable Options

export CC INSTALL CFLAGS CROSS

BINS = bin/z88dk-appmake$(EXESUFFIX) bin/z88dk-copt$(EXESUFFIX) \
	bin/z88dk-ucpp$(EXESUFFIX) bin/z88dk-sccz80$(EXESUFFIX) bin/z88dk-z80asm$(EXESUFFIX) \
	bin/zcc$(EXESUFFIX) bin/z88dk-zpragma$(EXESUFFIX) bin/z88dk-zx7$(EXESUFFIX) \
	bin/z88dk-z80nm$(EXESUFFIX) bin/z88dk-zobjcopy$(EXESUFFIX)  \
	bin/z88dk-ticks$(EXESUFFIX) bin/z88dk-z80svg$(EXESUFFIX) \
	bin/z88dk-font2pv1000$(EXESUFFIX) bin/z88dk-basck$(EXESUFFIX) \
	bin/z88dk-lib$(EXESUFFIX) bin/z88dk-zx0$(EXESUFFIX)

ALL = $(BINS) testsuite

ALL_EXT = bin/z88dk-zsdcc$(EXESUFFIX)

.PHONY: all
all: 	$(ALL) $(ALL_EXT)

src/config.h:
	$(shell if [ "${git_count}" != "" ]; then \
		echo '#define PREFIX "${prefix_share}"' > src/config.h; \
		echo '#define BINDIR "${bin_dir}"' >> src/config.h; \
		echo '#define UNIX 1' >> src/config.h; \
		echo '#define Z88DK_VERSION "${git_count}-${git_rev}-${version}"' >> src/config.h; \
	fi)
	$(shell if [ ! -f src/config.h ]; then \
		echo '#define PREFIX "${prefix_share}"' > src/config.h; \
		echo '#define BINDIR "${bin_dir}"' >> src/config.h; \
		echo '#define UNIX 1' >> src/config.h; \
		echo '#define Z88DK_VERSION "unknown-unknown-${version}"' >> src/config.h; \
		fi)
	@mkdir -p bin


$(SDCC_PATH)/configure: $(SDCC_DEPS)
ifdef BUILD_SDCC
ifdef BUILD_SDCC_HTTP
	tar xzf $^
	touch $@
else
	svn checkout -r $(SDCC_VERSION) https://svn.code.sf.net/p/sdcc/code/trunk/sdcc -q $(SDCC_PATH)
	patch -d $(SDCC_PATH) -p0 < $(Z88DK_PATH)/src/zsdcc/sdcc-z88dk.patch
endif
	patch -p1 < support/patches/sdcc-elf-decl.patch
endif

zsdcc_r$(SDCC_VERSION)_src.tar.gz:
	curl http://nightly.z88dk.org/zsdcc/zsdcc_r$(SDCC_VERSION)_src.tar.gz -o zsdcc_r$(SDCC_VERSION)_src.tar.gz

# Helper rule to build the zsdcc tarball for ci builds
zsdcc-tarball: $(SDCC_PATH)/configure
	@mkdir -p dist
	tar --exclude=.svn -cvzf dist/zsdcc_r$(SDCC_VERSION)_src.tar.gz src/sdcc-build

$(SDCC_PATH)/Makefile: $(SDCC_PATH)/configure
ifdef BUILD_SDCC
	cd $(SDCC_PATH) && CC=$(OCC) ./configure \
		--disable-ds390-port --disable-ds400-port \
		--disable-hc08-port --disable-s08-port --disable-mcs51-port \
		--disable-pic-port --disable-pic14-port --disable-pic16-port \
		--disable-tlcs90-port --disable-xa51-port --disable-stm8-port \
		--disable-pdk13-port --disable-pdk14-port \
		--disable-pdk15-port --disable-pdk16-port \
		--disable-mos6502-port --disable-mos65c02-port \
		--disable-r2k-port --disable-f8-port \
		--disable-non-free --disable-device-lib \
		--disable-ucsim --disable-packihx \
		--disable-sdcpp --disable-sdcdb --disable-sdbinutil
endif


$(SDCC_PATH)/bin/sdcc$(EXESUFFIX): $(SDCC_PATH)/Makefile
ifdef BUILD_SDCC
	$(MAKE) -C $(SDCC_PATH) all
endif


bin/z88dk-zsdcc$(EXESUFFIX): $(SDCC_PATH)/bin/sdcc$(EXESUFFIX)
ifdef BUILD_SDCC
	cp $(SDCC_PATH)/src/sdcc$(EXESUFFIX)  $(Z88DK_PATH)/bin/z88dk-zsdcc$(EXESUFFIX)
endif


bin/z88dk-appmake$(EXESUFFIX): src/config.h
	$(MAKE) -C src/appmake PREFIX=`pwd` install

bin/z88dk-copt$(EXESUFFIX): src/config.h
	$(MAKE) -C src/copt PREFIX=`pwd` install

bin/z88dk-ucpp$(EXESUFFIX): src/config.h
	$(MAKE) -C src/ucpp PREFIX=`pwd` install

bin/z88dk-sccz80$(EXESUFFIX): src/config.h
	$(MAKE) -C src/sccz80 PREFIX=`pwd` install

bin/z88dk-z80asm$(EXESUFFIX): src/config.h
	$(MAKE) -C src/z80asm PREFIX=`pwd` PREFIX_SHARE=`pwd` install

bin/zcc$(EXESUFFIX): src/config.h
	$(MAKE) -C src/zcc PREFIX=`pwd` install

bin/z88dk-zpragma$(EXESUFFIX): src/config.h
	$(MAKE) -C src/zpragma PREFIX=`pwd` install

bin/z88dk-zx7$(EXESUFFIX): src/config.h
	$(MAKE) -C src/zx7 PREFIX=`pwd` install

bin/z88dk-zx0$(EXESUFFIX): src/config.h
	$(MAKE) -C src/zx0 PREFIX=`pwd` install

bin/z88dk-z80nm$(EXESUFFIX): src/config.h
	$(MAKE) -C src/z80nm PREFIX=`pwd` install

bin/z88dk-zobjcopy$(EXESUFFIX): src/config.h
	$(MAKE) -C src/zobjcopy PREFIX=`pwd` install

bin/z88dk-z80svg$(EXESUFFIX): src/config.h
	$(MAKE) -C support/graphics PREFIX=`pwd` install

bin/z88dk-basck$(EXESUFFIX): src/config.h
	$(MAKE) -C support/basck PREFIX=`pwd` install

bin/z88dk-font2pv1000$(EXESUFFIX): src/config.h
	$(MAKE) -C support/pv1000 PREFIX=`pwd` install

bin/z88dk-ticks$(EXESUFFIX): src/config.h
	$(MAKE) -C src/ticks PREFIX=`pwd` install

bin/z88dk-lib$(EXESUFFIX): src/config.h
	$(MAKE) -C src/z88dk-lib PREFIX=`pwd` install


libs: $(BINS)
	$(MAKE) -C libsrc
	$(MAKE) -C libsrc  install

install: install-clean
	mkdir -p $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(prefix_share)/lib $(DESTDIR)$(prefix_share)/src
	$(MAKE) -C src/appmake PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/copt PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/ucpp PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/sccz80 PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/z80asm  PREFIX=$(DESTDIR)$(PREFIX) PREFIX_SHARE=$(DESTDIR)$(prefix_share) install
	$(MAKE) -C src/zcc PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/zpragma PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/zx7 PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/zx0 PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/z80nm PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/zobjcopy PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/ticks PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C src/z88dk-lib PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C support/graphics PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C support/basck PREFIX=$(DESTDIR)$(PREFIX) install
	$(MAKE) -C support/pv1000 PREFIX=$(DESTDIR)$(PREFIX) install
	cp -r support/cmake $(DESTDIR)$(prefix_share)/
	if [ -f bin/z88dk-zsdcpp$(EXESUFFIX) ]; then cp bin/z88dk-zsdcpp$(EXESUFFIX) $(DESTDIR)$(PREFIX)/bin/; fi
	if [ -f bin/z88dk-zsdcc$(EXESUFFIX) ]; then cp bin/z88dk-zsdcc$(EXESUFFIX) $(DESTDIR)$(PREFIX)/bin/; fi
	cp -r include $(DESTDIR)$(prefix_share)/
	cp -r lib $(DESTDIR)$(prefix_share)/
	cp -r libsrc $(DESTDIR)$(prefix_share)/
	cp -r src/m4 $(DESTDIR)$(prefix_share)/src/

install-clean:
	$(MAKE) -C libsrc install-clean
	$(RM) lib/z80asm*.lib

	# BSD install syntax below
	#find include -type d -exec $(INSTALL) -d -m 755 {,$(prefix_share)/}{}  \;
	#find include -type f -exec $(INSTALL) -m 664 {,$(prefix_share)/}{}  \;
	#find lib -type d -exec $(INSTALL) -d -m 755 {,$(prefix_share)/}{} \;
	#find lib -type f -exec $(INSTALL) -m 664 {,$(prefix_share)/}{} \;
	#find libsrc -type d -exec $(INSTALL) -d -m 755 {,$(prefix_share)/}{} \;
	#find libsrc -type f -exec $(INSTALL) -m 664 {,$(prefix_share)/}{} \;


# Needs to have a dependency on libs
test: $(ALL)
	$(MAKE) -C test

testsuite: $(BINS)
ifeq ($(CROSS),0)
	$(MAKE) -C testsuite
endif

clean: bins-clean
	$(MAKE) -C libsrc clean
	$(RM) lib/clibs/*.lib
	$(RM) lib/z80asm*.lib

bins-clean:
	$(MAKE) -C src/appmake clean
	$(MAKE) -C src/common clean
	$(MAKE) -C src/copt clean
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
	$(MAKE) -C src/zx0 clean
	$(MAKE) -C examples clean
	$(MAKE) -C support clean
	$(MAKE) -C test clean
	$(MAKE) -C testsuite clean
	$(MAKE) -C src/z88dk-lib clean
	$(RM) -r $(SDCC_PATH)
ifdef BUILD_SDCC
ifdef BUILD_SDCC_HTTP
	$(RM) $(SDCC_DEPS)
endif
endif
	#if [ -d bin ]; then find bin -type f -exec rm -f {} ';' ; fi

test-clean:
	$(MAKE) -C test clean

testsuite-clean:
	$(MAKE) -C testsuite clean

examples-clean:
	$(MAKE) -C examples clean

.PHONY: test testsuite


.PHONY: snap

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	SNAP_OPTS=
else 
	SNAP_OPTS= --use-lxd
endif

snap: snap/snapcraft.yaml
	snapcraft $(SNAP_OPTS)
