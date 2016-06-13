include ../../Make.config

CFILES = \
	lseek.c \
	opendir.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

nc_fcntl: $(OBJECTS)

.c.o:
	zcc +nc $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.i $(AFILES)


