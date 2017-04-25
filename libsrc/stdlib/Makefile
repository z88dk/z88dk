
include ../Make.config

TARGET ?= test
GENOBJECTS = unbcd.o wcmatch.o getopt.o
CUSTOBJECTS = sleep.o csleep.o delay.o
ASMFILES = $(wildcard *.asm)

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/$(TARGET)/,$(CUSTOBJECTS)) 

obj/z80/%.o: %.c
	zcc +test -mz80 $(CFLAGS) -o $@  $^

obj/z80/%.o: %.asm
	zcc +test -mz80 $(CFLAGS) -o $@  $^

obj/ixiy/%.o: %.c
	zcc +test -mz80 -Ca--IXIY -Cl--IXIY $(CFLAGS) -o $@  $^

obj/ixiy/%.o: %.asm
	zcc +test -mz80 -Ca--IXIY -Cl--IXIY $(CFLAGS) -o $@  $^

obj/r2k/%.o: %.c
	zcc +rcmx000 $(CFLAGS) -o $@  $^

obj/r2k/%.o: %.asm
	zcc +rcmx000 $(CFLAGS) -Ca-DFORrcmx000 -o $@  $^

obj/$(TARGET)/%.o: %.c
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(TARGET)/%.o: %.asm
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/$(TARGET)

clean:
	$(RM) -fr obj
	$(MAKE) -C z88 clean
