ENTERPRISE_GLOBS := \
	"target/enterprise/enterprise/*.asm" \
	"target/enterprise/games/*.asm" \
	"target/enterprise/stdio/*.asm" \
	"target/enterprise/time/*.asm"

ENTERPRISE_GLOBS_ex := \
	target/enterprise/enterprise/*.asm \
	target/enterprise/games/*.asm \
	target/enterprise/stdio/*.asm \
	target/enterprise/time/*.asm

ENTERPRISE_CFILES := $(wildcard target/enterprise/enterprise/*.c)
ENTERPRISE_TAPE_CFILES := $(wildcard target/enterprise/tape/*.c)
ENTERPRISE_GFX_CFILES := $(wildcard target/enterprise/graphics/*.c)
ENTERPRISE_HRG_CFILES := $(wildcard target/enterprise/graphics_hr/*.c)

ENTERPRISE_OFILES := $(patsubst target/enterprise/%,target/enterprise/obj/enterprise/%,$(ENTERPRISE_CFILES:.c=.o))
ENTERPRISE_TAPE_OFILES := $(patsubst target/enterprise/%,target/enterprise/obj/enterprise/%,$(ENTERPRISE_TAPE_CFILES:.c=.o))
ENTERPRISE_GFX_OFILES := $(patsubst target/enterprise/%,target/enterprise/obj/enterprise/%,$(ENTERPRISE_GFX_CFILES:.c=.o))
ENTERPRISE_HRG_OFILES := $(patsubst target/enterprise/%,target/enterprise/obj/enterprisehr/%,$(ENTERPRISE_HRG_CFILES:.c=.o))

ENTERPRISE_TARGETS := \
	target/enterprise/obj/target-enterprise-enterprise \
	$(ENTERPRISE_OFILES) \
	$(ENTERPRISE_TAPE_OFILES) \
	classic/games/obj/.stamp-enterprise \
	classic/gfx/obj/.stamp-enterprise

ENTERPRISE_GFX_TARGETS := \
	$(ENTERPRISE_GFX_OFILES) \
	classic/gfx/obj/.stamp-enterprise

ENTERPRISE_HRG_TARGETS := \
	$(ENTERPRISE_HRG_OFILES) \
	classic/gfx/obj/.stamp-enterprisehr

enterprise_clib.lib: $(TARGET_CLIB_DEPS) $(ENTERPRISE_TARGETS)
	TARGET=enterprise TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORenterprise -x$(OUTPUT_DIRECTORY)/enterprise_clib @$(TARGET_DIRECTORY)/enterprise/enterprise.lst

gfxep.lib: $(TARGET_CLIB_DEPS) enterprise_clib.lib $(ENTERPRISE_GFX_TARGETS)
	TARGET=enterprise TYPE=z80 $(LIBLINKER) -DFORenterprise -x$(OUTPUT_DIRECTORY)/gfxep @$(TARGET_DIRECTORY)/enterprise/gfxep.lst

gfxephr.lib: $(TARGET_CLIB_DEPS) gfxep.lib $(ENTERPRISE_HRG_TARGETS)
	TARGET=enterprisehr TYPE=z80 $(LIBLINKER) -DFORenterprisehr -x$(OUTPUT_DIRECTORY)/gfxephr @$(TARGET_DIRECTORY)/enterprise/gfxephr.lst

CLEAN += target-enterprise-clean
TOCREATE += $(call check_target,enterprise,enterprise_clib.lib gfxep.lib gfxephr.lib)

$(eval $(call gfx_stamp_args,enterprise,TARGET=enterprise FLAVOUR=wide))
$(eval $(call gfx_stamp_args,enterprisehr,TARGET=enterprise FLAVOUR=wide SUBTYPE=enterprisehr))

target-enterprise: $(ENTERPRISE_TARGETS) $(ENTERPRISE_GFX_TARGETS) $(ENTERPRISE_HRG_TARGETS)

.PHONY: target-enterprise target-enterprise-clean

$(eval $(call buildtargetasm,target/enterprise,z80,enterprise,-mz80,$(ENTERPRISE_GLOBS),$(ENTERPRISE_GLOBS_ex)))

target/enterprise/obj/enterprise/enterprise/%.o: target/enterprise/enterprise/%.c
	$(Q)mkdir -p $(dir $@)
	$(ZCC) +enterprise $(CFLAGS) -c -o $@ $<

target/enterprise/obj/enterprise/tape/%.o: target/enterprise/tape/%.c
	$(Q)mkdir -p $(dir $@)
	$(ZCC) +enterprise $(CFLAGS) -c -o $@ $<

target/enterprise/obj/enterprise/graphics/%.o: target/enterprise/graphics/%.c
	$(Q)mkdir -p $(dir $@)
	$(ZCC) +test $(CFLAGS) -c -o $@ $<

target/enterprise/obj/enterprisehr/graphics_hr/%.o: target/enterprise/graphics_hr/%.c
	$(Q)mkdir -p $(dir $@)
	$(ZCC) +test $(CFLAGS) -c -o $@ $<

target-enterprise-clean:
	$(RM) -fr target/enterprise/obj
