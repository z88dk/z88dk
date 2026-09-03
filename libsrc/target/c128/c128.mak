C128_GLOBS := \
	"target/c128/c128/*.asm" \
	"target/c128/games/*.asm" \
	"target/c128/graphics/*.asm" \
	"target/c128/graphics/udg/*.asm" \
	"target/c128/graphics_64k/*.asm" \
	"target/c128/stdio/*.asm" \
	"target/c128/stdio/ansi/*.asm"

C128_GLOBS_ex := \
	target/c128/c128/*.asm \
	target/c128/games/*.asm \
	target/c128/graphics/*.asm \
	target/c128/graphics/udg/*.asm \
	target/c128/graphics_64k/*.asm \
	target/c128/stdio/*.asm \
	target/c128/stdio/ansi/*.asm

C128_CFILES := $(call rwildcard,target/c128,*.c)

define c128_variant
C128_$(1)_OFILES := $(patsubst target/c128/%,target/c128/obj/$(1)/%,$(C128_CFILES:.c=.o))
C128_$(1)_TARGETS := target/c128/obj/target-c128-$(1) $$(C128_$(1)_OFILES) classic/games/obj/.stamp-c128 classic/gfx/obj/.stamp-c128 classic/gfx/obj/.stamp-$(1)
endef

$(foreach variant,c128 c128udg c128hr c128hr480,$(eval $(call c128_variant,$(variant))))
C128_CPM_TARGETS := $(C128_c128_TARGETS)
C128_TARGETS := $(C128_c128_TARGETS)
C128UDG_TARGETS := $(C128_c128udg_TARGETS)
C128HR_TARGETS := $(C128_c128hr_TARGETS)
C128HR480_TARGETS := $(C128_c128hr480_TARGETS)

CLEAN += target-c128-clean
TOCREATE += $(call check_target,c128,c128ansi_clib.lib gfx128.lib gfx128udg.lib gfx128hr.lib gfx128hr480.lib c128cpm.lib)
$(eval $(call gfx_stamp_args,c128,TARGET=c128 FLAVOUR="text narrow"))
$(eval $(call gfx_stamp_args,c128udg,TARGET=c128 FLAVOUR="text6 narrow" SUBTYPE=c128udg))
$(eval $(call gfx_stamp_args,c128hr,TARGET=c128 FLAVOUR=wide SUBTYPE=c128hr))
$(eval $(call gfx_stamp_args,c128hr480,TARGET=c128 FLAVOUR=wide SUBTYPE=c128hr480))
define c128_asm
target/c128/obj/target-c128-$(1): $(C128_GLOBS_ex)
	$(Q)mkdir -p target/c128/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/c128/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/c128 -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/c128/def -Itarget/c128 -Itarget/c128/obj/$(1) -I$$(Z88DK_LIBSRC)/classic -mz80 -DFORc128 -I$$(Z88DK_LIB) -D__CLASSIC $$(C128_GLOBS)
	$$(Q)touch $$@
endef
$(foreach variant,c128 c128udg c128hr c128hr480,$(eval $(call c128_asm,$(variant))))
define c128_c_rule
target/c128/obj/$(1)/%.o: target/c128/%.c
	$(Q)mkdir -p $$(dir $$@)
	$$(ZCC) +c128 -mz80 $$(CFLAGS) -c -o $$@ $$<
endef
$(foreach variant,c128 c128udg c128hr c128hr480,$(eval $(call c128_c_rule,$(variant))))

c128cpm.lib: c128ansi_clib.lib $(TARGET_CLIB_DEPS) $(C128_CPM_TARGETS)
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128cpm @$(TARGET_DIRECTORY)/c128/c128_cpm.lst

c128ansi_clib.lib: $(TARGET_CLIB_DEPS) $(C128_TARGETS)
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128ansi_clib @$(TARGET_DIRECTORY)/c128/c128.lst

gfx128.lib: $(TARGET_CLIB_DEPS) c128ansi_clib.lib $(C128_TARGETS)
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/gfx128 @$(TARGET_DIRECTORY)/c128/gfx128.lst

gfx128udg.lib: $(TARGET_CLIB_DEPS) gfx128.lib $(C128UDG_TARGETS)
	TARGET=c128udg TYPE=z80 $(LIBLINKER) -DFORc128udg -x$(OUTPUT_DIRECTORY)/gfx128udg @$(TARGET_DIRECTORY)/c128/gfx128udg.lst

gfx128hr.lib: $(TARGET_CLIB_DEPS) gfx128udg.lib $(C128HR_TARGETS)
	TARGET=c128hr TYPE=z80 $(LIBLINKER) -DFORc128hr -x$(OUTPUT_DIRECTORY)/gfx128hr @$(TARGET_DIRECTORY)/c128/gfx128hr.lst

gfx128hr480.lib: $(TARGET_CLIB_DEPS) gfx128hr.lib $(C128HR480_TARGETS)
	TARGET=c128hr480 TYPE=z80 $(LIBLINKER) -DFORc128hr480 -x$(OUTPUT_DIRECTORY)/gfx128hr480 @$(TARGET_DIRECTORY)/c128/gfx128hr480.lst



target-c128: $(C128_TARGETS) $(C128UDG_TARGETS) $(C128HR_TARGETS) $(C128HR480_TARGETS)

.PHONY: target-c128 target-c128-clean





target-c128-clean:
	$(RM) -fr target/c128/obj
