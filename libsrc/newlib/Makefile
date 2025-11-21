#
# make [target]       - Build libraries for target (eg make zx)
# make [target]-clean - Clean the target libraries (eg make zx-clean)
#


Z80ASM = z88dk-z80asm
ZX0 = z88dk-zx0

ALLTARGETS = am9511 cpm hbios m math16 math32 rc2014 scz180 sms yaz180 z180 z80 zx zxn 
TARGET = $(ALLTARGETS)

Z88DK_LIB := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/../../lib/

NEWLIB_ROOT = ../

Q ?= @


.PHONY: all clean install-clean
all: $(TARGET)

clean: $(addsuffix -clean,$(TARGET))
	@find . -name '*.err' | xargs $(RM)
	$(RM) config_private.inc

install-clean:
	$(RM) -fr target/*/obj


define config
.PHONY: $(1)-clean

# +zx/+zxn use +z80 as part of the config stage so add the dependency
target/zx/obj/config_private.inc: lib/sccz80/z80.lib
target/zxn/obj/config_private.inc: lib/sccz80/zx.lib

# Convenience target (eg make zx to build the zx libraries)
.PHONY: $(1)
$(1): lib/sccz80/$(1).lib lib/sdcc_ix/$(1).lib lib/sdcc_iy/$(1).lib

target/$(1)/obj/config_private.inc: target/$(1)/config.m4
	@mkdir -p target/$(1)/obj/sccz80 target/$(1)/obj/sdcc_ix target/$(1)/obj/sdcc_iy
	$(eval cpu := $(shell \
		if [ "$(1)" = "z180" ]; then \
			echo "z180"; \
		elif \
			[ "$(1)" = "scz180" ]; then \
			echo "z180"; \
		elif \
			[ "$(1)" = "yaz180" ]; then \
			echo "z180"; \
		elif \
			[ "$(1)" = "zxn" ]; then \
			echo "z80n"; \
		else \
			echo "z80";  \
		fi) )
	m4 -DCFG_ASM_DEF -I$(Z88DK_LIB)/../src/m4  target/$(1)/config.m4 > target/$(1)/config_$(1)_private.inc
	m4 -DCFG_ASM_PUB -I$(Z88DK_LIB)/../src/m4  target/$(1)/config.m4 > target/$(1)/config_$(1)_public.inc
	m4 -DCFG_C_DEF   -I$(Z88DK_LIB)/../src/m4 target/$(1)/config.m4 > target/$(1)/config_$(1).h
	cp target/$(1)/config_$(1)_private.inc target/$(1)/obj/config_private.inc
	@if [ "$(1)" = "zx" ]; then \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DSTRIPVECTOR" -Cm-Itarget/$(1)/obj $(NEWLIB_ROOT)/target/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o target/zx/obj/bifrost2_engine_48.bin; \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DPLUS3 -DSTRIPVECTOR" -Cm-Itarget/$(1)/obj $(NEWLIB_ROOT)/target/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o target/zx/obj/bifrost2_engine_p3.bin; \
		$(ZX0) -f target/zx/obj/bifrost2_engine_48.bin; \
		$(ZX0) -f target/zx/obj/bifrost2_engine_p3.bin; \
	fi;
	@if [ "$(1)" = "zxn" ]; then \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DSTRIPVECTOR" -Cm-Itarget/$(1)/obj  $(NEWLIB_ROOT)/target/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o target/zxn/obj/bifrost2_engine_48.bin; \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DPLUS3 -DSTRIPVECTOR" -Cm-Itarget/$(1)/obj $(NEWLIB_ROOT)/target/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o target/zxn/obj/bifrost2_engine_p3.bin; \
		$(ZX0) -f target/zxn/obj/bifrost2_engine_48.bin; \
		$(ZX0) -f target/zxn/obj/bifrost2_engine_p3.bin; \
	fi;
	@if [ -f target/$(1)/library/$(1)_macro.lst ]; then \
		zcc +z80 -vn -clib=new -copy-back-after-m4 -m4 -Cm-Itarget/$(1)/obj --lstcwd @target/$(1)/library/$(1)_macro.lst; \
	fi;
endef

define build_libs
lib/sccz80/$(1).lib: target/$(1)/obj/config_private.inc
	TARGET=$(1) TYPE=$(cpu) $(Z80ASM) -m$(cpu) -d -m4=-Itarget/$(1)/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -Otarget/$(1)/obj/sccz80 -Itarget/$(1)/obj -I.. -xlib/sccz80/$(1) -I$(Z88DK_LIB) @target/$(1)/library/$(1)_sccz80.lst

lib/sdcc_ix/$(1).lib: target/$(1)/obj/config_private.inc
	TARGET=$(1) TYPE=$(cpu) $(Z80ASM) -m$(cpu) -d -m4=-Itarget/$(1)/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -Otarget/$(1)/obj/sdcc_ix -Itarget/$(1)/obj -I.. -xlib/sdcc_ix/$(1) -I$(Z88DK_LIB) -D__SDCC -D__SDCC_IX @target/$(1)/library/$(1)_sdcc_ix.lst

lib/sdcc_iy/$(1).lib: target/$(1)/obj/config_private.inc
	TARGET=$(1) TYPE=$(cpu) $(Z80ASM) -m$(cpu) -d -m4=-Itarget/$(1)/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -Otarget/$(1)/obj/sdcc_iy -Itarget/$(1)/obj -I.. -IXIY-soft -xlib/sdcc_iy/$(1) -I$(Z88DK_LIB) -D__SDCC -D__SDCC_IY @target/$(1)/library/$(1)_sdcc_iy.lst
endef

define make_clean
.PHONY: $(1)-clean

$(1)-clean:
	@$(RM) -r target/$(1)/obj
	@$(RM) lib/sccz80/$(1).lib
	@$(RM) lib/sdcc_ix/$(1).lib
	@$(RM) lib/sdcc_iy/$(1).lib
endef

define build_target
endef

# $(1) = list of targets
define build_targets
	$(foreach target, $(1), \
		$(eval $(call config,$(target))) \
		$(eval $(call build_libs,$(target))) \
		$(eval $(call make_clean,$(target))) \
	)
endef

$(eval $(call build_targets,$(ALLTARGETS)))
