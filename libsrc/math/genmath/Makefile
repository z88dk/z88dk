#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm)
CFILES  = acos.c asin.c	atan2.c	atof.c cosh.c ftoa.c ftoe.c pow.c sinh.c tanh.c acosh.c asinh.c atanh.c modf.c sqrt.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=z80

all: dirs $(OUTPUT_DIRECTORY)/genmath.lib $(OUTPUT_DIRECTORY)/genmath_iy.lib $(OUTPUT_DIRECTORY)/genmath_zx81.lib


$(OUTPUT_DIRECTORY)/genmath.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/genmath @genmath.lst

$(OUTPUT_DIRECTORY)/genmath_iy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/genmath_iy @genmath.lst

$(OUTPUT_DIRECTORY)/genmath_zx81.lib: $(addprefix obj/ixiy_zx81/, $(OBJECTS))
	TYPE=ixiy_zx81 $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/genmath_zx81 @genmathzx81.lst

obj/ixiy_zx81/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -I$(Z88DK_LIBSRC) -IXIY -mz80 -D__CLASSIC $(AFLAGS) $^
	@mv $(^:.asm=.o) $@

obj/ixiy_zx81/%.o: %.c
	$(ZCC) +test -mz80 -Ca-IXIY -Cl-IXIY $(CFLAGS) -o $@  $^


dirs:
	@mkdir -p obj/z80/c/sccz80 obj/ixiy/c/sccz80 obj/ixiy_zx81/c/sccz80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

