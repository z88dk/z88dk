#
# Makefile for lib3d
#
# $Id: Makefile,v 1.2 2016-07-02 15:42:55 dom Exp $


include ../Make.config

CFILES = $(wildcard *.c)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/lib3d @lib3d.lst

%.o: %.c
	$(ZCC) +test $(CFLAGS) -o $@ $^

clean:
	$(RM) *.o* zcc_opt.def
