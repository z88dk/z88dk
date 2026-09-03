CPMLIBS = cpm_clib.lib cpmixiy_clib.lib cpmz180_clib.lib cpm8080_clib.lib cpm8085_clib.lib cpmdevice.lib cpmdevice_8080.lib cpmdevice_8085.lib cpmdevice_z180.lib gfxh19.lib gfxh19alt.lib gfxvio.lib gfxgsx.lib

CPM_SOURCES := $(wildcard target/cpm/*/*.asm)
CPM_CFILES := $(wildcard target/cpm/*/*.c)
CPM_FCNTL_CFILES := $(wildcard target/cpm/fcntl/*.c)
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
TOCREATE += $(call check_target,cpm,$(CPMLIBS))
TOCREATE += $(call check_target,mbc200,mbc200.lib $(CPMLIBS))
TOCREATE += $(call check_target,tiki100,tiki100.lib $(CPMLIBS))
TOCREATE += $(call check_target,v1050,v1050.lib gfx1050udg.lib $(CPMLIBS))
TOCREATE += $(call check_target,z80retro,z80retro_cpm.lib)
define cpm_asm
target/cpm/obj/target-cpm-$(1): $(CPM_SOURCES)
	$(Q)mkdir -p target/cpm/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/cpm/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/cpm -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/cpm/def -Itarget/cpm -Itarget/cpm/obj/$(1) -I$$(Z88DK_LIBSRC)/classic $(2) -DSTANDARDESCAPECHARS -D__CLASSIC -DFORcpm $$(CPM_SOURCES)
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

v1050.lib: cpm_clib.lib gfx1050udg.lib classic/games/obj/.stamp-cpm-v1050 classic/gfx/obj/.stamp-cpm-v1050
	@echo ''
	@echo '--- Building Visual 1050 Library (CP/M) ---'
	@echo ''
	TARGET=v1050 TYPE=z80 $(LIBLINKER) -DFORv1050 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/v1050.lib @$(TARGET_DIRECTORY)/v1050/v1050.lst

gfx1050udg.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-cpm-v1050udg
	@echo ''
	@echo '--- Building Visual 1050 UDG based Graphics Library ---'
	@echo ''
	TARGET=v1050udg TYPE=z80 $(LIBLINKER) -DFORv1050udg -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gfx1050udg.lib @$(TARGET_DIRECTORY)/v1050/gfx1050udg.lst

gfxgsx.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-cpm-gsx
	@echo ''
	@echo '--- Building GSX based Z88DK GFX Library ---'
	@echo ''
	TARGET=gsx TYPE=z80 $(LIBLINKER) -DFORcpm -DFORgsx -x$(OUTPUT_DIRECTORY)/gfxgsx @$(TARGET_DIRECTORY)/cpm/gfxgsx.lst
	@touch $@

cpm_clib.lib: $(TARGET_CLIB_DEPS) $(CPM_TARGETS)
	@echo ''
	@echo '--- Building CP/M Library ---'
	@echo ''
	TARGET=cpm TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm_clib @$(TARGET_DIRECTORY)/cpm/cpm.lst

cpmdevice.lib: cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Device fnctl Library ---'
	@echo ''
	TARGET=cpm TYPE=z80 DEVICE=device $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpmdevice @$(TARGET_DIRECTORY)/cpm/fcntl/fcntl.lst

cpm8080_clib.lib: $(TARGET_CLIB_DEPS) cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Library (8080)---'
	@echo ''
	TARGET=cpm TYPE=8080 DEVICE=nodevice $(LIBLINKER) -m8080 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm8080_clib @$(TARGET_DIRECTORY)/cpm/cpm_8080.lst

cpmdevice_8080.lib: cpm8080_clib.lib
	@echo ''
	@echo '--- Building CP/M Device fnctl Library (8080) ---'
	@echo ''
	TARGET=cpm TYPE=8080 DEVICE=device $(LIBLINKER) -m8080 -x$(OUTPUT_DIRECTORY)/cpmdevice_8080 @$(TARGET_DIRECTORY)/cpm/fcntl/fcntl.lst

cpm8085_clib.lib: $(TARGET_CLIB_DEPS) cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Library (8085)---'
	@echo ''
	TARGET=cpm TYPE=8085 DEVICE=nodevice $(LIBLINKER) -m8085 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm8085_clib @$(TARGET_DIRECTORY)/cpm/cpm_8080.lst

cpmdevice_8085.lib: cpm8085_clib.lib
	@echo ''
	@echo '--- Building CP/M Device fnctl Library (8085) ---'
	@echo ''
	TARGET=cpm TYPE=8085 DEVICE=device $(LIBLINKER) -m8085 -x$(OUTPUT_DIRECTORY)/cpmdevice_8085 @$(TARGET_DIRECTORY)/cpm/fcntl/fcntl.lst

cpmixiy_clib.lib: $(TARGET_CLIB_DEPS) cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Library (IXIY)---'
	@echo ''
	TARGET=cpm TYPE=ixiy DEVICE=nodevice $(LIBLINKER) -IXIY -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpmixiy_clib @$(TARGET_DIRECTORY)/cpm/cpm.lst

cpmz180_clib.lib: $(TARGET_CLIB_DEPS) cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Library (z180)---'
	@echo ''
	TARGET=cpm TYPE=z180 DEVICE=nodevice $(LIBLINKER) -mz180 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpmz180_clib @$(TARGET_DIRECTORY)/cpm/cpm.lst

cpmdevice_z180.lib: cpmz180_clib.lib
	@echo ''
	@echo '--- Building CP/M Device fnctl Library (z180) ---'
	@echo ''
	TARGET=cpm TYPE=z180 DEVICE=device $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/cpmdevice_z180 @$(TARGET_DIRECTORY)/cpm/fcntl/fcntl.lst

mbc200.lib: cpm_clib.lib classic/games/obj/.stamp-cpm-mbc200 classic/gfx/obj/.stamp-cpm-mbc200
	@echo ''
	@echo '--- Building Sanyo MBC-200 Library (CP/M) ---'
	@echo ''
	TARGET=mbc200 TYPE=z80 $(LIBLINKER) -DFORmbc200 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/mbc200.lib @$(TARGET_DIRECTORY)/mbc200/mbc200.lst

z80retro_cpm.lib: cpm_clib.lib classic/games/obj/.stamp-cpm-z80retro classic/gfx/obj/.stamp-cpm-z80retro
	@echo ''
	@echo '--- Building z80retro! CP/M Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=cpm SUBTYPE=z80retro
	TARGET=z80retro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz80retro -x$(OUTPUT_DIRECTORY)/z80retro_cpm @$(TARGET_DIRECTORY)/z80retro/z80retro.lst

tiki100.lib: cpm_clib.lib classic/games/obj/.stamp-cpm-tiki100 classic/gfx/obj/.stamp-cpm-tiki100
	@echo ''
	@echo '--- Building TIKI-100 Library ---'
	@echo ''
	TARGET=tiki100 TYPE=z80 $(LIBLINKER) -DFORtiki100 -x$(OUTPUT_DIRECTORY)/tiki100 @$(TARGET_DIRECTORY)/tiki100/tiki100.lst

gfxh19.lib:  $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-h19 classic/gfx/obj/.stamp-h19alt
	TARGET=h19 TYPE=z80 $(LIBLINKER) -DFORh19 -x$(OUTPUT_DIRECTORY)/gfxh19 @$(Z88DK_LIBSRC)/classic/video/h19/gfxh19.lst
	@touch $@

gfxh19alt.lib:  $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-h19 classic/gfx/obj/.stamp-h19alt
	TARGET=h19alt TYPE=z80 $(LIBLINKER) -DFORh19alt -x$(OUTPUT_DIRECTORY)/gfxh19alt @$(Z88DK_LIBSRC)/classic/video/h19/gfxh19alt.lst
	@touch $@


target-cpm: $(CPM_TARGETS)

.PHONY: target-cpm target-cpm-clean







target-cpm-clean:
	$(RM) -fr target/cpm/obj
