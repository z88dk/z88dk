include ../../../Make.config



ASMFILES = $(wildcard *.asm)
CFILES = $(wildcard *.c)
OBJECTS = $(ASMFILES:.asm=.o)  $(CFILES:.c=.o)

all: dirs $(addprefix obj/gbz80/,$(OBJECTS)) 


obj/gbz80/%.o: %.asm
	$(Q)$(ASSEMBLER) -DFORgb -mgbz80 -I$(Z88DK_LIB) -I$(Z88DK_LIB)/../libsrc  $^
	@mv $(^:.asm=.o) $@

dirs:
	@mkdir -p obj/gbz80

clean: 
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
