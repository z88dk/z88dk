#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard c/asm/*.asm) $(wildcard z80/*.asm)
CFILES  = fmin.c fmax.c fmod.c atan2.c	atof.c cosh.c ftoa.c ftoe.c sinh.c tanh.c acosh.c asinh.c atanh.c pow_valid.c tofix16.c fromfix16.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=am9511 -D__MATH_DAI32 -DFLOAT_IS_32BITS

all: dirs $(OUTPUT_DIRECTORY)/daimath32.lib $(OUTPUT_DIRECTORY)/daimath32_8080.lib \
	$(OUTPUT_DIRECTORY)/daimath32_z80n.lib \
	$(OUTPUT_DIRECTORY)/daimath32_z180.lib \
	$(OUTPUT_DIRECTORY)/daimath32_r2ka.lib \
	$(OUTPUT_DIRECTORY)/daimath32_r4k.lib \
	$(OUTPUT_DIRECTORY)/daimath32_kc160.lib \
	$(OUTPUT_DIRECTORY)/daimath32_ez80_z80.lib 


$(OUTPUT_DIRECTORY)/daimath32.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/daimath32 @daimath32.lst

$(OUTPUT_DIRECTORY)/daimath32_z80n.lib: $(addprefix obj/z80n/, $(OBJECTS))
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/daimath32_z80n @daimath32.lst

$(OUTPUT_DIRECTORY)/daimath32_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	TYPE=z180 $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/daimath32_z180 @daimath32.lst

$(OUTPUT_DIRECTORY)/daimath32_r2ka.lib: $(addprefix obj/r2ka/, $(OBJECTS))
	TYPE=r2ka $(LIBLINKER) -mr2ka -x$(OUTPUT_DIRECTORY)/daimath32_r2ka @daimath32.lst

$(OUTPUT_DIRECTORY)/daimath32_r4k.lib: $(addprefix obj/r4k/, $(OBJECTS))
	TYPE=r4k $(LIBLINKER) -mr4k -x$(OUTPUT_DIRECTORY)/daimath32_r4k @daimath32.lst

$(OUTPUT_DIRECTORY)/daimath32_ez80_z80.lib: $(addprefix obj/ez80_z80/, $(OBJECTS))
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/daimath32_ez80_z80 @daimath32.lst

$(OUTPUT_DIRECTORY)/daimath32_8080.lib: $(addprefix obj/8080/, $(OBJECTS))
	TYPE=8080 $(LIBLINKER) -m8080 -x$(OUTPUT_DIRECTORY)/daimath32_8080 @daimath32.lst

$(OUTPUT_DIRECTORY)/daimath32_kc160.lib: $(addprefix obj/kc160/, $(OBJECTS))
	TYPE=kc160 $(LIBLINKER) -mkc160 -x$(OUTPUT_DIRECTORY)/daimath32_kc160 @daimath32.lst


dirs:
	@mkdir -p obj/z80/c/sccz80 obj/z80/c/asm obj/8080/c/sccz80 obj/8080/c/asm obj/z80/z80 obj/8080/z80 
	@mkdir -p obj/z80n/c/sccz80 obj/z80n/c/asm obj/z180/c/sccz80 obj/z180/c/asm  obj/r2ka/c/sccz80 obj/r2ka/c/asm 
	@mkdir -p obj/ez80_z80/c/sccz80 obj/ez80_z80/c/asm 
	@mkdir -p obj/r4k/c/sccz80 obj/r4k/c/asm obj/kc160/c/sccz80 obj/kc160/c/asm

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

