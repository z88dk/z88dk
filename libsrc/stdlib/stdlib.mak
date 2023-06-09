STDLIB_AFILES = $(notdir $(wildcard stdlib/*.asm))
STDLIB_CFILES = unbcd.c wcmatch.c getopt.c

STDLIB_8080_AFILES = $(notdir $(filter-out $(wildcard stdlib/*sqrt*.asm stdlib/*inp*.asm stdlib/*outp*.asm stdlib/*extract*.asm) , $(wildcard stdlib/*.asm))) $(patsubst stdlib/%,%,$(wildcard stdlib/8080/*.asm))
STDLIB_GBZ80_AFILES = $(notdir $(filter-out $(wildcard stdlib/*sqrt*.asm stdlib/*inp*.asm stdlib/*outp*.asm stdlib/*extract*.asm) , $(wildcard stdlib/*.asm))) $(patsubst stdlib/%,%,$(wildcard stdlib/8080/*.asm))


STDLIB_OBJECTS = $(STDLIB_CFILES:.c=.o) $(STDLIB_AFILES:.asm=.o)
STDLIB_8080_OBJECTS = $(STDLIB_CFILES:.c=.o) $(STDLIB_8080_AFILES:.asm=.o)
STDLIB_GBZ80_OBJECTS = $(STDLIB_CFILES:.c=.o) $(STDLIB_GBZ80_AFILES:.asm=.o)

STDLIB_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/stdlib/z80/*.asm" "$(NEWLIB_DIRECTORY)/stdlib/z80/random/*.asm"
STDLIB_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/stdlib/z80/*.asm $(NEWLIB_DIRECTORY)/stdlib/z80/random/*.asm

STDLIB_8080_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/*rand*.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/abs.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/labs.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/atoi.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/atol.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/itoa*.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtol.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtol_callee.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtoul.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtoul_callee.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/z80/*rand*.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/z80/*abs*.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/z80/random/*.asm" \
        $(NEWLIB_DIRECTORY)/stdlib/z80/__stdlib_seed.asm

STDLIB_8080_NEWLIBGLOBS_ex := $(wildcard $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/*rand*.asm) \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/abs.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/labs.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/atoi.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/atol.asm \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/itoa*.asm) \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtol.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtol_callee.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtoul.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtoul_callee.asm \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/z80/*rand*.asm") \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/z80/*abs*.asm) \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/z80/random/*.asm) \
        $(NEWLIB_DIRECTORY)/stdlib/z80/__stdlib_seed.asm

STDLIB_GBZ80_NEWLIBGLOBS = $(STDLIB_8080_NEWLIBGLOBS)
STDLIB_GBZ80_NEWLIBGLOBS_ex = $(STDLIB_8080_NEWLIBGLOBS_ex)



STDLIB_NEWLIB_TARGETS := stdlib/obj/newlib-z80-stdlib stdlib/obj/newlib-z80n-stdlib stdlib/obj/newlib-r2k-stdlib stdlib/obj/newlib-ixiy-stdlib stdlib/obj/newlib-8080-stdlib stdlib/obj/newlib-gbz80-stdlib stdlib/obj/newlib-ez80_z80-stdlib

STDLIB_OBJECTS = $(STDLIB_CFILES:.c=.o) $(STDLIB_AFILES:.asm=.o)

STDLIB_OBJS = $(addprefix stdlib/obj/z80/, $(STDLIB_OBJECTS)) $(addprefix stdlib/obj/r2k/,$(STDLIB_OBJECTS)) $(addprefix stdlib/obj/ixiy/,$(STDLIB_OBJECTS))  $(addprefix stdlib/obj/z80n/,$(STDLIB_OBJECTS)) $(addprefix stdlib/obj/8080/,$(STDLIB_8080_OBJECTS))  $(addprefix stdlib/obj/gbz80/,$(STDLIB_GBZ80_OBJECTS)) $(addprefix stdlib/obj/ez80_z80/,$(STDLIB_OBJECTS))


OBJS += $(STDLIB_OBJS) $(STDLIB_NEWLIB_TARGETS)
CLEAN += stdlib-clean

stdlib: $(STDLIB_OBJS) $(STDLIB_NEWLIB_TARGETS)

.PHONY: stdlib stdlib-clean

$(eval $(call buildbit,stdlib,z80,test))
$(eval $(call buildbit,stdlib,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,stdlib,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,stdlib,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,stdlib,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,stdlib,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,stdlib,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


stdlib/obj/newlib-z80-stdlib: $(STDLIB_NEWLIBGLOBS_ex)
	@mkdir -p stdlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=stdlib/obj/z80/x -I.. -mz80 -D__CLASSIC $(STDLIB_NEWLIBGLOBS)

stdlib/obj/newlib-r2k-stdlib: $(STDLIB_NEWLIBGLOBS_ex)
	@mkdir -p stdlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=stdlib/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(STDLIB_NEWLIBGLOBS)

stdlib/obj/newlib-z80n-stdlib: $(STDLIB_NEWLIBGLOBS_ex)
	@mkdir -p stdlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=stdlib/obj/z80n/x -I.. -mz80n -D__CLASSIC $(STDLIB_NEWLIBGLOBS)

stdlib/obj/newlib-ixiy-stdlib: $(STDLIB_NEWLIBGLOBS_ex)
	@mkdir -p stdlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=stdlib/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(STDLIB_NEWLIBGLOBS)

stdlib/obj/newlib-8080-stdlib: $(STDLIB_8080_NEWLIBGLOBS_ex)
	@mkdir -p stdlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=stdlib/obj/8080/x -I.. -m8080 -D__CLASSIC $(STDLIB_8080_NEWLIBGLOBS)

stdlib/obj/newlib-gbz80-stdlib: $(STDLIB_GBZ80_NEWLIBGLOBS_ex)
	@mkdir -p stdlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=stdlib/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(STDLIB_GBZ80_NEWLIBGLOBS)

stdlib/obj/newlib-ez80_z80-stdlib: $(STDLIB_NEWLIBGLOBS_ex)
	@mkdir -p stdlib/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=stdlib/obj/ez80_z80/x -I.. -mez80_z80 -D__CLASSIC $(STDLIB_NEWLIBGLOBS)

stdlib-clean:
	$(RM) -fr stdlib/obj stdlib/*.o
