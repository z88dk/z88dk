#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard c/asm/*.asm) $(wildcard z80/*.asm)
CFILES  = fmin.c fmax.c fmod.c acos.c asin.c atan2.c atof.c cosh.c ftoa.c ftoe.c sinh.c tanh.c acosh.c asinh.c atanh.c  tofix16.c fromfix16.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=mbf32 -D__MATH_MBF32 -DFLOAT_IS_32BITS

all: dirs $(OUTPUT_DIRECTORY)/mbf32.lib $(OUTPUT_DIRECTORY)/mbf32_8080.lib $(OUTPUT_DIRECTORY)/mbf32_8085.lib $(OUTPUT_DIRECTORY)/mbf32_ixiy.lib $(OUTPUT_DIRECTORY)/mbf32_gbz80.lib \
	$(OUTPUT_DIRECTORY)/mbf32_z80n.lib \
	$(OUTPUT_DIRECTORY)/mbf32_z180.lib \
	$(OUTPUT_DIRECTORY)/mbf32_ez80_z80.lib 

$(OUTPUT_DIRECTORY)/mbf32.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/mbf32 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_z80n.lib: $(addprefix obj/z80n/, $(OBJECTS))
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/mbf32_z80n @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_8080.lib: $(addprefix obj/8080/, $(OBJECTS))
	TYPE=8080 $(LIBLINKER) -m8080 -x$(OUTPUT_DIRECTORY)/mbf32_8080 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_8085.lib: $(addprefix obj/8085/, $(OBJECTS))
	TYPE=8085 $(LIBLINKER) -m8085 -x$(OUTPUT_DIRECTORY)/mbf32_8085 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/mbf32_ixiy @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_gbz80.lib: $(addprefix obj/gbz80/, $(OBJECTS))
	TYPE=gbz80 $(LIBLINKER) -mgbz80 -x$(OUTPUT_DIRECTORY)/mbf32_gbz80 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	TYPE=z180 $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/mbf32_z180 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_ez80_z80.lib: $(addprefix obj/ez80_z80/, $(OBJECTS))
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/mbf32_ez80_z80 @mbf32.lst

dirs:
	@mkdir -p obj/z80/c/sccz80 obj/z80/c/asm obj/z80/z80
	@mkdir -p obj/z80n/c/sccz80 obj/z80n/c/asm obj/z80n/z80
	@mkdir -p obj/8080/c/sccz80 obj/8080/c/asm obj/8080/z80
	@mkdir -p obj/8085/c/sccz80 obj/8085/c/asm obj/8085/z80
	@mkdir -p obj/ixiy/c/sccz80 obj/ixiy/c/asm obj/ixiy/z80
	@mkdir -p obj/gbz80/c/sccz80 obj/gbz80/c/asm obj/gbz80/z80
	@mkdir -p obj/z180/c/sccz80 obj/z180/c/asm obj/z180/z80
	@mkdir -p obj/ez80_z80/c/sccz80 obj/ez80_z80/c/asm obj/ez80_z80/z80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

