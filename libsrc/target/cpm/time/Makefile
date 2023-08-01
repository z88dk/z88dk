include ../../../Make.config

TARGET = cpm


ASMFILES = $(wildcard *.asm)
OBJECTS = $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/8080/,$(OBJECTS)) $(addprefix obj/z80/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/z180/,$(OBJECTS))


clean: 
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o

dirs:
	@mkdir -p obj/8080 obj/z80

