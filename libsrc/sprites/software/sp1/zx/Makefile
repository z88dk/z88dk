include ../../../../Make.config

TARGET ?= zx

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/temp/sp1/zx/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/asm*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/_sp*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/sprites/draw/*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/tiles/*.asm" "$(NEWLIB_DIRECTORY)/temp/sp1/zx/updater/*.asm"

NEWLIB_TARGETS := newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS)

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(NEWLIB_TARGETS) $(OBJECTS) sp1.lib

sp1.lib:
	z80asm -xsp1 @sp1.lst

#obj/newlib-z80:
newlib-z80:
	@$(ASSEMBLER) -d -O=obj/z80/x -I. -I$(NEWLIB_DIRECTORY) -mz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 


clean:
	$(RM) -fr obj 
