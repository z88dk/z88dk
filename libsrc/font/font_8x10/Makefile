
include ../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/font/font_8x10/*.asm"
NEWLIB_TARGETS = obj/newlib-z80 obj/newlib-r2k obj/newlib-z80n obj/newlib-ixiy obj/newlib-8080 obj/newlib-gbz80

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80:  
	$(Q)$(ASSEMBLER) -d -O=obj/z80/x -I$(NEWLIB_DIRECTORY) -I../.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2k:
	$(Q)$(ASSEMBLER) -d -O=obj/r2k/x -I$(NEWLIB_DIRECTORY) -I../.. -mr2ka -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80n:
	$(Q)$(ASSEMBLER) -d -O=obj/z80n/x -I$(NEWLIB_DIRECTORY) -I../.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-ixiy:
	$(Q)$(ASSEMBLER) -d -O=obj/ixiy/x -I$(NEWLIB_DIRECTORY) -I../.. -mz80 -IXIY -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-8080:
	$(Q)$(ASSEMBLER) -d -O=obj/8080/x -I$(NEWLIB_DIRECTORY) -I../.. -m8080 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-gbz80:
	$(Q)$(ASSEMBLER) -d -O=obj/gbz80/x -I$(NEWLIB_DIRECTORY) -I../.. -mgbz80 -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80 obj/z80n obj/ixiy obj/r2k obj/gbz80


clean:
	$(RM) -fr obj 
