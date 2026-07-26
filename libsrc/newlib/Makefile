#
# make [target]       - Build libraries for target (eg make zx)
# make [target]-clean - Clean the target libraries (eg make zx-clean)
#


Z80ASM = z88dk-z80asm
ZX0 = z88dk-zx0

ALLTARGETS = am9511 cpm hbios m math16 math32 rc2014 scz180 sms yaz180 z180 z80 zx zxn 
TARGET = $(ALLTARGETS)

# Targets whose sources live under libsrc/target/ (classic-aligned), not newlib/target/
MIGRATED_TARGETS = hbios scz180 yaz180 rc2014

Z88DK_LIB := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/../../lib/

# Newlib library products install next to classic clibs (ABI subdirs for sccz80 / sdcc_*)
LIB_OUT := $(Z88DK_LIB)clibs
LIB_SCCZ80 := $(LIB_OUT)/sccz80
LIB_SDCC_IX := $(LIB_OUT)/sdcc_ix

NEWLIB_ROOT = ../

Q ?= @

# Source root for a target: ../target/NAME if migrated, else target/NAME (under newlib)
target_dir = $(if $(filter $(1),$(MIGRATED_TARGETS)),../target/$(1),target/$(1))


.PHONY: all clean install-clean
all: $(TARGET)

clean: $(addsuffix -clean,$(TARGET))
	@find . -name '*.err' | xargs $(RM)
	$(RM) config_private.inc

install-clean:
	$(RM) -fr target/*/obj
	$(RM) -fr ../target/hbios/obj ../target/scz180/obj ../target/yaz180/obj ../target/rc2014/obj


define config
.PHONY: $(1)-clean

# +zx/+zxn use +z80 as part of the config stage so add the dependency
target/zx/obj/config_private.inc: $(LIB_SCCZ80)/z80.lib
target/zxn/obj/config_private.inc: $(LIB_SCCZ80)/zx.lib

# Convenience target (eg make zx to build the zx libraries)
.PHONY: $(1)
$(1): $(LIB_SCCZ80)/$(1).lib $(LIB_SDCC_IX)/$(1).lib 

$(call target_dir,$(1))/obj/config_private.inc: $(call target_dir,$(1))/config.m4
	@mkdir -p $(call target_dir,$(1))/obj/sccz80 $(call target_dir,$(1))/obj/sdcc_ix 
	@mkdir -p $(LIB_SCCZ80) $(LIB_SDCC_IX)
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
	m4 -DCFG_ASM_DEF -I$(Z88DK_LIB)/../src/m4 -I. -I.. $(call target_dir,$(1))/config.m4 > $(call target_dir,$(1))/config_$(1)_private.inc
	m4 -DCFG_ASM_PUB -I$(Z88DK_LIB)/../src/m4 -I. -I.. $(call target_dir,$(1))/config.m4 > $(call target_dir,$(1))/config_$(1)_public.inc
	m4 -DCFG_C_DEF   -I$(Z88DK_LIB)/../src/m4 -I. -I.. $(call target_dir,$(1))/config.m4 > $(call target_dir,$(1))/config_$(1).h
	cp $(call target_dir,$(1))/config_$(1)_private.inc $(call target_dir,$(1))/obj/config_private.inc
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
	@if [ -f $(call target_dir,$(1))/library/$(1)_macro.lst ]; then \
		zcc +z80 -vn -clib=new -copy-back-after-m4 -m4 -Cm-I$(call target_dir,$(1))/obj --lstcwd @$(call target_dir,$(1))/library/$(1)_macro.lst; \
	fi;
endef

define build_libs
$(LIB_SCCZ80)/$(1).lib: $(call target_dir,$(1))/obj/config_private.inc
	@mkdir -p $(LIB_SCCZ80)
	TARGET=$(1) TYPE=$(cpu) $(Z80ASM) -m$(cpu) -d -m4=-I$(call target_dir,$(1))/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -O$(call target_dir,$(1))/obj/sccz80/x -I$(call target_dir,$(1))/obj -I.. -x$(LIB_SCCZ80)/$(1) -I$(Z88DK_LIB) @$(call target_dir,$(1))/library/$(1)_sccz80.lst

$(LIB_SDCC_IX)/$(1).lib: $(call target_dir,$(1))/obj/config_private.inc
	@mkdir -p $(LIB_SDCC_IX)
	TARGET=$(1) TYPE=$(cpu) $(Z80ASM) -m$(cpu) -d -m4=-I$(call target_dir,$(1))/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -O$(call target_dir,$(1))/obj/sdcc_ix/x -I$(call target_dir,$(1))/obj -I.. -x$(LIB_SDCC_IX)/$(1) -I$(Z88DK_LIB) -D__SDCC -D__SDCC_IX @$(call target_dir,$(1))/library/$(1)_sdcc_ix.lst

endef

define make_clean
.PHONY: $(1)-clean

$(1)-clean:
	@$(RM) -r $(call target_dir,$(1))/obj
	@$(RM) $(LIB_SCCZ80)/$(1).lib
	@$(RM) $(LIB_SDCC_IX)/$(1).lib
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
