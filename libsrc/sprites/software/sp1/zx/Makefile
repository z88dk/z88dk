include ../../../../Make.config

TARGET ?= zx

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/temp/sp1/zx/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/asm*.asm"  \
	"$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/_sp*.asm"  \
	"$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/__sp1_*_spr_char.asm" \
	"$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/draw/*.asm" \
	"$(NEWLIB_DIRECTORY)/temp/sp1/zx/tiles/*.asm" \
	"$(NEWLIB_DIRECTORY)/temp/sp1/zx/updater/*.asm"
NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/temp/sp1/zx/c/sccz80/*.asm \
	$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/asm*.asm \
	$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/_sp*.asm \
	$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/__sp1_*_spr_char.asm \
	$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/draw/*.asm \
	$(NEWLIB_DIRECTORY)/temp/sp1/zx/tiles/*.asm \
	$(NEWLIB_DIRECTORY)/temp/sp1/zx/updater/*.asm

NEWLIB_TARGETS := newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS)

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs sp1-zx.lib

sp1-zx.lib: obj/newlib-z80
	$(Q)$(ASSEMBLER) -xsp1-zx "obj/z80/**/*.o"

obj/newlib-z80: $(NEWLIBGLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/z80/x -I. -I$(NEWLIB_DIRECTORY) -mz80 -D__CLASSIC $(NEWLIBGLOBS)
	@touch $@


dirs:
	@mkdir -p obj/z80 


clean:
	$(RM) -fr obj sp1-zx.lib
	$(MAKE) -C examples clean
