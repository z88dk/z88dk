#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

CFILES = \
	fprintf.c \
	fscanf.c \
	itou.c \
	ltoa_any.c \
	printf.c \
	scanf.c \
	sprintf.c \
	sscanf.c \
	utoi.c \
	vfprintf_comp.c \
	vfprintf_fp.c \
	vfscanf.c \
	vsprintf.c \
	vsscanf.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.err *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
