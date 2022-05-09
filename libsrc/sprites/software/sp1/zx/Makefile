include ../../../../Make.config

TARGET ?= zx

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/temp/sp1/zx/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/asm*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/_sp*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/__sp1_*_spr_char.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/draw/*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/tiles/*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/updater/*.asm"

NEWLIB_TARGETS := newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS)

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(NEWLIB_TARGETS) $(OBJECTS) sp1-zx.lib

sp1-zx.lib:
	find obj -type f -name "*.o" > files.lst
	z80asm -xsp1-zx @files.lst
	rm files.lst

newlib-z80:
	@$(ASSEMBLER) -d -O=obj/z80/x -I. -I$(NEWLIB_DIRECTORY) -mz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 


clean:
	$(RM) -fr obj sp1-zx.lib
	$(MAKE) -C examples clean
