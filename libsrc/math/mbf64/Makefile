#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm)
CFILES  = fmin.c fmax.c fmod.c acos.c asin.c atan2.c atof.c cosh.c ftoa.c ftoe.c modf.c sinh.c tanh.c tofix16.c fromfix16.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=mbf64 -DFLOAT_IS_64BITS

all: dirs $(OUTPUT_DIRECTORY)/mbf64.lib $(OUTPUT_DIRECTORY)/mbf64_ixiy.lib 


$(OUTPUT_DIRECTORY)/mbf64.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/mbf64 @mbf64.lst

$(OUTPUT_DIRECTORY)/mbf64_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/mbf64_ixiy @mbf64.lst

dirs:
	@mkdir -p obj/z80/c/sccz80 obj/ixiy/c/sccz80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

