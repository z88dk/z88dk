#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard c/asm/*.asm) $(wildcard z80/*.asm)
CFILES  = amin.c amax.c fmod.c acos.c asin.c atan2.c atof.c cosh.c ftoa.c ftoe.c sinh.c tanh.c acosh.c asinh.c atanh.c 
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=mbf32 -D__MATH_MBF32

all: dirs $(OUTPUT_DIRECTORY)/mbf32.lib $(OUTPUT_DIRECTORY)/mbf32_8080.lib $(OUTPUT_DIRECTORY)/mbf32_8085.lib $(OUTPUT_DIRECTORY)/mbf32_iy.lib $(OUTPUT_DIRECTORY)/mbf32_gbz80.lib

$(OUTPUT_DIRECTORY)/mbf32.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/mbf32 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_8080.lib: $(addprefix obj/8080/, $(OBJECTS))
	TYPE=8080 $(LIBLINKER) -m8080 -x$(OUTPUT_DIRECTORY)/mbf32_8080 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_8085.lib: $(addprefix obj/8085/, $(OBJECTS))
	TYPE=8085 $(LIBLINKER) -m8085 -x$(OUTPUT_DIRECTORY)/mbf32_8085 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_iy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/mbf32_iy @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_gbz80.lib: $(addprefix obj/gbz80/, $(OBJECTS))
	TYPE=gbz80 $(LIBLINKER) -mgbz80 -x$(OUTPUT_DIRECTORY)/mbf32_gbz80 @mbf32.lst

dirs:
	@mkdir -p obj/z80/c/sccz80 obj/z80/c/asm obj/z80/z80
	@mkdir -p obj/8080/c/sccz80 obj/8080/c/asm obj/8080/z80
	@mkdir -p obj/8085/c/sccz80 obj/8085/c/asm obj/8085/z80
	@mkdir -p obj/ixiy/c/sccz80 obj/ixiy/c/asm obj/ixiy/z80
	@mkdir -p obj/gbz80/c/sccz80 obj/gbz80/c/asm obj/gbz80/z80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

