#

include ../../Make.config

vpath %.c ../cimpl

CFILES = fromfix16.c tofix16.c
AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard z80/*.asm)
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -D__MATH_MATH16 -DFLOAT_IS_16BITS

all: dirs $(OUTPUT_DIRECTORY)/math16.lib \
	$(OUTPUT_DIRECTORY)/math16_ixiy.lib \
	$(OUTPUT_DIRECTORY)/math16_z80n.lib \
	$(OUTPUT_DIRECTORY)/math16_z180.lib \
	$(OUTPUT_DIRECTORY)/math16_ez80_z80.lib \
	$(OUTPUT_DIRECTORY)/math16_r2ka.lib \
	$(OUTPUT_DIRECTORY)/math16_r4k.lib \
	$(OUTPUT_DIRECTORY)/math16_kc160.lib

$(OUTPUT_DIRECTORY)/math16.lib: $(addprefix obj/z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80/x/x -I.. -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math16 @math16.lst

$(OUTPUT_DIRECTORY)/math16_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ixiy/x/x -I.. -IXIY -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/math16_ixiy @math16.lst

$(OUTPUT_DIRECTORY)/math16_z80n.lib: $(addprefix obj/z80n/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80n/x/x -I.. -mz80n -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/math16_z80n @math16.lst

$(OUTPUT_DIRECTORY)/math16_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z180/x/x -I.. -mz180 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z180 $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/math16_z180 @math16.lst

$(OUTPUT_DIRECTORY)/math16_ez80_z80.lib: $(addprefix obj/ez80_z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ez80_z80/x/x -I.. -mez80_z80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/math16_ez80_z80 @math16.lst

$(OUTPUT_DIRECTORY)/math16_r2ka.lib: $(addprefix obj/r2ka/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/r2ka/x/x -I.. -mr2ka -D__CLASSIC @newlibfiles_z80.lst
	TYPE=r2ka $(LIBLINKER) -mr2ka -x$(OUTPUT_DIRECTORY)/math16_r2ka @math16.lst

$(OUTPUT_DIRECTORY)/math16_r4k.lib: $(addprefix obj/r4k/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/r4k/x/x -I.. -mr4k -D__CLASSIC @newlibfiles_z80.lst
	TYPE=r4k $(LIBLINKER) -mr4k -x$(OUTPUT_DIRECTORY)/math16_r4k @math16.lst

$(OUTPUT_DIRECTORY)/math16_kc160.lib: $(addprefix obj/kc160/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/kc160/x/x -I.. -mkc160 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=kc160 $(LIBLINKER) -mkc160 -x$(OUTPUT_DIRECTORY)/math16_kc160 @math16.lst

dirs:
	@mkdir -p obj/z80/c obj/ixiy/c obj/z80n/c obj/z180/c obj/ez80_z80/c obj/r2ka/c obj/r4k/c obj/kc160/c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt config_private.inc
	$(RM) -fr obj

