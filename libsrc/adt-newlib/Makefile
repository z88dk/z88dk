
include ../Make.config

TARGET ?= test
GENOBJECTS = 
CUSTOBJECTS = 
NEWLIBASM := $(shell z88dk-lstmanip -i $(NEWLIB_DIRECTORY)/adt/adt_sccz80.lst -p $(NEWLIB_DIRECTORY) -t)
NEWLIBOBJ := $(NEWLIBASM:.asm=.o)

OBJECTS := $(subst $(NEWLIB_DIRECTORY),obj/z80,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/z80-zxn,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/r2k,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/ixiy,$(NEWLIBOBJ))

all: dirs $(OBJECTS) adt.lst

obj/z80/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/ixiy/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --IXIY --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/r2k/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=r2k -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80-zxn/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80-zxn -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

adt.lst:
	@z88dk-lstmanip -i $(NEWLIB_DIRECTORY)/adt/adt_sccz80.lst -p $(NEWLIB_DIRECTORY) -c -o adt.lst


dirs:
	@mkdir -p $(dir $(OBJECTS))

clean:
	$(RM) -fr obj adt.lst zcc_opt.def
