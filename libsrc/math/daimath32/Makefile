#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard c/asm/*.asm) $(wildcard z80/*.asm)
CFILES  = amin.c amax.c fmod.c atan2.c	atof.c cosh.c ftoa.c ftoe.c sinh.c tanh.c acosh.c asinh.c atanh.c pow_valid.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=am9511 -D__MATH_DAI32

all: dirs $(OUTPUT_DIRECTORY)/daimath32.lib $(OUTPUT_DIRECTORY)/daimath32_8080.lib


$(OUTPUT_DIRECTORY)/daimath32.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/daimath32 @daimath32.lst

$(OUTPUT_DIRECTORY)/daimath32_8080.lib: $(addprefix obj/8080/, $(OBJECTS))
	TYPE=8080 $(LIBLINKER) -m8080 -x$(OUTPUT_DIRECTORY)/daimath32_8080 @daimath32.lst


dirs:
	@mkdir -p obj/z80/c/sccz80 obj/z80/c/asm obj/8080/c/sccz80 obj/8080/c/asm obj/z80/z80 obj/8080/z80 

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

