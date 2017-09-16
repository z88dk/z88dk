
include ../Make.config

TARGET ?= test
GENOBJECTS = 
CUSTOBJECTS = 
NEWLIBASM := $(shell z88dk-lstmanip -i $(NEWLIB_DIRECTORY)/adt/adt_sccz80.lst -p $(NEWLIB_DIRECTORY) -t)
NEWLIBOBJ := $(NEWLIBASM:.asm=.o)

OBJECTS := $(subst $(NEWLIB_DIRECTORY),obj/z80,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/z80-zxn,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/r2k,$(NEWLIBOBJ)) $(subst $(NEWLIB_DIRECTORY),obj/ixiy,$(NEWLIBOBJ))

all: dirs $(OBJECTS) adt.lst

obj/z80/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@zcc +test -mz80 $(CFLAGS) -o $@  $^

obj/ixiy/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@zcc +test -mz80 -Ca--IXIY -Cl--IXIY $(CFLAGS) -o $@  $^

obj/r2k/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@zcc +rcmx000 $(CFLAGS) -o $@  $^

obj/z80-zxn/%.o: $(NEWLIB_DIRECTORY)/%.asm
	@zcc +test -mz80-zxn -custom-copt-rules=$(Z88DK_LIB)/zxn_rules.1 $(CFLAGS) -o $@  $^

adt.lst:
	@z88dk-lstmanip -i $(NEWLIB_DIRECTORY)/adt/adt_sccz80.lst -p $(NEWLIB_DIRECTORY) -c -o adt.lst


dirs:
	@mkdir -p $(dir $(OBJECTS))

clean:
	$(RM) -fr obj adt.lst zcc_opt.def
