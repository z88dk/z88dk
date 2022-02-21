

include ../../Make.config


CFILES = $(wildcard *.c)
CFLAGS += -DASM_THREADING
OBJECTS = $(CFILES:.c=.o)

DESTDIR=$(OUTPUT_DIRECTORY)/


all: $(DESTDIR)preempt.lib

.c.o:
	$(ZCC) +test $(CFLAGS) $*.c


$(DESTDIR)preempt.lib: $(OBJECTS)
	$(LIBLINKER) -x$(DESTDIR)preempt $(OBJECTS)

clean:
	$(RM) -f *.o $(DESTDIR)preempt.lib zcc_opt.def




