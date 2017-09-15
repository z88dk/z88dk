#

include ../../Make.config

TARGET ?= test
ASMFILES = $(wildcard *.asm)

OBJECTS = $(GENOBJECTS) $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

.PHONY: 

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS))


dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy

clean:
	$(RM) -fr obj zcc_opt.def
