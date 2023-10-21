
include ../Make.config

NEWLIB_ROOT=../_DEVELOPMENT/

all: obj/z80-crt0 obj/ixiy-crt0 obj/8080-crt0 obj/8085-crt0 \
	obj/r2ka-crt0 obj/gbz80-crt0 obj/z180-crt0 \
	obj/ez80_z80-crt0 obj/z180-crt0 obj/z80n-crt0  obj/r4k-crt0 obj/kc160-crt0

obj/z80-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/z80/z80 -I.. -mz80 @crt0_z80.lst
	@touch $@

obj/z80n-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/z80n/z80n -I.. -mz80n  @crt0_z80n.lst
	@touch $@

obj/8080-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/8080/8080 -I..  -DCPU_8080 -m8080 @crt0_8080.lst
	@touch $@

obj/8085-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/8085/8085 -I..  -DCPU_8085 -m8085 @crt0_8085.lst
	@touch $@

obj/gbz80-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/gbz80/gbz80 -I..  -DCPU_GBZ80 -mgbz80 @crt0_gbz80.lst
	@touch $@

obj/z180-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/z180/z180 -I..  -mz180 @crt0_z180.lst
	@touch $@

obj/ez80_z80-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/ez80_z80/ez80 -I..  -mez80_z80 -DEZ80 @crt0_ez80.lst
	@touch $@

obj/r2ka-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/r2ka/r2ka -I.. -mr2ka  @crt0_r2ka.lst
	@touch $@

obj/r4k-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/r4k/r4k -I.. -mr4k  @crt0_r2ka.lst
	@touch $@

obj/kc160-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/kc160/kc160 -I.. -mkc160  @crt0_kc160.lst
	@touch $@


# this one uses iy in place of ix
obj/ixiy-crt0:
	NEWLIB_ROOT=$(NEWLIB_ROOT) $(ASSEMBLER) -Oobj/ixiy/ixiy -I.. -IXIY -D__SDCC_IX  @crt0_z80.lst
	@touch $@



clean:
	@$(RM) -r obj

