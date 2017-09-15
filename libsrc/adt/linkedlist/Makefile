
include ../../Make.config

TARGET ?= test
GENOBJECTS = 
CUSTOBJECTS = 
ASMFILES = $(wildcard *.asm)

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/$(TARGET)/,$(CUSTOBJECTS))  $(addprefix obj/z80-zxn/,$(OBJECTS))


dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/z80-zxn obj/$(TARGET)

clean:
	$(RM) -fr obj zcc_opt.def
