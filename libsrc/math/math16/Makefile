#

include ../../Make.config

AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard z80/*.asm)
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -D__MATH_MATH16

all: dirs $(OUTPUT_DIRECTORY)/math16.lib $(OUTPUT_DIRECTORY)/math16_ixiy.lib

$(OUTPUT_DIRECTORY)/math16.lib: $(addprefix obj/z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80/x/x  -I.. -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math16 @math16.lst

$(OUTPUT_DIRECTORY)/math16_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ixiy/x/x -I.. -IXIY -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/math16_ixiy @math16.lst


dirs:
	@mkdir -p obj/z80/c obj/ixiy/c 

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt config_private.inc
	$(RM) -fr obj

