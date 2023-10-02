#

include ../../Make.config


AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard z80/*asm)
CFILES  = $(wildcard cimpl/*.c)
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += 

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2ka/, $(OBJECTS)) \
	$(addprefix obj/ixiy/, $(OBJECTS)) $(addprefix obj/z80n/, $(OBJECTS)) \
	$(addprefix obj/r4k/, $(OBJECTS)) \
	$(addprefix obj/z180/, $(OBJECTS)) \
	$(addprefix obj/ez80_z80/, $(OBJECTS))

obj/z80/%.o: %.c
	$(ZCC) +test -mz80 $(CFLAGS) -o $@  $^

obj/z80/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mz80 -D__CLASSIC -Oobj/z80 $^

obj/z80n/%.o: %.c
	$(ZCC) +test -mz80n $(CFLAGS) -o $@  $^

obj/z80n/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mz80n -D__CLASSIC -Oobj/z80n  $^

obj/ixiy/%.o: %.c
	$(ZCC) +test -mz80 -Ca-IXIY $(CFLAGS) -o $@  $^

obj/ixiy/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -IXIY -mz80 -D__CLASSIC -Oobj/ixiy  $^

obj/z180/%.o: %.c
	$(ZCC) +test -clib=z180 $(CFLAGS) -o $@  $^

obj/z180/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mz180 -D__CLASSIC -Oobj/z180 $^

obj/r2ka/%.o: %.c
	$(ZCC) +test -clib=rabbit $(CFLAGS) -o $@  $^

obj/r2ka/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mr2ka -D__CLASSIC -Oobj/r2ka  $^

obj/r4k/%.o: %.c
	$(ZCC) +test -clib=rabbit4k $(CFLAGS) -o $@  $^

obj/r4k/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mr4k -D__CLASSIC -Oobj/r4k $^

obj/ez80_z80/%.o: %.c
	$(ZCC) +test -clib=ez80_z80 $(CFLAGS) -o $@  $^

obj/ez80_z80/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mez80_z80 -D__CLASSIC -Oobj/ez80_z80  $^


dirs:
	@mkdir -p obj/z80/c/sccz80  obj/z80/z80 obj/z80/cimpl
	@mkdir -p obj/z80n/c/sccz80  obj/z80n/z80 obj/z80n/cimpl
	@mkdir -p obj/r2ka/c/sccz80  obj/r2ka/z80 obj/r2ka/cimpl
	@mkdir -p obj/r4k/c/sccz80  obj/r4k/z80 obj/r4k/cimpl
	@mkdir -p obj/ixiy/c/sccz80  obj/ixiy/z80 obj/ixiy/cimpl
	@mkdir -p obj/ez80_z80/c/sccz80  obj/ez80_z80/z80 obj/ez80_z80/cimpl
	@mkdir -p obj/z180/c/sccz80  obj/z180/z80 obj/z180/cimpl

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

