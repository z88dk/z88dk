NC_GLOBS := \
	"target/nc/*.asm" \
	"target/nc/fcntl/*.asm" \
	"target/nc/games/*.asm" \
	"target/nc/graphics/*.asm" \
	"target/nc/input/*.asm" \
	"target/nc/stdio/*.asm"

NC_GLOBS_ex := \
	target/nc/*.asm \
	target/nc/fcntl/*.asm \
	target/nc/games/*.asm \
	target/nc/graphics/*.asm \
	target/nc/input/*.asm \
	target/nc/stdio/*.asm

NC_CFILES := $(wildcard target/nc/fcntl/*.c)
NC_OFILES := $(patsubst target/nc/%,target/nc/obj/nc/%,$(NC_CFILES:.c=.o))

NC_TARGETS := target/nc/obj/target-nc-nc $(NC_OFILES) classic/games/obj/.stamp-nc classic/gfx/obj/.stamp-nc
NC100_TARGETS := target/nc/obj/target-nc-nc100 classic/games/obj/.stamp-nc100 classic/gfx/obj/.stamp-nc100
ZCN_TARGETS := target/nc/obj/target-nc-zcn classic/games/obj/.stamp-zcn classic/gfx/obj/.stamp-zcn
NC200_TARGETS := target/nc/obj/target-nc-nc200 classic/games/obj/.stamp-nc200 classic/gfx/obj/.stamp-nc200

CLEAN += target-nc-clean
TOCREATE += $(call check_target,nc,nc_clib.lib gfxnc100.lib gfxzcn.lib gfxnc200.lib)
$(eval $(call gfx_stamp_args,nc,TARGET=nc))
$(eval $(call gfx_stamp_args,nc100,TARGET=nc FLAVOUR=wide SUBTYPE=nc100))
$(eval $(call gfx_stamp_args,zcn,TARGET=nc FLAVOUR=wide SUBTYPE=zcn))
$(eval $(call gfx_stamp_args,nc200,TARGET=nc FLAVOUR=wide SUBTYPE=nc200))
define nc_asm
target/nc/obj/target-nc-$(1): $(NC_GLOBS_ex)
	$(Q)mkdir -p target/nc/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/nc/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/nc -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/nc/def -Itarget/nc -Itarget/nc/obj/$(1) -I$$(Z88DK_LIBSRC)/classic -mz80 $(2) -I$$(Z88DK_LIB) -DSTANDARDESCAPECHARS -D__CLASSIC $$(NC_GLOBS)
	$$(Q)touch $$@
endef
$(eval $(call nc_asm,nc,-DFORnc))
$(eval $(call nc_asm,nc100,-DFORnc -DFORnc100))
$(eval $(call nc_asm,zcn,-DFORnc -DFORnc100 -DFORzcn))
$(eval $(call nc_asm,nc200,-DFORnc -DFORnc200))
$(eval $(call buildtargetc,target/nc,nc))

nc_clib.lib: $(TARGET_CLIB_DEPS) $(NC_TARGETS)
	@echo ''
	@echo '--- Building Amstrad NC Library ---'
	@echo ''
	TARGET=nc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnc -x$(OUTPUT_DIRECTORY)/nc_clib @$(TARGET_DIRECTORY)/nc/nc.lst

gfxnc100.lib: $(TARGET_CLIB_DEPS) nc_clib.lib $(NC100_TARGETS)
	@echo ''
	@echo '--- Building NC-100 Graphics Library ---'
	@echo ''
	TARGET=nc100 TYPE=z80 $(LIBLINKER) -DFORnc100 -x$(OUTPUT_DIRECTORY)/gfxnc100 @$(TARGET_DIRECTORY)/nc/gfxnc.lst

gfxzcn.lib: $(TARGET_CLIB_DEPS) gfxnc100.lib $(ZCN_TARGETS)
	@echo ''
	@echo '--- Building NC-100 Graphics Library (ZCN)---'
	@echo ''
	TARGET=zcn TYPE=z80 $(LIBLINKER) -DFORnc100 -DFORzcn -x$(OUTPUT_DIRECTORY)/gfxzcn @$(TARGET_DIRECTORY)/nc/gfxnc.lst

gfxnc200.lib: $(TARGET_CLIB_DEPS) gfxzcn.lib $(NC200_TARGETS)
	@echo ''
	@echo '--- Building NC-200 Graphics Library ---'
	@echo ''
	TARGET=nc200 TYPE=z80 $(LIBLINKER) -DFORnc200 -x$(OUTPUT_DIRECTORY)/gfxnc200 @$(TARGET_DIRECTORY)/nc/gfxnc.lst



target-nc: $(NC_TARGETS) $(NC100_TARGETS) $(ZCN_TARGETS) $(NC200_TARGETS)

.PHONY: target-nc target-nc-clean




target-nc-clean:
	$(RM) -fr target/nc/obj
