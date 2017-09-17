
include ../../Make.config

TARGET ?= test

CLASSIC_ASM = $(wildcard *.asm)
CLASSIC_OBJ = $(CLASSIC_ASM:.asm=.o)
CLASSIC_OBJECTS = $(addprefix obj/z80/, $(CLASSIC_OBJ)) $(addprefix obj/z80-zxn/, $(CLASSIC_OBJ)) $(addprefix obj/r2k/, $(CLASSIC_OBJ)) $(addprefix obj/ixiy/, $(CLASSIC_OBJ))

NEWLIBASM := $(shell z88dk-lstmanip -i $(NEWLIB_DIRECTORY)/alloc/obstack/obstack_sccz80.lst -p $(NEWLIB_DIRECTORY) -t)
NEWLIBOBJ := $(NEWLIBASM:.asm=.o)
NEWLIB_OBJECTS := $(subst $(NEWLIB_DIRECTORY),obj/z80,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/z80-zxn,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/r2k,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/ixiy,$(NEWLIBOBJ))

OBJECTS = $(CLASSIC_OBJECTS) $(NEWLIB_OBJECTS)

.PHONY: dirs

all: dirs $(OBJECTS) obstack-newlib.lst

obj/z80/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80 -D__CLASSIC -o$@ $^

obj/ixiy/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --IXIY --cpu=z80 -D__CLASSIC -o$@ $^

obj/r2k/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=r2k -D__CLASSIC -o$@ $^

obj/z80-zxn/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80-zxn -D__CLASSIC -o$@ $^

obj/z80/%.o: %.asm
	@$(ASSEMBLER) -I../ --cpu=z80 -D__CLASSIC -o$@ $^

obj/ixiy/%.o: %.asm
	@$(ASSEMBLER) -I../ --IXIY --cpu=z80 -D__CLASSIC -o$@ $^

obj/r2k/%.o: %.asm
	@$(ASSEMBLER) -I../ --cpu=r2k -D__CLASSIC -o$@ $^

obj/z80-zxn/%.o: %.asm
	@$(ASSEMBLER) -I../ --cpu=z80-zxn -D__CLASSIC -o$@ $^

obstack-newlib.lst:
	@z88dk-lstmanip -i $(NEWLIB_DIRECTORY)/alloc/obstack/obstack_sccz80.lst -p $(NEWLIB_DIRECTORY) -x 'alloc/obstack/obj/$${TYPE}' -c -o obstack-newlib.lst

dirs:
	@mkdir -p $(dir $(OBJECTS))


clean:
	$(RM) -fr obj obstack-newlib.lst
