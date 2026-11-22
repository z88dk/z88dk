#
# make [target]       - Build libraries for target (eg make zx)
# make [target]-clean - Clean the target libraries (eg make zx-clean)
#


Z80ASM = z88dk-z80asm
ZX0 = z88dk-zx0

ALLTARGETS = am9511 cpm hbios m math16 math32 rc2014 scz180 sms yaz180 z180 z80 zx zxn
TARGET = $(ALLTARGETS)

# math32 newlib products, same CPUs as classic math32.lib / math32_<cpu>.lib
# for the Z80-family cores that share the newlib math32 lists. z80 is
# math32.lib. The others are math32_<cpu>.lib. z80asm -m tags the members.
MATH32_CPUS = z80n z180 r2ka r4k r6k

# Targets whose sources live under libsrc/target/ (classic-aligned), not newlib/target/
MIGRATED_TARGETS = hbios scz180 yaz180 rc2014 cpm

Z88DK_LIB := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/../../lib/

# Newlib library products install next to classic clibs (ABI subdirs for sccz80 / sdcc_*)
LIB_OUT := $(Z88DK_LIB)clibs
LIB_SCCZ80 := $(LIB_OUT)/sccz80
LIB_SDCC_IX := $(LIB_OUT)/sdcc_ix

NEWLIB_ROOT = ../

Q ?= @

# Source root for a target: ../target/NAME if migrated, else target/NAME (under newlib)
target_dir = $(if $(filter $(1),$(MIGRATED_TARGETS)),../target/$(1),target/$(1))


.PHONY: all clean install-clean print-targets
all: $(TARGET)

# build.sh asks for this so -p can be filtered: newlib's target names are
# not the same set as the classic library's.
print-targets:
	@echo $(ALLTARGETS)

clean: $(addsuffix -clean,$(TARGET))
	@find . -name '*.err' | xargs $(RM)
	$(RM) config_private.inc

install-clean:
	$(RM) -fr target/*/obj
	$(RM) -fr ../target/hbios/obj ../target/scz180/obj ../target/yaz180/obj ../target/rc2014/obj ../target/cpm/obj


define config
.PHONY: $(1)-clean

# +zx/+zxn use +z80 as part of the config stage so add the dependency
target/zx/obj/config_private.inc: $(LIB_SCCZ80)/z80.lib
target/zxn/obj/config_private.inc: $(LIB_SDCC_IX)/zx.lib

# Convenience target (eg make zx to build the zx libraries)
.PHONY: $(1)
$(1): $(LIB_SCCZ80)/$(1).lib $(LIB_SDCC_IX)/$(1).lib

$(call target_dir,$(1))/obj/config_private.inc: $(call target_dir,$(1))/config.m4
	$(Q)mkdir -p $(call target_dir,$(1))/obj/sccz80 $(call target_dir,$(1))/obj/sdcc_ix
	$(Q)mkdir -p $(LIB_SCCZ80) $(LIB_SDCC_IX)
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
	$(Q)mkdir -p $(LIB_SCCZ80)
	TARGET=$(1) TYPE=$(cpu) $(Z80ASM) -m$(cpu) -d -m4=-I$(call target_dir,$(1))/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -O$(call target_dir,$(1))/obj/sccz80/x -I$(call target_dir,$(1))/obj -I.. -x$(LIB_SCCZ80)/$(1) -I$(Z88DK_LIB) @$(call target_dir,$(1))/library/$(1)_sccz80.lst

# After the sccz80 library, not beside it. Both assemble the shared multicolour
# sources under target/zx, and z80asm expands a .asm.m4 into the .asm next to
# the source, so under -j the two runs write that one file at the same time.
# On Windows that is a sharing violation rather than a corrupt file.
$(LIB_SDCC_IX)/$(1).lib: $(call target_dir,$(1))/obj/config_private.inc $(LIB_SCCZ80)/$(1).lib
	$(Q)mkdir -p $(LIB_SDCC_IX)
	TARGET=$(1) TYPE=$(cpu) $(Z80ASM) -m$(cpu) -d -m4=-I$(call target_dir,$(1))/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -O$(call target_dir,$(1))/obj/sdcc_ix/x -I$(call target_dir,$(1))/obj -I.. -x$(LIB_SDCC_IX)/$(1) -I$(Z88DK_LIB) -D__SDCC -D__SDCC_IX @$(call target_dir,$(1))/library/$(1)_sdcc_ix.lst

endef

define make_clean
.PHONY: $(1)-clean

$(1)-clean:
	@$(RM) -r $(call target_dir,$(1))/obj
	@$(RM) $(LIB_SCCZ80)/$(1).lib
	@$(RM) $(LIB_SDCC_IX)/$(1).lib
	@$(RM) $(LIB_SCCZ80)/$(1)_z180.lib
	@$(RM) $(LIB_SDCC_IX)/$(1)_z180.lib
	$(if $(filter math32,$(1)),@$(RM) $(foreach cpu,$(MATH32_CPUS),$(LIB_SCCZ80)/math32_$(cpu).lib $(LIB_SDCC_IX)/math32_$(cpu).lib))
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

# The m (math48) library only carries CPU:z80 members, which z80asm refuses
# to pull into -mz180 links.  m_z180 is the --math48 opt-in for newlib z180.
# -lm on newlib z180 is math32_z180 (MATH32_CPUS), not m_z180.
$(LIB_SCCZ80)/m_z180.lib: target/m/obj/config_private.inc
	$(Q)mkdir -p $(LIB_SCCZ80)
	TARGET=m TYPE=z180 $(Z80ASM) -mz180 -d -m4=-Itarget/m/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -Otarget/m/obj/sccz80/x/z180 -Itarget/m/obj -I.. -x$(LIB_SCCZ80)/m_z180 -I$(Z88DK_LIB) @target/m/library/m_sccz80.lst

$(LIB_SDCC_IX)/m_z180.lib: target/m/obj/config_private.inc $(LIB_SCCZ80)/m_z180.lib
	$(Q)mkdir -p $(LIB_SDCC_IX)
	TARGET=m TYPE=z180 $(Z80ASM) -mz180 -d -m4=-Itarget/m/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -Otarget/m/obj/sdcc_ix/x/z180 -Itarget/m/obj -I.. -x$(LIB_SDCC_IX)/m_z180 -I$(Z88DK_LIB) -D__SDCC -D__SDCC_IX @target/m/library/m_sdcc_ix.lst

m: $(LIB_SCCZ80)/m_z180.lib $(LIB_SDCC_IX)/m_z180.lib

# math32.<cpu>.lib — same lists as math32.lib, assembled -m<cpu>.
define build_math32_cpu
$(LIB_SCCZ80)/math32_$(1).lib: target/math32/obj/config_private.inc
	$(Q)mkdir -p $(LIB_SCCZ80)
	TARGET=math32 TYPE=$(1) $(Z80ASM) -m$(1) -d -m4=-Itarget/math32/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -Otarget/math32/obj/sccz80/$(1)/x -Itarget/math32/obj -I.. -x$(LIB_SCCZ80)/math32_$(1) -I$(Z88DK_LIB) @target/math32/library/math32_sccz80.lst

$(LIB_SDCC_IX)/math32_$(1).lib: target/math32/obj/config_private.inc $(LIB_SCCZ80)/math32_$(1).lib
	$(Q)mkdir -p $(LIB_SDCC_IX)
	TARGET=math32 TYPE=$(1) $(Z80ASM) -m$(1) -d -m4=-Itarget/math32/obj -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I../ -Otarget/math32/obj/sdcc_ix/$(1)/x -Itarget/math32/obj -I.. -x$(LIB_SDCC_IX)/math32_$(1) -I$(Z88DK_LIB) -D__SDCC -D__SDCC_IX @target/math32/library/math32_sdcc_ix.lst
endef

$(foreach cpu,$(MATH32_CPUS),$(eval $(call build_math32_cpu,$(cpu))))

math32: $(foreach cpu,$(MATH32_CPUS),$(LIB_SCCZ80)/math32_$(cpu).lib $(LIB_SDCC_IX)/math32_$(cpu).lib)
