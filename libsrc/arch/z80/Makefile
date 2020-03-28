

include ../../Make.config


CFILES = $(wildcard *.c)
OBJECTS = $(CFILES:.c=.o)

DESTDIR=$(OUTPUT_DIRECTORY)/

all: $(OBJECTS)

%.o: %.c
	$(ZCC) +test $(CFLAGS) -c $^


clean:
	$(RM) -f *.o zcc_opt.def




