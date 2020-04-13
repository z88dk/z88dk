include ../../../Make.config

TARGET ?= test

NEWLIBGLOBS := \
	"$(NEWLIB_DIRECTORY)/arch/ts2068/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/ts2068/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/arch/ts2068/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/arch/ts2068/display/c/sccz80/*.asm"

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
