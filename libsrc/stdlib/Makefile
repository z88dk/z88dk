
include ../Make.config

TARGET ?= test
GENOBJECTS = unbcd.o wcmatch.o getopt.o
CUSTOBJECTS = sleep.o csleep.o delay.o
ASMFILES = $(wildcard *.asm)

NEWLIB_FILES = __div_store.asm __ldiv_store.asm __lldiv_store.asm asm__div.asm \
	asm__divu.asm asm__ldiv.asm asm__ldivu.asm asm__lldiv.asm \
	asm__lldivu.asm \
	_div_.asm _div__callee.asm _divu_.asm _divu__callee.asm _ldiv_.asm \
	_ldiv__callee.asm _ldivu_.asm _ldivu__callee.asm

ASMFILES += $(NEWLIB_FILES)

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/$(TARGET)/,$(CUSTOBJECTS))  $(addprefix obj/z80-zxn/,$(OBJECTS))

obj/$(TARGET)/%.o: %.c
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(TARGET)/%.o: %.asm
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/ixiy/%.o: $(NEWLIB_DIRECTORY)/stdlib/z80/%.asm
	@$(ASSEMBLER) -I../ --IXIY --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/ixiy/%.o: $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/%.asm
	@$(ASSEMBLER) -I../ --IXIY --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80/%.o: $(NEWLIB_DIRECTORY)/stdlib/z80/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80/%.o: $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/r2k/%.o: $(NEWLIB_DIRECTORY)/stdlib/z80/%.asm
	@$(ASSEMBLER) -I../ --cpu=r2k -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/r2k/%.o: $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/%.asm
	@$(ASSEMBLER) -I../ --cpu=r2k -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80-zxn/%.o: $(NEWLIB_DIRECTORY)/stdlib/z80/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80-zxn -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/z80-zxn/%.o: $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/%.asm
	@$(ASSEMBLER) -I../ --cpu=z80-zxn -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/z80-zxn obj/$(TARGET)

clean:
	$(RM) -fr obj zcc_opt.def *.c.asm
	$(MAKE) -C z88 clean
