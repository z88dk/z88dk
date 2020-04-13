include ../../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/arch/zx/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/graphics/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/graphics/c/sccz80/*.asm"

NEWLIB_TARGETS := obj/newlib-z80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80


clean:
	$(RM) -fr obj 
