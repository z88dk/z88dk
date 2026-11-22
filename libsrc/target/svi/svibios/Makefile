include ../../../Make.config

TARGET = svi


ASMFILES = $(wildcard *.asm)
OBJECTS = $(ASMFILES:.asm=.o) 

all: $(addprefix obj/$(TARGET)/,$(OBJECTS))



obj/$(TARGET)/%.o: %.asm
	@$(ASSEMBLER) -DFOR$(TARGET) -I$(Z88DK_LIB)/../libsrc/ -I$(Z88DK_LIB) -Oobj/$(TARGET) $^

# Order-only: dirs must finish before any object compiles. See Make.config.
$(addprefix obj/$(TARGET)/,$(OBJECTS)): | dirs

dirs:
	$(Q)mkdir -p obj/$(TARGET)

clean: 
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
