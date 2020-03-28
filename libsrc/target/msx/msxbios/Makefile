include ../../../Make.config



ASMFILES = $(wildcard *.asm)
CFILES = $(wildcard *.c)
OBJECTS = $(ASMFILES:.asm=.o)  $(CFILES:.c=.o)

all: dirs $(addprefix obj/msx/,$(OBJECTS)) $(addprefix obj/svi/,$(OBJECTS))



obj/msx/%.o: %.c
	$(ZCC) +msx $(CFLAGS) -o $@  $^

obj/svi/%.o: %.c
	$(ZCC) +svi $(CFLAGS) -o $@  $^

obj/msx/%.o: %.asm
	@$(ASSEMBLER) -DFORmsx -I$(Z88DK_LIB) -I$(Z88DK_LIB)/../libsrc  $^
	@mv $(^:.asm=.o) $@

obj/svi/%.o: %.asm
	@$(ASSEMBLER) -DFORsvi -I$(Z88DK_LIB) -I$(Z88DK_LIB)/../libsrc $^
	@mv $(^:.asm=.o) $@

dirs:
	@mkdir -p obj/svi obj/msx

clean: 
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
