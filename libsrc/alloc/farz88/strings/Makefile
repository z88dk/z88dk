
include ../../../Make.config

all: 	strdup_far.o

%.o: %.c
	@zcc +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def
	$(RM) strdup_far.asm *.i
