#
# make [target]       - Build libraries for target, (eg make zx)
# make clean-[target] - Clean the target (eg make clean-zx)
#


Z80ASM = z88dk-z80asm
ZX7 = z88dk-zx7

TARGET = am9511 cpm hbios m math16 math32 rc2014 scz180 sms vgl yaz180 z180 z80 zx zxn

Z88DK_LIB := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/../../lib/


.PHONY: all clean install-clean
all: $(TARGET)

clean: $(addprefix clean-,$(TARGET))
	@find . -name '*.err' | xargs $(RM)

install-clean:
	$(RM) -fr target/*/obj



define extralib
 $(1) = target
 $(2) = compiler (sccz80,sdcc_ix,sdcc_iy)
 $(3) = list file (without suffix)
lib/$(2)/$(3).lib: target/$(1)/obj/config_private.inc target/$(1)/library/$(3).lst
	$(Z80ASM) $(cpu) -d -Otarget/$(1)/obj/$(2) -Itarget/$(1)/obj -xlib/$(2)/$(3) -I$(Z88DK_LIB) @target/$(1)/library/$(3).lst
endef


define config
.PHONY: clean-$(1)

# +zx/+zxn use +z80 as part of the config stage so add the dependency
target/zx/obj/config_private.inc: lib/sccz80/z80.lib
target/zxn/obj/config_private.inc: lib/sccz80/z80.lib

# Convenience target (eg make zx to build the zx libraries)
.PHONY: $(1)

LIBS_$(1) = lib/sccz80/$(1).lib lib/sdcc_ix/$(1).lib lib/sdcc_iy/$(1).lib

# Look for extra libraries, filtering out the lst files for the main libs
$(foreach extra, $(notdir $(patsubst %.lst,%, $(filter-out target/$(1)/library/$(1)_sccz80.lst, $(wildcard target/$(1)/library/*sccz80*.lst)))), \
                $(eval $(call extralib,$(target),sccz80,$(extra))) \
		LIBS_$(1) += lib/sccz80/$(extra).lib \
        )
$(foreach extra, $(notdir $(patsubst %.lst,%, $(filter-out target/$(1)/library/$(1)_sdcc_ix.lst, $(wildcard target/$(1)/library/*sdcc_ix*.lst)))), \
                $(eval $(call extralib,$(target),sdcc_ix,$(extra))) \
		LIBS_$(1) += lib/sdcc_ix/$(extra).lib \
        )
$(foreach extra, $(notdir $(patsubst %.lst,%, $(filter-out target/$(1)/library/$(1)_sdcc_iy.lst, $(wildcard target/$(1)/library/*sdcc_iy*.lst)))), \
                $(eval $(call extralib,$(target),sdcc_iy,$(extra))) \
		LIBS_$(1) += lib/sdcc_iy/$(extra).lib \
        )
$(foreach extra, $(notdir $(patsubst %.lst,%, $(filter-out target/$(1)/library/$(1)_asm.lst, $(wildcard target/$(1)/library/*asm*.lst)))), \
                $(eval $(call extralib,$(target),asm,$(extra))) \
		LIBS_$(1) += lib/asm/$(extra).lib \
        )

$(1): $$(LIBS_$(1))


target/$(1)/obj/config_private.inc: target/$(1)/config.m4
	@mkdir -p target/$(1)/obj/sccz80 target/$(1)/obj/sdcc_ix target/$(1)/obj/sdcc_iy
	$(eval cpu := $(shell \
		if [ "$(1)" = "z180" ]; then \
			echo "-mz180"; \
		elif \
			[ "$(1)" = "scz180" ]; then \
			echo "-mz180"; \
		elif \
			[ "$(1)" = "yaz180" ]; then \
			echo "-mz180"; \
		elif \
			[ "$(1)" = "zxn" ]; then \
			echo "-mz80n"; \
		else \
			echo "";  \
		fi) )
	m4 -DCFG_ASM_DEF target/$(1)/config.m4 > target/$(1)/config_$(1)_private.inc
	m4 -DCFG_ASM_PUB target/$(1)/config.m4 > target/$(1)/config_$(1)_public.inc
	m4 -DCFG_C_DEF target/$(1)/config.m4 > target/$(1)/config_$(1).h
	cp target/$(1)/config_$(1)_private.inc target/$(1)/obj/config_private.inc
	@if [ "$(1)" = "zx" ]; then \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 > arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/bifrost2/z80/BIFROST2_INSTALL.asm.m4 > arch/zx/bifrost2/z80/BIFROST2_INSTALL.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/bifrost_h/z80/BIFROSTH_ENGINE.asm.m4 > arch/zx/bifrost_h/z80/BIFROSTH_ENGINE.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/bifrost_l/z80/BIFROSTL_ENGINE.asm.m4 > arch/zx/bifrost_l/z80/BIFROSTL_ENGINE.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/nirvanap/z80/NIRVANAP_ENGINE.asm.m4 > arch/zx/nirvanap/z80/NIRVANAP_ENGINE.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/nirvanam/z80/NIRVANAM_ENGINE.asm.m4 > arch/zx/nirvanam/z80/NIRVANAM_ENGINE.asm; \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DSTRIPVECTOR" -Cm-Itarget/$(1)/obj arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DPLUS3 -DSTRIPVECTOR" -Cm-Itarget/$(1)/obj arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
		$(ZX7) -f arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		$(ZX7) -f arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
	fi;
	@if [ "$(1)" = "zxn" ]; then \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 > arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/bifrost2/z80/BIFROST2_INSTALL.asm.m4 > arch/zx/bifrost2/z80/BIFROST2_INSTALL.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/bifrost_h/z80/BIFROSTH_ENGINE.asm.m4 > arch/zx/bifrost_h/z80/BIFROSTH_ENGINE.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/bifrost_l/z80/BIFROSTL_ENGINE.asm.m4 > arch/zx/bifrost_l/z80/BIFROSTL_ENGINE.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/nirvanap/z80/NIRVANAP_ENGINE.asm.m4 > arch/zx/nirvanap/z80/NIRVANAP_ENGINE.asm; \
		m4 -I../../src/m4 -Itarget/zx/obj arch/zx/nirvanam/z80/NIRVANAM_ENGINE.asm.m4 > arch/zx/nirvanam/z80/NIRVANAM_ENGINE.asm; \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DSTRIPVECTOR" -Cm-Itarget/$(1)/obj  arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DPLUS3 -DSTRIPVECTOR" -Cm-Itarget/$(1)/obj arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
		$(ZX7) -f arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		$(ZX7) -f arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
	fi;
	@if [ -f target/$(1)/library/$(1)_macro.lst ]; then \
		zcc +z80 -vn -clib=new -m4 -Cm-Itarget/$(1)/obj --lstcwd @target/$(1)/library/$(1)_macro.lst; \
	fi;
endef

define build_libs
lib/sccz80/$(1).lib: target/$(1)/obj/config_private.inc
	$(Z80ASM) $(cpu) -d -Otarget/$(1)/obj/sccz80 -Itarget/$(1)/obj -xlib/sccz80/$(1) -I$(Z88DK_LIB) @target/$(1)/library/$(1)_sccz80.lst

lib/sdcc_ix/$(1).lib: target/$(1)/obj/config_private.inc
	$(Z80ASM) $(cpu) -d -Otarget/$(1)/obj/sdcc_ix -Itarget/$(1)/obj -xlib/sdcc_ix/$(1) -I$(Z88DK_LIB) -D__SDCC -D__SDCC_IX @target/$(1)/library/$(1)_sdcc_ix.lst

lib/sdcc_iy/$(1).lib: target/$(1)/obj/config_private.inc
	$(Z80ASM) $(cpu) -d -Otarget/$(1)/obj/sdcc_iy -Itarget/$(1)/obj -IXIY -xlib/sdcc_iy/$(1) -I$(Z88DK_LIB) -D__SDCC -D__SDCC_IY @target/$(1)/library/$(1)_sdcc_iy.lst
endef

define make_clean
.PHONY: clean-$(1)

clean-$(1):
	@$(RM) -r target/$(1)/obj
	@$(RM) $(LIBS_$(1))
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

$(eval $(call build_targets,$(TARGET)))


