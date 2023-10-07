#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

NEWLIB_ROOT=../_DEVELOPMENT/

#all: dirs $(OUTPUT_DIRECTORY)/z80_crt0.lib $(OUTPUT_DIRECTORY)/r2ka_crt0.lib $(OUTPUT_DIRECTORY)/z80iy_crt0.lib $(OUTPUT_DIRECTORY)/z180_crt0.lib $(OUTPUT_DIRECTORY)/ez80_crt0.lib $(OUTPUT_DIRECTORY)/8080_crt0.lib $(OUTPUT_DIRECTORY)/gbz80_crt0.lib $(OUTPUT_DIRECTORY)/z80n_crt0.lib $(OUTPUT_DIRECTORY)/8085_crt0.lib

all: obj/z80 obj/ixiy obj/8080 obj/8085 obj/r2ka obj/gbz80 obj/z180 obj/ez80_z80 obj/z180 obj/z80n  obj/r4k obj/kc160

obj/z80:
	mkdir -p obj/z80/z80
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/z80/z80 -I.. -mz80 @crt0_z80.lst

obj/z80n:
	mkdir -p obj/z80/z80
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/z80n/z80n -I.. -mz80n  @crt0_z80n.lst

obj/8080:
	mkdir -p obj/8080/8080
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/8080/8080 -I..  -DCPU_8080 -m8080 @crt0_8080.lst

obj/8085:
	mkdir -p obj/8085/8085
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/8085/8085 -I..  -DCPU_8085 -m8085 @crt0_8085.lst

obj/gbz80:
	mkdir -p obj/gbz80/gbz80
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/gbz80/gbz80 -I..  -DCPU_GBZ80 -mgbz80 @crt0_gbz80.lst

obj/z180:
	mkdir -p obj/z180/z180
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/z180/z180 -I..  -mz180 @crt0_z180.lst

obj/ez80_z80:
	mkdir -p obj/ez80/ez80
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/ez80_z80/ez80 -I..  -mez80_z80 -DEZ80 @crt0_ez80.lst

obj/r2ka:
	mkdir -p obj/r2ka/r2ka
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/r2ka/r2ka -I.. -mr2ka  @crt0_r2ka.lst

obj/r4k:
	mkdir -p obj/r4k/r4k
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/r4k/r4k -I.. -mr4k  @crt0_r2ka.lst

obj/kc160:
	mkdir -p obj/kc160/kc160
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/kc160/kc160 -I.. -mkc160  @crt0_kc160.lst


# this one uses iy in place of ix
obj/ixiy:
	mkdir -p obj/ixiy/ixiy
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/ixiy/ixiy -I.. -IXIY -D__SDCC_IX  @crt0_z80.lst



clean:
	@$(RM) -r obj

