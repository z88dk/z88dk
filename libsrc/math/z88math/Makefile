#
# Wahey, a messed up makefile for building libraries!
#

include ../../Make.config

CFILES = \
	cosh.c \
	sinh.c \
	tanh.c 

AFILES  = $(wildcard *.asm)
OBJECTS = $(CFILES:.c=.o) $(AFILES:.asm=.o)


all: $(OUTPUT_DIRECTORY)/z88_math.lib


$(OUTPUT_DIRECTORY)/z88_math.lib: $(OBJECTS)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/z88_math @z88list

%.o: %.c
	zcc +z88 $(CFLAGS) -math-z88 -D__Z88__ -D__NATIVE_MATH__ $^

%.o: %.asm
	zcc +z88 $(CFLAGS) -math-z88 -D__Z88__ -D__NATIVE_MATH__ $^


clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i 
