
include ../Make.config

CFILES = regexp.c regsub.c regerror.c

AFILES  = $(CFILES:.c=.opt)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	zcc +test $(CFLAGS) $*.c

%.opt: %.c
	zcc +test -a $(CFLAGS) $< -o $@

clean:
	$(RM) *.err *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
