#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm)
CFILES  = acos.c asin.c	atan2.c	atof.c cosh.c ftoa.c ftoe.c pow.c sinh.c tanh.c acosh.c asinh.c atanh.c modf.c sqrt.c tofix16.c fromfix16.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=z80 -DFLOAT_IS_48BITS

all: dirs $(OUTPUT_DIRECTORY)/genmath.lib \
	$(OUTPUT_DIRECTORY)/genmath_ixiy.lib \
	$(OUTPUT_DIRECTORY)/genmath_zx81.lib \
	$(OUTPUT_DIRECTORY)/genmath_ez80_z80.lib \
	$(OUTPUT_DIRECTORY)/genmath_z80n.lib


$(OUTPUT_DIRECTORY)/genmath.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/genmath @genmath.lst

$(OUTPUT_DIRECTORY)/genmath_z80n.lib: $(addprefix obj/z80n/, $(OBJECTS))
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/genmath_z80n @genmath.lst

$(OUTPUT_DIRECTORY)/genmath_r2ka.lib: $(addprefix obj/r2ka/, $(OBJECTS))
	TYPE=r2ka $(LIBLINKER) -m42k -x$(OUTPUT_DIRECTORY)/genmath_r2ka @genmath.lst

$(OUTPUT_DIRECTORY)/genmath_ez80_z80.lib: $(addprefix obj/ez80_z80/, $(OBJECTS))
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/genmath_ez80_z80 @genmath.lst


$(OUTPUT_DIRECTORY)/genmath_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/genmath_ixiy @genmath.lst

$(OUTPUT_DIRECTORY)/genmath_zx81.lib: $(addprefix obj/ixiy_zx81/, $(OBJECTS))
	TYPE=ixiy_zx81 $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/genmath_zx81 @genmathzx81.lst

obj/ixiy_zx81/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -I$(Z88DK_LIBSRC) -IXIY -mz80 -D__CLASSIC $(AFLAGS) -Oobj/ixiy_zx81 $^

obj/ixiy_zx81/%.o: %.c
	$(ZCC) +test -mz80 -Ca-IXIY -Cl-IXIY $(CFLAGS) -o $@  $^


dirs:
	@mkdir -p obj/z80/c/sccz80 obj/ixiy/c/sccz80 obj/ixiy_zx81/c/sccz80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

