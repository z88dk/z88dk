

include ../../Make.config


CFILES = $(wildcard *.c)
OBJECTS = $(CFILES:.c=.o)

DESTDIR=../../$(OUTPUT_DIRECTORY)/


all: $(DESTDIR)multi.lib

.c.o:
	zcc +test $(CFLAGS) $*.c


$(DESTDIR)multi.lib: $(OBJECTS)
	$(LIBLINKER) -x$(DESTDIR)multi $(OBJECTS)

clean:
	rm -f *.o $(DESTDIR)multi




