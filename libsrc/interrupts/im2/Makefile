
include ../../Make.config

TARGET ?= test
ASMFILES = $(wildcard *.asm)

OBJECTS = $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) 


dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/$(TARGET) obj/8080 obj/gbz80

clean:
	$(RM) -fr obj
	$(RM) zcc_opt.def
