include ../../../Make.config

CFILES = \
	close.c      \
	creat.c      \
	lseek.c      \
	open.c       \
	read.c       \
	write.c      \
	writebyte.c  \
	readbyte.c   \
	getcwd.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	$(ZCC) +pps $(CFLAGS) $*.c


clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
