
include ../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/font/fzx/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/z80/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/fonts/**/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/fonts/**/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/zx/z80/*.asm" 
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	@$(ASSEMBLER) -d -O=obj/z80/x -I$(NEWLIB_DIRECTORY) -I../.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80n:  
	@$(ASSEMBLER) -d -O=obj/z80n/x -I$(NEWLIB_DIRECTORY) -I../.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k obj/z80n


clean:
	$(RM) -fr obj 
