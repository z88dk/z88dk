include ../../../Make.config



ASMFILES = $(wildcard *.asm)
OBJECTS = $(ASMFILES:.asm=.o) 

all: dirs $(addprefix obj/msx/,$(OBJECTS)) $(addprefix obj/svi/,$(OBJECTS))





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
