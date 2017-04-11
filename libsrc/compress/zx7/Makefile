#

include ../../Make.config

TARGET ?= test
ASMFILES = $(wildcard *.asm)

OBJECTS = $(GENOBJECTS) $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

.PHONY: 

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS))

obj/z80/%.o: %.c
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/z80/%.o: %.asm
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/r2k/%.o: %.c
	zcc +rcmx000 $(CFLAGS) -o $@  $^

obj/r2k/%.o: %.asm
	zcc +rcmx000 $(CFLAGS) -Ca-DFORrcmx000 -o $@  $^

dirs:
	@mkdir -p obj/z80 obj/r2k

clean:
	$(RM) -fr obj zcc_opt.def
