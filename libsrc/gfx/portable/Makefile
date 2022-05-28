include ../../Make.config



ASMFILES = $(wildcard *.asm)
CFILES = $(wildcard *.c)
OBJECTS = $(ASMFILES:.asm=.o)  $(CFILES:.c=.o)


all: dirs $(addprefix obj/gbz80/,$(OBJECTS))  $(addprefix obj/8080/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS))


dirs:
	@mkdir -p obj/gbz80 obj/8080 obj/ixiy

clean: 
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
