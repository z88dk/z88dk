
include ../../Make.config

CFILES = $(wildcard */*.c) 

AFILES  = $(wildcard */*.asm)
OBJECTS = $(CFILES:.c=.o) $(AFILES:.asm=.o)

all: dirs $(OBJECTS)

%.o: %.c
	$(ZCC) +s1mp3 -c -o $@  $^

%.o: %.asm
	$(ZCC) +s1mp3 -c -o $@ $^

dirs:
	@mkdir -p obj/z80 

clean:
	$(RM) *.err *.sym *.map zcc_opt.def *.i $(OBJECTS) 
	$(RM) -r obj
