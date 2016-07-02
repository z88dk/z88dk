

include ../../Make.config


CFILES = $(wildcard *.c)
OBJECTS = $(CFILES:.c=.o)

DESTDIR=$(OUTPUT_DIRECTORY)/


all: $(DESTDIR)preempt.lib

.c.o:
	zcc +test $(CFLAGS) $*.c


$(DESTDIR)preempt.lib: $(OBJECTS)
	$(LIBLINKER) -x$(DESTDIR)preempt $(OBJECTS)

clean:
	rm -f *.o $(DESTDIR)preempt.lib zcc_opt.def




