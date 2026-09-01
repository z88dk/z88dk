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
CPM_C_TARGETS := $(foreach cpu,$(CPM_VARIANTS),$(addprefix target/cpm/obj/$(cpu)/,$(CPM_NONFCNTL_CFILES:.c=.o)))
CPM_FCNTL_TARGETS := $(foreach cpu,$(CPM_VARIANTS),$(foreach device,nodevice device,$(addprefix target/cpm/obj/$(cpu)/$(device)/,$(CPM_FCNTL_CFILES:.c=.o))))

CPM_TARGETS := $(CPM_ASM_TARGETS) $(CPM_C_TARGETS) $(CPM_FCNTL_TARGETS) classic/gfx/obj/.stamp-cpm

CLEAN += target-cpm-clean

target-cpm: $(CPM_TARGETS)

.PHONY: target-cpm target-cpm-clean

define cpm_asm
target/cpm/obj/target-cpm-$(1): $(CPM_SOURCES)
	@mkdir -p target/cpm/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/cpm/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/cpm -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/cpm/def -Itarget/cpm -Itarget/cpm/obj/$(1) -I$$(Z88DK_LIBSRC)/classic $(2) -D__CLASSIC -DFORcpm $$(CPM_SOURCES)
	$$(Q)touch $$@
endef

$(foreach cpu,$(CPM_VARIANTS),$(eval $(call cpm_asm,$(cpu),$(CPM_ASMFLAGS_$(cpu)))))

define cpm_c_rule
target/cpm/obj/$(1)/target/cpm/%.o: target/cpm/%.c
	@mkdir -p $$(dir $$@)
	$$(ZCC) +cpm $$(CPM_CLIBFLAGS_$(1)) $$(CFLAGS) -c -o $$@ $$<
endef

$(foreach cpu,$(CPM_VARIANTS),$(eval $(call cpm_c_rule,$(cpu))))

define cpm_fcntl_rule
target/cpm/obj/$(1)/$(2)/target/cpm/fcntl/%.o: target/cpm/fcntl/%.c
	@mkdir -p $$(dir $$@)
	$$(ZCC) +cpm $$(CPM_CLIBFLAGS_$(1)) $$(CFLAGS) $(if $(filter device,$(2)),-DDEVICES) -c -o $$@ $$<
endef

$(foreach cpu,$(CPM_VARIANTS),$(foreach device,nodevice device,$(eval $(call cpm_fcntl_rule,$(cpu),$(device)))))

target-cpm-clean:
	$(RM) -fr target/cpm/obj
