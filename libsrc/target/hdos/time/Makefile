include ../../../Make.config

TARGET = hdos

CFILES = $(wildcard *.c)
ASMFILES = $(wildcard *.asm)
OBJECTS = $(ASMFILES:.asm=.o) $(CFILES:.c=.o)

AFLAGS += -DSTANDARDESCAPECHARS

all: $(addprefix obj/8080/,$(OBJECTS)) $(addprefix obj/z80/,$(OBJECTS))



clean: 
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o

# Order-only: dirs must finish before any object compiles. See Make.config.
$(addprefix obj/8080/,$(OBJECTS)) $(addprefix obj/z80/,$(OBJECTS)): | dirs

dirs:
	@mkdir -p obj/8080 obj/z80

