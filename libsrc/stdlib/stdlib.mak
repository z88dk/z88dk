STDLIB_AFILES := $(notdir $(wildcard stdlib/*.asm))
STDLIB_CFILES := unbcd.c wcmatch.c getopt.c

STDLIB_8080_AFILES := $(notdir $(filter-out $(wildcard stdlib/*sqrt*.asm stdlib/*inp*.asm stdlib/*outp*.asm stdlib/*extract*.asm) , $(wildcard stdlib/*.asm))) $(patsubst stdlib/%,%,$(wildcard stdlib/8080/*.asm))
STDLIB_GBZ80_AFILES := $(notdir $(filter-out $(wildcard stdlib/*sqrt*.asm stdlib/*inp*.asm stdlib/*outp*.asm stdlib/*extract*.asm) , $(wildcard stdlib/*.asm))) $(patsubst stdlib/%,%,$(wildcard stdlib/8080/*.asm))


STDLIB_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_AFILES:.asm=.o)
STDLIB_8080_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_8080_AFILES:.asm=.o)
STDLIB_GBZ80_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_GBZ80_AFILES:.asm=.o)

STDLIB_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/stdlib/z80/*.asm" "$(NEWLIB_DIRECTORY)/stdlib/z80/random/*.asm"
STDLIB_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/stdlib/z80/*.asm $(NEWLIB_DIRECTORY)/stdlib/z80/random/*.asm

STDLIB_8080_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/*rand*.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/abs*.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/labs*.asm" \
        "$(NEWLIB_DIRECTORY)/stdlib/c/sccz80/atoi*.asm" \
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
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/abs*.asm) \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/labs*.asm) \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/atoi*.asm) \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/atol.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/atol_fastcall.asm \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/itoa*.asm) \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtol.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtol_callee.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtoul.asm \
        $(NEWLIB_DIRECTORY)/stdlib/c/sccz80/strtoul_callee.asm \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/z80/*rand*.asm) \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/z80/*abs*.asm) \
        $(wildcard $(NEWLIB_DIRECTORY)/stdlib/z80/random/*.asm) \
        $(NEWLIB_DIRECTORY)/stdlib/z80/__stdlib_seed.asm

STDLIB_GBZ80_NEWLIBGLOBS := $(STDLIB_8080_NEWLIBGLOBS)
STDLIB_GBZ80_NEWLIBGLOBS_ex := $(STDLIB_8080_NEWLIBGLOBS_ex)



STDLIB_NEWLIB_TARGETS := stdlib/obj/newlib-z80-stdlib \
		stdlib/obj/newlib-z80n-stdlib \
		stdlib/obj/newlib-r2ka-stdlib \
		stdlib/obj/newlib-ixiy-stdlib \
		stdlib/obj/newlib-8080-stdlib \
		stdlib/obj/newlib-gbz80-stdlib \
		stdlib/obj/newlib-ez80_z80-stdlib \
		stdlib/obj/newlib-z180-stdlib \
		stdlib/obj/newlib-r4k-stdlib \
		stdlib/obj/newlib-kc160-stdlib

STDLIB_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_AFILES:.asm=.o)

STDLIB_OBJS := $(addprefix stdlib/obj/z80/, $(STDLIB_OBJECTS)) \
	$(addprefix stdlib/obj/r2ka/,$(STDLIB_OBJECTS)) \
	$(addprefix stdlib/obj/ixiy/,$(STDLIB_OBJECTS)) \
	$(addprefix stdlib/obj/z80n/,$(STDLIB_OBJECTS)) \
	$(addprefix stdlib/obj/8080/,$(STDLIB_8080_OBJECTS)) \
	$(addprefix stdlib/obj/gbz80/,$(STDLIB_GBZ80_OBJECTS)) \
	$(addprefix stdlib/obj/ez80_z80/,$(STDLIB_OBJECTS)) \
	$(addprefix stdlib/obj/z180/,$(STDLIB_OBJECTS)) \
	$(addprefix stdlib/obj/r4k/,$(STDLIB_OBJECTS)) \
	$(addprefix stdlib/obj/kc160/,$(STDLIB_OBJECTS))


OBJS += $(STDLIB_OBJS) $(STDLIB_NEWLIB_TARGETS)
CLEAN += stdlib-clean

stdlib: $(STDLIB_OBJS) $(STDLIB_NEWLIB_TARGETS)

.PHONY: stdlib stdlib-clean

$(eval $(call buildbit,stdlib,z80,test))
$(eval $(call buildbit,stdlib,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,stdlib,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,stdlib,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,stdlib,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,stdlib,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,stdlib,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,stdlib,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,stdlib,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,stdlib,kc160,test,-clib=kc160,-mkc160))

$(eval $(call buildnew,stdlib,z80,-mz80,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,r2ka,-mr2ka,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,r4k,-mr4k,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,z80n,-mz80n,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,ixiy,-mz80 -IXIY,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,8080,-m8080,$(STDLIB_8080_NEWLIBGLOBS),$(STDLIB_8080_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,gbz80,-mgbz80,$(STDLIB_GBZ80_NEWLIBGLOBS),$(STDLIB_GBZ80_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,z180,-mz180,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,ez80_z80,-mez80_z80,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,stdlib,kc160,-mkc160,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))


stdlib-clean:
	$(RM) -fr stdlib/obj stdlib/*.o
