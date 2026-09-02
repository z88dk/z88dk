CPM_SOURCES := $(shell find target/cpm -type f -name '*.asm' ! -path 'target/cpm/driver/*')
CPM_CFILES := $(shell find target/cpm -type f -name '*.c')
CPM_FCNTL_CFILES := $(shell find target/cpm/fcntl -type f -name '*.c')
CPM_NONFCNTL_CFILES := $(filter-out $(CPM_FCNTL_CFILES),$(CPM_CFILES))

CPM_VARIANTS := 8080 8085 z80 ixiy z180
CPM_ASMFLAGS_8080 := -m8080
CPM_ASMFLAGS_8085 := -m8085
CPM_ASMFLAGS_z80 := -mz80
CPM_ASMFLAGS_ixiy := -mz80 -IXIY
CPM_ASMFLAGS_z180 := -mz180
CPM_CLIBFLAGS_8080 := -clib=8080
CPM_CLIBFLAGS_8085 := -clib=8085
CPM_CLIBFLAGS_z80 :=
CPM_CLIBFLAGS_ixiy := -clib=ixiy
CPM_CLIBFLAGS_z180 := -clib=z180
CPM_ASM_TARGETS := $(foreach cpu,$(CPM_VARIANTS),target/cpm/obj/target-cpm-$(cpu))
CPM_C_TARGETS := $(foreach cpu,$(CPM_VARIANTS),$(patsubst target/cpm/%,target/cpm/obj/$(cpu)/%,$(CPM_NONFCNTL_CFILES:.c=.o)))
CPM_FCNTL_TARGETS := $(foreach cpu,$(CPM_VARIANTS),$(foreach device,nodevice device,$(patsubst target/cpm/fcntl/%,target/cpm/obj/$(cpu)/$(device)/fcntl/%,$(CPM_FCNTL_CFILES:.c=.o))))

CPM_TARGETS := $(CPM_ASM_TARGETS) $(CPM_C_TARGETS) $(CPM_FCNTL_TARGETS) classic/gfx/obj/.stamp-cpm

$(eval $(call gfx_stamp_portable,cpm,cpm))
$(eval $(call gfx_stamp_args,cpm-px4,TARGET=cpm SUBTYPE=px4 FLAVOUR=narrow))
$(eval $(call gfx_stamp_args,cpm-px8,TARGET=cpm SUBTYPE=px8 FLAVOUR=wide))
$(eval $(call gfx_stamp_args,cpm-v1050,TARGET=cpm FLAVOUR=wide SUBTYPE=v1050))
$(eval $(call gfx_stamp_args,cpm-v1050udg,TARGET=cpm SUBTYPE=v1050udg FLAVOUR="gencon narrow"))
$(eval $(call gfx_stamp_args,cpm-kaypro,TARGET=cpm FLAVOUR=narrow SUBTYPE=kaypro))
$(eval $(call gfx_stamp_args,cpm-kaypro83,TARGET=cpm FLAVOUR=narrow SUBTYPE=kaypro83))
$(eval $(call gfx_stamp_args,cpm-attache,TARGET=cpm FLAVOUR=wide SUBTYPE=attache))
$(eval $(call gfx_stamp_args,cpm-bondwell,TARGET=cpm FLAVOUR="gencon narrow" SUBTYPE=bondwell))
$(eval $(call gfx_stamp_args,cpm-bondwell2,TARGET=cpm FLAVOUR=wide SUBTYPE=bondwell2 TARGET_CFLAGS="-subtype=bondwell2"))
$(eval $(call gfx_stamp_args,cpm-osborne1,TARGET=cpm FLAVOUR=narrow SUBTYPE=osborne1))
$(eval $(call gfx_stamp_args,cpm-x1,TARGET=cpm FLAVOUR=wide SUBTYPE=x1))
$(eval $(call gfx_stamp_args,cpm-x820ii,TARGET=cpm FLAVOUR="narrow gencon" SUBTYPE=x820ii))
$(eval $(call gfx_stamp_args,cpm-gsx,TARGET=cpm SUBTYPE=gsx FLAVOUR=wide))
$(eval $(call gfx_stamp_args,cpm-aussie,TARGET=cpm SUBTYPE=aussie FLAVOUR=wide))
$(eval $(call gfx_stamp_args,cpm-smc777,TARGET=cpm SUBTYPE=smc777 FLAVOUR=wide))
$(eval $(call gfx_stamp_args,cpm-z80retro,TARGET=cpm FLAVOUR=narrow SUBTYPE=z80retro))
$(eval $(call gfx_stamp_args,cpm-gemini,TARGET=cpm FLAVOUR=narrow SUBTYPE=gemini))
$(eval $(call gfx_stamp_args,cpm-einstein,TARGET=cpm FLAVOUR=narrow SUBTYPE=einstein))
$(eval $(call gfx_stamp_args,cpm-nanos,TARGET=cpm FLAVOUR="narrow gencon" SUBTYPE=nanos))
$(eval $(call gfx_stamp_args,cpm-northstar,TARGET=cpm FLAVOUR=wide SUBTYPE=northstar))
$(eval $(call gfx_stamp_args,cpm-tiki100,TARGET=cpm FLAVOUR=wide SUBTYPE=tiki100))
$(eval $(call gfx_stamp_args,cpm-pcw,TARGET=cpm FLAVOUR=wide SUBTYPE=pcw))
$(eval $(call gfx_stamp_args,cpm-mbc200,TARGET=cpm FLAVOUR=wide SUBTYPE=mbc200))
$(eval $(call gfx_stamp_args,h19alt,TARGET=cpm SUBTYPE=h19alt FLAVOUR="gencon text6 narrow"))

CLEAN += target-cpm-clean

target-cpm: $(CPM_TARGETS)

.PHONY: target-cpm target-cpm-clean

define cpm_asm
target/cpm/obj/target-cpm-$(1): $(CPM_SOURCES)
	$(Q)mkdir -p target/cpm/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/cpm/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/cpm -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/cpm/def -Itarget/cpm -Itarget/cpm/obj/$(1) -I$$(Z88DK_LIBSRC)/classic $(2) -D__CLASSIC -DFORcpm $$(CPM_SOURCES)
	$$(Q)touch $$@
endef

$(foreach cpu,$(CPM_VARIANTS),$(eval $(call cpm_asm,$(cpu),$(CPM_ASMFLAGS_$(cpu)))))

define cpm_c_rule
target/cpm/obj/$(1)/%.o: target/cpm/%.c
	$(Q)mkdir -p $$(dir $$@)
	$$(ZCC) +cpm $$(CPM_CLIBFLAGS_$(1)) $$(CFLAGS) -c -o $$@ $$<
endef

$(foreach cpu,$(CPM_VARIANTS),$(eval $(call cpm_c_rule,$(cpu))))

define cpm_fcntl_rule
target/cpm/obj/$(1)/$(2)/fcntl/%.o: target/cpm/fcntl/%.c
	$(Q)mkdir -p $$(dir $$@)
	$$(ZCC) +cpm $$(CPM_CLIBFLAGS_$(1)) $$(CFLAGS) $(if $(filter device,$(2)),-DDEVICES) -c -o $$@ $$<
endef

$(foreach cpu,$(CPM_VARIANTS),$(foreach device,nodevice device,$(eval $(call cpm_fcntl_rule,$(cpu),$(device)))))

target-cpm-clean:
	$(RM) -fr target/cpm/obj
