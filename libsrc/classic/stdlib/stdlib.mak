STDLIB_AFILES := $(notdir $(wildcard classic/stdlib/*.asm))
STDLIB_CFILES := unbcd.c wcmatch.c getopt.c

STDLIB_8080_AFILES := $(notdir $(filter-out $(wildcard classic/stdlib/*sqrt*.asm classic/stdlib/*inp*.asm classic/stdlib/*outp*.asm classic/stdlib/*extract*.asm) , $(wildcard classic/stdlib/*.asm))) $(patsubst classic/stdlib/%,%,$(wildcard classic/stdlib/8080/*.asm))
STDLIB_8085_AFILES := $(notdir $(filter-out $(wildcard classic/stdlib/*sqrt*.asm classic/stdlib/*inp*.asm classic/stdlib/*outp*.asm classic/stdlib/*extract*.asm) , $(wildcard classic/stdlib/*.asm))) $(patsubst classic/stdlib/%,%,$(wildcard classic/stdlib/8080/*.asm))
STDLIB_GBZ80_AFILES := $(notdir $(filter-out $(wildcard classic/stdlib/*sqrt*.asm classic/stdlib/*inp*.asm classic/stdlib/*outp*.asm classic/stdlib/*extract*.asm) , $(wildcard classic/stdlib/*.asm))) $(patsubst classic/stdlib/%,%,$(wildcard classic/stdlib/8080/*.asm))


STDLIB_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_AFILES:.asm=.o)
STDLIB_8080_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_8080_AFILES:.asm=.o)
STDLIB_8085_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_8085_AFILES:.asm=.o)
STDLIB_GBZ80_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_GBZ80_AFILES:.asm=.o)

STDLIB_NEWLIBGLOBS := "stdlib/c/sccz80/*.asm" "stdlib/z80/*.asm" "stdlib/z80/random/*.asm"
STDLIB_NEWLIBGLOBS_ex := stdlib/c/sccz80/*.asm stdlib/z80/*.asm stdlib/z80/random/*.asm

STDLIB_8080_NEWLIBGLOBS := \
        "stdlib/c/sccz80/*rand*.asm" \
        "stdlib/c/sccz80/abs*.asm" \
        "stdlib/c/sccz80/labs*.asm" \
        "stdlib/c/sccz80/atoi*.asm" \
        "stdlib/c/sccz80/atol.asm" \
        "stdlib/c/sccz80/atol_fastcall.asm" \
        "stdlib/c/sccz80/itoa*.asm" \
        "stdlib/c/sccz80/strtol.asm" \
        "stdlib/c/sccz80/strtol_callee.asm" \
        "stdlib/c/sccz80/strtoul.asm" \
        "stdlib/c/sccz80/strtoul_callee.asm" \
        "stdlib/z80/*rand*.asm" \
        "stdlib/z80/*abs*.asm" \
        "stdlib/z80/random/*.asm" \
        stdlib/z80/__stdlib_seed.asm

STDLIB_8080_NEWLIBGLOBS_ex := \
        $(wildcard stdlib/c/sccz80/*rand*.asm) \
        $(wildcard stdlib/c/sccz80/abs*.asm) \
        $(wildcard stdlib/c/sccz80/labs*.asm) \
        $(wildcard stdlib/c/sccz80/atoi*.asm) \
        stdlib/c/sccz80/atol.asm \
        stdlib/c/sccz80/atol_fastcall.asm \
        $(wildcard stdlib/c/sccz80/itoa*.asm) \
        stdlib/c/sccz80/strtol.asm \
        stdlib/c/sccz80/strtol_callee.asm \
        stdlib/c/sccz80/strtoul.asm \
        stdlib/c/sccz80/strtoul_callee.asm \
        $(wildcard stdlib/z80/*rand*.asm) \
        $(wildcard stdlib/z80/*abs*.asm) \
        $(wildcard stdlib/z80/random/*.asm) \
        stdlib/z80/__stdlib_seed.asm

STDLIB_8085_NEWLIBGLOBS := $(STDLIB_8080_NEWLIBGLOBS)
STDLIB_8085_NEWLIBGLOBS_ex := $(STDLIB_8080_NEWLIBGLOBS_ex)

STDLIB_GBZ80_NEWLIBGLOBS := $(STDLIB_8080_NEWLIBGLOBS)
STDLIB_GBZ80_NEWLIBGLOBS_ex := $(STDLIB_8080_NEWLIBGLOBS_ex)

STDLIB_NEWLIB_TARGETS := \
		classic/stdlib/obj/newlib-z80-classic-stdlib \
		classic/stdlib/obj/newlib-z80n-classic-stdlib \
		classic/stdlib/obj/newlib-r2ka-classic-stdlib \
		classic/stdlib/obj/newlib-ixiy-classic-stdlib \
		classic/stdlib/obj/newlib-8080-classic-stdlib \
		classic/stdlib/obj/newlib-8085-classic-stdlib \
		classic/stdlib/obj/newlib-gbz80-classic-stdlib \
		classic/stdlib/obj/newlib-ez80_z80-classic-stdlib \
		classic/stdlib/obj/newlib-z180-classic-stdlib \
		classic/stdlib/obj/newlib-r4k-classic-stdlib \
		classic/stdlib/obj/newlib-kc160-classic-stdlib

STDLIB_OBJECTS := $(STDLIB_CFILES:.c=.o) $(STDLIB_AFILES:.asm=.o)

STDLIB_OBJS := \
	$(addprefix classic/stdlib/obj/z80/, $(STDLIB_OBJECTS)) \
	$(addprefix classic/stdlib/obj/r2ka/,$(STDLIB_OBJECTS)) \
	$(addprefix classic/stdlib/obj/ixiy/,$(STDLIB_OBJECTS)) \
	$(addprefix classic/stdlib/obj/z80n/,$(STDLIB_OBJECTS)) \
	$(addprefix classic/stdlib/obj/8080/,$(STDLIB_8080_OBJECTS)) \
	$(addprefix classic/stdlib/obj/8085/,$(STDLIB_8085_OBJECTS)) \
	$(addprefix classic/stdlib/obj/gbz80/,$(STDLIB_GBZ80_OBJECTS)) \
	$(addprefix classic/stdlib/obj/ez80_z80/,$(STDLIB_OBJECTS)) \
	$(addprefix classic/stdlib/obj/z180/,$(STDLIB_OBJECTS)) \
	$(addprefix classic/stdlib/obj/r4k/,$(STDLIB_OBJECTS)) \
	$(addprefix classic/stdlib/obj/kc160/,$(STDLIB_OBJECTS))


OBJS += $(STDLIB_OBJS) $(STDLIB_NEWLIB_TARGETS)
CLEAN += classic-stdlib-clean

classic-stdlib: $(STDLIB_OBJS) $(STDLIB_NEWLIB_TARGETS)

.PHONY: classic-stdlib classic-stdlib-clean

$(eval $(call buildbit,classic/stdlib,z80,test))
$(eval $(call buildbit,classic/stdlib,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/stdlib,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/stdlib,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/stdlib,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/stdlib,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/stdlib,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/stdlib,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/stdlib,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/stdlib,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/stdlib,kc160,test,-clib=kc160,-mkc160))

$(eval $(call buildnew,classic/stdlib,z80,-mz80,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,r2ka,-mr2ka,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,r4k,-mr4k,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,z80n,-mz80n,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,ixiy,-mz80 -IXIY,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,8080,-m8080,$(STDLIB_8080_NEWLIBGLOBS),$(STDLIB_8080_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,8085,-m8085,$(STDLIB_8085_NEWLIBGLOBS),$(STDLIB_8085_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,gbz80,-mgbz80,$(STDLIB_GBZ80_NEWLIBGLOBS),$(STDLIB_GBZ80_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,z180,-mz180,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,ez80_z80,-mez80_z80,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/stdlib,kc160,-mkc160,$(STDLIB_NEWLIBGLOBS),$(STDLIB_NEWLIBGLOBS_ex)))


classic-stdlib-clean:
	$(RM) -fr classic/stdlib/obj/
