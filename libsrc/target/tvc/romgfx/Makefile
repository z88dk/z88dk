#
# Makefile for TVC specific gfx libraries
#

include ../../../Make.config

CFILES = $(wildcard *.c)
OFILES = $(CFILES:.c=.o)

all: $(OFILES)

%.o: %.c
	$(ZCC) +tvc -DTVC -D__TVC__ $(CFLAGS) $^

clean:
	$(RM) *.o* zcc_opt.def
