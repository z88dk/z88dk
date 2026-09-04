MSX_GLOBS := \
	"target/msx/*.asm" \
	"target/msx/far/*.asm" \
	"target/msx/fcntl/msxdos1/*.asm" \
	"target/msx/games/*.asm" \
	"target/msx/psg/*.asm" \
	"target/msx/stdio/*.asm" \
	"target/msx/time/*.asm"

MSX_GLOBS_ex := \
	target/msx/*.asm \
	target/msx/far/*.asm \
	target/msx/fcntl/msxdos1/*.asm \
	target/msx/games/*.asm \
	target/msx/psg/*.asm \
	target/msx/stdio/*.asm \
	target/msx/time/*.asm

MSX_TARGETS := \
	target/msx/obj/target-msx-msx \
	target/msx/obj/target-msx-support \
	classic/video/tms9918/obj/msx \
	classic/games/obj/.stamp-msx \
	classic/gfx/obj/.stamp-msx

MSX2_TARGETS := $(MSX_TARGETS) classic/video/tms9918/obj/msx2

CLEAN += target-msx-clean
TOCREATE += $(call check_target,msx,msx_clib.lib msx2.lib msxbios.lib cpm_msx.lib)
$(eval $(call gfx_stamp_args,msx,TARGET=msx))
$(eval $(call buildvideo,tms9918,TMS9918,msx,))
$(eval $(call buildvideo,tms9918,TMS9918,msx,msx2))
$(eval $(call buildtargetasm,target/msx,z80,msx,-mz80,$(MSX_GLOBS),$(MSX_GLOBS_ex)))

msx_clib.lib: $(TARGET_CLIB_DEPS) $(MSX_TARGETS)
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msx_clib @$(TARGET_DIRECTORY)/msx/msx.lst

msxbios.lib: $(TARGET_CLIB_DEPS) $(MSX_TARGETS)
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msxbios @$(TARGET_DIRECTORY)/msx/arch_msxbios.lst

cpm_msx.lib: $(TARGET_CLIB_DEPS) $(MSX_TARGETS)
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/cpm_msx @$(TARGET_DIRECTORY)/msx/cpm_msx.lst

msx2.lib: $(TARGET_CLIB_DEPS) $(MSX2_TARGETS)
	TARGET=msx2 TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx2 -x$(OUTPUT_DIRECTORY)/msx2 @$(TARGET_DIRECTORY)/msx/msx2.lst



target-msx: $(MSX_TARGETS)

.PHONY: target-msx target-msx-clean

target/msx/obj/target-msx-support: target/msx/obj/target-msx-msx
	$(Q)mkdir -p $(dir $@)
	$(MAKE) -C target/msx/asmlib
	$(MAKE) -C target/msx/msxbios
	$(MAKE) -C target/msx/fcntl
	@touch $@

target-msx-clean:
	$(RM) -fr target/msx/obj target/msx/asmlib/obj target/msx/msxbios/obj target/msx/fcntl/obj
