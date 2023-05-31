include ../../../Make.config

TARGET = svi


ASMFILES = $(wildcard *.asm)
OBJECTS = $(ASMFILES:.asm=.o) 

all: dirs $(addprefix obj/$(TARGET)/,$(OBJECTS))



obj/$(TARGET)/%.o: %.asm
	@$(ASSEMBLER) -DFOR$(TARGET) -I$(Z88DK_LIB)/../libsrc/ -I$(Z88DK_LIB) -Oobj/$(TARGET) $^

dirs:
	@mkdir -p obj/$(TARGET)

clean: 
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
