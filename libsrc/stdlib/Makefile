
include ../Make.config

TARGET ?= test
GENOBJECTS = unbcd.o wcmatch.o getopt.o
CUSTOBJECTS = sleep.o csleep.o delay.o
ASMFILES = $(wildcard *.asm)

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)

.PHONY: copyit

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/$(TARGET)/,$(CUSTOBJECTS)) copyit

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

# This is bad, but changing 56 list files will kill me so silently copy the
# machine targets into the right place
# This can go away should #159 (variables in list files) be accepted
copyit:
	@cp -f obj/$(TARGET)/*.o obj/z80/
	@cp -f obj/$(TARGET)/*.o obj/ixiy/
	@cp -f obj/$(TARGET)/*.o obj/r2k/


dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/$(TARGET)

clean:
	$(RM) -fr obj
