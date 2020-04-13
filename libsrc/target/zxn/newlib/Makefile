include ../../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/arch/zxn/memory/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zxn/memory/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zxn/globals/z80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zxn/sysvar/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zxn/version/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zxn/version/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/ts2068/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/ts2068/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/ts2068/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/ts2068/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/graphics/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/graphics/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/zx/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/zx/misc/c/sccz80/*.asm"

NEWLIB_TARGETS := obj/newlib-z80n

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80n:  
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80n 


clean:
	$(RM) -fr obj 
