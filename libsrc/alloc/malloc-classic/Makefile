
include ../../Make.config

TARGET ?= test
GENOBJECTS = 
CUSTOBJECTS = 
ASMFILES = $(wildcard *.asm) strings/strdup.asm

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/$(TARGET)/,$(CUSTOBJECTS))  $(addprefix obj/z80n/,$(OBJECTS)) $(addprefix obj/8080/,$(OBJECTS)) $(addprefix obj/gbz80/,$(OBJECTS))


dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/z80n obj/8080 obj/gbz80 obj/$(TARGET)
	@mkdir -p obj/z80/strings obj/r2k/strings obj/ixiy/strings obj/z80n/strings obj/8080/strings obj/gbz80/strings obj/$(TARGET)

clean:
	$(RM) -fr obj
