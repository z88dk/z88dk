#

include ../../Make.config

vpath %.c ../../_DEVELOPMENT/math/float/math32/c
vpath %.c ../cimpl


CFILES  = $(notdir $(wildcard ../../_DEVELOPMENT/math/float/math32/c/*.c)) atof.c ftoa.c ftoe.c
CFILES  = atof.c ftoa.c ftoe.c tofix16.c fromfix16.c
OBJECTS = $(CFILES:.c=.o) 

CFLAGS += -fp-mode=ieee -DFLOAT_IS_32BITS

all: dirs $(OUTPUT_DIRECTORY)/math32.lib \
	$(OUTPUT_DIRECTORY)/math32_ixiy.lib \
	$(OUTPUT_DIRECTORY)/math32_z80n.lib \
	$(OUTPUT_DIRECTORY)/math32_z180.lib \
	$(OUTPUT_DIRECTORY)/math32_ez80_z80.lib \
	$(OUTPUT_DIRECTORY)/math32_r2ka.lib \
	$(OUTPUT_DIRECTORY)/math32_r4k.lib \
	$(OUTPUT_DIRECTORY)/math32_kc160.lib

$(OUTPUT_DIRECTORY)/math32.lib: $(addprefix obj/z80/, $(OBJECTS)) 
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80/x/x  -I.. -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32 @math32.lst

$(OUTPUT_DIRECTORY)/math32_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ixiy/x/x -I.. -IXIY  -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/math32_ixiy @math32.lst

$(OUTPUT_DIRECTORY)/math32_z80n.lib: $(addprefix obj/z80n/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80n/x/x  -I.. -mz80n -D__CLASSIC @newlibfiles_z80n.lst
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/math32_z80n @math32.lst

$(OUTPUT_DIRECTORY)/math32_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z180/x/x -I..  -mz180 -D__CLASSIC @newlibfiles_z180.lst
	TYPE=z180 $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/math32_z180 @math32.lst

$(OUTPUT_DIRECTORY)/math32_ez80_z80.lib: $(addprefix obj/ez80_z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ez80_z80/x/x -I.. -mez80_z80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/math32_ez80_z80 @math32.lst

$(OUTPUT_DIRECTORY)/math32_r2ka.lib: $(addprefix obj/r2ka/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/r2ka/x/x -I..  -mr2ka -D__CLASSIC @newlibfiles_r2ka.lst
	TYPE=r2ka $(LIBLINKER) -mr2ka -x$(OUTPUT_DIRECTORY)/math32_r2ka @math32.lst

$(OUTPUT_DIRECTORY)/math32_r4k.lib: $(addprefix obj/r4k/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/r4k/x/x -I..  -mr4k -D__CLASSIC @newlibfiles_r2ka.lst
	TYPE=r4k $(LIBLINKER) -mr4k -x$(OUTPUT_DIRECTORY)/math32_r4k @math32.lst

$(OUTPUT_DIRECTORY)/math32_kc160.lib: $(addprefix obj/kc160/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/kc160/x/x -I.. -mkc160 -D__CLASSIC @newlibfiles_kc160.lst
	TYPE=kc160 $(LIBLINKER) -mkc160 -x$(OUTPUT_DIRECTORY)/math32_kc160 @math32.lst

dirs:
	@mkdir -p obj/z80/c obj/ixiy/c obj/z80n/c obj/z180/c obj/ez80_z80/c obj/r2ka/c obj/r4k/c obj/kc160/c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt config_private.inc
	$(RM) -fr obj

