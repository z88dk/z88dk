#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm)
CFILES  = cosh.c sinh.c tanh.c modf.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS +=  -math-z88 -D__Z88__ -D__NATIVE_MATH__

all: dirs $(OUTPUT_DIRECTORY)/z88_math.lib


$(OUTPUT_DIRECTORY)/z88_math.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/z88_math @z88math.lst

dirs:
	@mkdir -p obj/z80/c/sccz80 obj/ixiy/c/sccz80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

