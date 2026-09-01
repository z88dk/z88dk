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

C128_CFILES := $(shell find target/c128 -type f -name '*.c')

define c128_variant
C128_$(1)_OFILES := $(addprefix target/c128/obj/$(1)/,$(C128_CFILES:.c=.o))
C128_$(1)_TARGETS := target/c128/obj/target-c128-$(1) $$(C128_$(1)_OFILES) classic/games/obj/.stamp-c128 classic/gfx/obj/.stamp-c128
endef

$(foreach variant,c128 c128udg c128hr c128hr480,$(eval $(call c128_variant,$(variant))))
C128_CPM_TARGETS := $(C128_c128_TARGETS)
C128_TARGETS := $(C128_c128_TARGETS)
C128UDG_TARGETS := $(C128_c128udg_TARGETS)
C128HR_TARGETS := $(C128_c128hr_TARGETS)
C128HR480_TARGETS := $(C128_c128hr480_TARGETS)

CLEAN += target-c128-clean

target-c128: $(C128_TARGETS) $(C128UDG_TARGETS) $(C128HR_TARGETS) $(C128HR480_TARGETS)

.PHONY: target-c128 target-c128-clean

define c128_asm
target/c128/obj/target-c128-$(1): $(C128_GLOBS_ex)
	@mkdir -p target/c128/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/c128/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/c128 -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/c128/def -Itarget/c128 -Itarget/c128/obj/$(1) -I$$(Z88DK_LIBSRC)/classic -mz80 -DFORc128 -I$$(Z88DK_LIB) -D__CLASSIC $$(C128_GLOBS)
	$$(Q)touch $$@
endef

$(foreach variant,c128 c128udg c128hr c128hr480,$(eval $(call c128_asm,$(variant))))

define c128_c_rule
target/c128/obj/$(1)/target/c128/%.o: target/c128/%.c
	@mkdir -p $$(dir $$@)
	$$(ZCC) +c128 -mz80 $$(CFLAGS) -c -o $$@ $$<
endef

$(foreach variant,c128 c128udg c128hr c128hr480,$(eval $(call c128_c_rule,$(variant))))

target-c128-clean:
	$(RM) -fr target/c128/obj
