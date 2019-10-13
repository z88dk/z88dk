
include ../../Make.config

CFILES = $(wildcard */*.c)

AFILES  = $(CFILES:.c=.opt)
OBJECTS = $(CFILES:.c=.o)

all: dirs $(OBJECTS)

%.o: %.c
	zcc +s1mp3 -c -o $@ -O0 $^

dirs:
	@mkdir -p obj/z80 

clean:
	$(RM) *.err *.sym *.map zcc_opt.def *.i $(OBJECTS)
