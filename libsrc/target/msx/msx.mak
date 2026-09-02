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

$(eval $(call gfx_stamp_args,msx,TARGET=msx))

target-msx: $(MSX_TARGETS)

.PHONY: target-msx target-msx-clean

classic/video/tms9918/obj/msx:
	$(Q)$(MAKE) -C classic/video/tms9918 TARGET=msx

classic/video/tms9918/obj/msx2:
	$(Q)$(MAKE) -C classic/video/tms9918 TARGET=msx SUBTYPE=msx2

$(eval $(call buildtargetasm,target/msx,z80,msx,-mz80,$(MSX_GLOBS),$(MSX_GLOBS_ex)))

target/msx/obj/target-msx-support: target/msx/obj/target-msx-msx
	$(Q)mkdir -p $(dir $@)
	$(MAKE) -C target/msx/asmlib
	$(MAKE) -C target/msx/msxbios
	$(MAKE) -C target/msx/fcntl
	@touch $@

target-msx-clean:
	$(RM) -fr target/msx/obj target/msx/asmlib/obj target/msx/msxbios/obj target/msx/fcntl/obj
