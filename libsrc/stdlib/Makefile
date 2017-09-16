
include ../Make.config

TARGET ?= test
GENOBJECTS = unbcd.o wcmatch.o getopt.o
CUSTOBJECTS = sleep.o csleep.o delay.o
ASMFILES = $(wildcard *.asm)

OBJECTS = $(GENOBJECTS) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/$(TARGET)/,$(CUSTOBJECTS))  $(addprefix obj/z80-zxn/,$(OBJECTS))

obj/$(TARGET)/%.o: %.c
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(TARGET)/%.o: %.asm
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/z80-zxn obj/$(TARGET)

clean:
	$(RM) -fr obj zcc_opt.def
	$(MAKE) -C z88 clean
