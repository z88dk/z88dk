
include ../Make.config

TARGET ?= test
GENOBJECTS = 
CUSTOBJECTS = 
ASMFILES = $(wildcard *.asm) strings/strdup.asm

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/$(TARGET)/,$(CUSTOBJECTS))  $(addprefix obj/z80-zxn/,$(OBJECTS))

obj/z80/%.o: %.c
	zcc +test -mz80 $(CFLAGS) -o $@  $^

obj/z80/%.o: %.asm
	zcc +test -mz80 $(CFLAGS) -o $@  $^

obj/z80-zxn/%.o: %.c
	zcc +test -mz80-zxn -custom-copt-rules=$(Z88DK_LIB)/zxn_rules.1  $(CFLAGS) -o $@  $^

obj/z80-zxn/%.o: %.asm
	zcc +test -mz80-zxn $(CFLAGS) -o $@  $^

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
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/z80-zxn obj/$(TARGET)
	@mkdir -p obj/z80/strings obj/r2k/strings obj/ixiy/strings obj/z80-zxn/strings obj/$(TARGET)

clean:
	$(RM) -fr obj
