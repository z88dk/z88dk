#

include ../../Make.config

vpath %.c ../cimpl/
vpath %.asm c/sccz80
vpath %.asm z80

AFILES  = $(notdir $(wildcard c/sccz80/*.asm)) $(notdir $(wildcard z80/*.asm))
CFILES  = amax.c amin.c ceil.c fmod.c ftoa.c ftoe.c cosh.c sinh.c tanh.c atan2.c atof.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -D__CPC__ -D__NATIVE_MATH__ -D__MATH_CPC

all: dirs $(OUTPUT_DIRECTORY)/cpc_math.lib $(OUTPUT_DIRECTORY)/464_math.lib $(OUTPUT_DIRECTORY)/664_math.lib $(OUTPUT_DIRECTORY)/6128_math.lib


$(OUTPUT_DIRECTORY)/cpc_math.lib: $(addprefix obj/cpc/, $(OBJECTS))
	TYPE=cpc $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpc_math @cpcmath.lst

$(OUTPUT_DIRECTORY)/464_math.lib: $(addprefix obj/464/, $(OBJECTS))
	TYPE=464 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/464_math @cpcmath.lst

$(OUTPUT_DIRECTORY)/664_math.lib: $(addprefix obj/664/, $(OBJECTS))
	TYPE=664 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/664_math @cpcmath.lst

$(OUTPUT_DIRECTORY)/6128_math.lib: $(addprefix obj/6128/, $(OBJECTS))
	TYPE=6128 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/6128_math @cpcmath.lst

obj/cpc/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mz80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/464/%.o: %.asm
	$(Q)$(ASSEMBLER) -DforCPC464 -I../ -I$(Z88DK_LIB) -mz80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/664/%.o: %.asm
	$(Q)$(ASSEMBLER) -DforCPC664 -I../ -I$(Z88DK_LIB) -mz80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/6128/%.o: %.asm
	$(Q)$(ASSEMBLER) -DforCPC6128 -I../ -I$(Z88DK_LIB) -mz80 -D__CLASSIC $^
	@mv $(^:.asm=.o) $@

obj/cpc/%.o: %.c
	$(ZCC) +test -mz80 $(CFLAGS) -o $@  $^

obj/464/%.o: %.c
	$(ZCC) +test -mz80 $(CFLAGS) -o $@  $^

obj/664/%.o: %.c
	$(ZCC) +test -mz80 $(CFLAGS) -o $@  $^

obj/6128/%.o: %.c
	$(ZCC) +test -mz80 $(CFLAGS) -o $@  $^

dirs:
	@mkdir -p obj/cpc/c/sccz80 obj/464/c/sccz80 obj/664/c/sccz80 obj/6128/c/sccz80
	@mkdir -p obj/cpc/z80 obj/464/z80 obj/664/z80 obj/6128/z80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

