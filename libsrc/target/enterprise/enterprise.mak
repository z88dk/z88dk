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

ENTERPRISE_OFILES := $(addprefix target/enterprise/obj/enterprise/,$(ENTERPRISE_CFILES:.c=.o))
ENTERPRISE_TAPE_OFILES := $(addprefix target/enterprise/obj/enterprise/,$(ENTERPRISE_TAPE_CFILES:.c=.o))
ENTERPRISE_GFX_OFILES := $(addprefix target/enterprise/obj/enterprise/,$(ENTERPRISE_GFX_CFILES:.c=.o))
ENTERPRISE_HRG_OFILES := $(addprefix target/enterprise/obj/enterprisehr/,$(ENTERPRISE_HRG_CFILES:.c=.o))

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

CLEAN += target-enterprise-clean

target-enterprise: $(ENTERPRISE_TARGETS) $(ENTERPRISE_GFX_TARGETS) $(ENTERPRISE_HRG_TARGETS)

.PHONY: target-enterprise target-enterprise-clean

$(eval $(call buildtargetasm,target/enterprise,z80,enterprise,-mz80,$(ENTERPRISE_GLOBS),$(ENTERPRISE_GLOBS_ex)))

target/enterprise/obj/enterprise/target/enterprise/enterprise/%.o: target/enterprise/enterprise/%.c
	@mkdir -p $(dir $@)
	$(ZCC) +enterprise $(CFLAGS) -c -o $@ $<

target/enterprise/obj/enterprise/target/enterprise/tape/%.o: target/enterprise/tape/%.c
	@mkdir -p $(dir $@)
	$(ZCC) +enterprise $(CFLAGS) -c -o $@ $<

target/enterprise/obj/enterprise/target/enterprise/graphics/%.o: target/enterprise/graphics/%.c
	@mkdir -p $(dir $@)
	$(ZCC) +test $(CFLAGS) -c -o $@ $<

target/enterprise/obj/enterprisehr/target/enterprise/graphics_hr/%.o: target/enterprise/graphics_hr/%.c
	@mkdir -p $(dir $@)
	$(ZCC) +test $(CFLAGS) -c -o $@ $<

target-enterprise-clean:
	$(RM) -fr target/enterprise/obj
