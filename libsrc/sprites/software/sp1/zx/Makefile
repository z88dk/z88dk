include ../../../../Make.config

LIBSRC := ../../../..
TARGET ?= zx

NEWLIBGLOBS := "$(LIBSRC)/temp/sp1/zx/c/sccz80/*.asm" \
	"$(LIBSRC)/temp/sp1/zx/sprites/asm*.asm"  \
	"$(LIBSRC)/temp/sp1/zx/sprites/_sp*.asm"  \
	"$(LIBSRC)/temp/sp1/zx/sprites/__sp1_*_spr_char.asm" \
	"$(LIBSRC)/temp/sp1/zx/sprites/draw/*.asm" \
	"$(LIBSRC)/temp/sp1/zx/tiles/*.asm" \
	"$(LIBSRC)/temp/sp1/zx/updater/*.asm"
NEWLIBGLOBS_ex := $(Z88DK_LIBSRC)/temp/sp1/zx/c/sccz80/*.asm \
	$(Z88DK_LIBSRC)/temp/sp1/zx/sprites/asm*.asm \
	$(Z88DK_LIBSRC)/temp/sp1/zx/sprites/_sp*.asm \
	$(Z88DK_LIBSRC)/temp/sp1/zx/sprites/__sp1_*_spr_char.asm \
	$(Z88DK_LIBSRC)/temp/sp1/zx/sprites/draw/*.asm \
	$(Z88DK_LIBSRC)/temp/sp1/zx/tiles/*.asm \
	$(Z88DK_LIBSRC)/temp/sp1/zx/updater/*.asm

NEWLIB_TARGETS := newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS)

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs sp1-zx.lib

sp1-zx.lib: obj/newlib-z80
	$(Q)$(ASSEMBLER) -xsp1-zx "obj/z80/**/*.o"

obj/newlib-z80: $(NEWLIBGLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/z80/x/1/2/3/4 -I. -I$(Z88DK_LIBSRC) -mz80 -D__CLASSIC $(NEWLIBGLOBS)
	@touch $@


dirs:
	@mkdir -p obj/z80 


clean:
	$(RM) -fr obj sp1-zx.lib
	$(MAKE) -C examples clean
