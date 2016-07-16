#
# Wahey, a messed up makefile for building libraries!
#

include ../../Make.config

CFILES = ftoe.c ftoa.c atof.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)


all: ../../math48.lib


../../math48.lib: $(OBJECTS)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math48 @math48.lst

.c.o:
	zcc +test $(CFLAGS) -c  $*.c


clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i $(AFILES)
