#

include ../../../Make.config

vpath %.c ../cimpl

CFILES = fromfix16.c tofix16.c
AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard asm/z80/*.asm)
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -D__MATH_MATH16 -DFLOAT_IS_16BITS

all: $(OUTPUT_DIRECTORY)/math16.lib \
	$(OUTPUT_DIRECTORY)/math16_ixiy.lib \
	$(OUTPUT_DIRECTORY)/math16_z80n.lib \
	$(OUTPUT_DIRECTORY)/math16_z180.lib \
	$(OUTPUT_DIRECTORY)/math16_ez80_z80.lib \
	$(OUTPUT_DIRECTORY)/math16_r2ka.lib \
	$(OUTPUT_DIRECTORY)/math16_r4k.lib \
	$(OUTPUT_DIRECTORY)/math16_r6k.lib \
	$(OUTPUT_DIRECTORY)/math16_kc160.lib \
	$(OUTPUT_DIRECTORY)/math16_8085.lib

$(OUTPUT_DIRECTORY)/math16.lib: $(addprefix obj/z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80/x/x/x -I.. -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math16 @math16.lst

$(OUTPUT_DIRECTORY)/math16_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ixiy/x/x/x -I.. -IXIY -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/math16_ixiy @math16.lst

$(OUTPUT_DIRECTORY)/math16_z80n.lib: $(addprefix obj/z80n/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80n/x/x/x -I.. -mz80n -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80n $(LIBLINKER) -mz80n -x$(OUTPUT_DIRECTORY)/math16_z80n @math16.lst

$(OUTPUT_DIRECTORY)/math16_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z180/x/x/x -I.. -mz180 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z180 $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/math16_z180 @math16.lst

$(OUTPUT_DIRECTORY)/math16_ez80_z80.lib: $(addprefix obj/ez80_z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ez80_z80/x/x/x -I.. -mez80_z80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -x$(OUTPUT_DIRECTORY)/math16_ez80_z80 @math16.lst

$(OUTPUT_DIRECTORY)/math16_r2ka.lib: $(addprefix obj/r2ka/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/r2ka/x/x/x -I.. -mr2ka -D__CLASSIC @newlibfiles_z80.lst
	TYPE=r2ka $(LIBLINKER) -mr2ka -x$(OUTPUT_DIRECTORY)/math16_r2ka @math16.lst

$(OUTPUT_DIRECTORY)/math16_r4k.lib: $(addprefix obj/r4k/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/r4k/x/x/x -I.. -mr4k -D__CLASSIC @newlibfiles_z80.lst
	TYPE=r4k $(LIBLINKER) -mr4k -x$(OUTPUT_DIRECTORY)/math16_r4k @math16.lst

$(OUTPUT_DIRECTORY)/math16_r6k.lib: $(addprefix obj/r6k/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/r6k/x/x/x -I.. -mr6k -D__CLASSIC @newlibfiles_z80.lst
	TYPE=r6k $(LIBLINKER) -mr6k -x$(OUTPUT_DIRECTORY)/math16_r6k @math16.lst

$(OUTPUT_DIRECTORY)/math16_kc160.lib: $(addprefix obj/kc160/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/kc160/x/x/x -I.. -mkc160 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=kc160 $(LIBLINKER) -mkc160 -x$(OUTPUT_DIRECTORY)/math16_kc160 @math16.lst

# 8085 adjunct half-float (asm/8085 cores; higher C in WP4)
# Note: OBJECTS still list Z80 sccz80 bridges for other CPUs; 8085 assembly
# is driven solely by newlibfiles_8085.lst (like math32_8085).
$(OUTPUT_DIRECTORY)/math16_8085.lib:
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/8085/x/x/x -I.. -m8085 -D__CLASSIC @newlibfiles_8085.lst
	TYPE=8085 $(LIBLINKER) -m8085 -x$(OUTPUT_DIRECTORY)/math16_8085 @math16.lst

# Order-only: dirs must finish before any object compiles. See Make.config.
$(foreach d,ez80_z80 ixiy kc160 r2ka r4k r6k z180 z80 z80n,$(addprefix obj/$(d)/,$(OBJECTS))): | dirs

dirs:
	$(Q)mkdir -p obj/z80/c obj/ixiy/c obj/z80n/c obj/z180/c obj/ez80_z80/c obj/r2ka/c obj/r4k/c obj/kc160/c obj/8085/c obj/r6k/c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt config_private.inc
	$(RM) -fr obj
