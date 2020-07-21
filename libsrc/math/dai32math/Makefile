#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard c/asm/*.asm) $(wildcard z80/*.asm)
CFILES  = amin.c amax.c fmod.c atan2.c	atof.c cosh.c ftoa.c ftoe.c sinh.c tanh.c acosh.c asinh.c atanh.c 
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=am9511 -D__MATH_AM9511

all: dirs $(OUTPUT_DIRECTORY)/dai32math.lib $(OUTPUT_DIRECTORY)/dai32math_8080.lib


$(OUTPUT_DIRECTORY)/dai32math.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/dai32math @dai32math.lst

$(OUTPUT_DIRECTORY)/dai32math_8080.lib: $(addprefix obj/8080/, $(OBJECTS))
	TYPE=8080 $(LIBLINKER) -m8080 -x$(OUTPUT_DIRECTORY)/dai32math_8080 @dai32math.lst


dirs:
	@mkdir -p obj/z80/c/sccz80 obj/z80/c/asm obj/8080/c/sccz80 obj/8080/c/asm obj/z80/z80 obj/8080/z80 

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

