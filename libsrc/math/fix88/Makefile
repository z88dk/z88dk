#

include ../../Make.config

vpath %.c ../cimpl/ cimpl/

AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard z80/*asm)
CFILES  = exp88.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += 

all: dirs $(addprefix obj/z80/, $(OBJECTS))

obj/z80/%.o: %.c
	$(ZCC) +test -mz80 $(CFLAGS) -o $@  $^


obj/z80/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mz80 -D__CLASSIC  $^
	@mv $(^:.asm=.o) $@

dirs:
	@mkdir -p obj/z80/c/sccz80  obj/z80/z80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

