include ../../../Make.config

CFILES = \
	lseek.c \
	opendir.c

OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	$(ZCC) +nc $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.i 


