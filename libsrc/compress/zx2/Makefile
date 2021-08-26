include ../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/compress/zx2/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/compress/zx2/z80/asm*.asm"
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2k obj/newlib-ixiy obj/newlib-gbz80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2k:  
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2ka -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80n:  
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-ixiy:  
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-8080:  
	@$(ASSEMBLER) -d -O=obj/8080/x -I.. -m8080 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-gbz80:  
	@$(ASSEMBLER) -d -O=obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k obj/8080 obj/gbz80


clean:
	$(RM) -fr obj 
