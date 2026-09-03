# +sms builds heavily on +zx
SMS_GLOBS := \
	"target/sms/classic/*.asm" \
	"target/sms/classic/games/*.asm" \
	"target/sms/classic/stdio/*.asm" \
	"target/sms/SMSlib/c/sccz80/*.asm" "target/sms/SMSlib/z80/*.asm" \
	"target/sms/globals/z80/*.asm" \
	"target/sms/registers/z80/*.asm" \
	"target/sms/misc/c/sccz80/*.asm" "target/sms/misc/z80/*.asm" \
	"target/sms/psg/c/sccz80/*.asm" "target/sms/psg/z80/*.asm" \
	"target/sms/vdp/c/sccz80/*.asm" "target/sms/vdp/z80/*.asm" \
	"target/sms/vram/c/sccz80/*.asm" "target/sms/vram/z80/*.asm" 

SMS_GLOBS_ex := \
	target/sms/classic/*.asm \
	target/sms/classic/games/*.asm \
	target/sms/classic/stdio/*.asm \
	target/sms/SMSlib/c/sccz80/*.asm target/sms/SMSlib/z80/*.asm \
	target/sms/globals/z80/*.asm \
	target/sms/registers/z80/*.asm \
	target/sms/misc/c/sccz80/*.asm target/sms/misc/z80/*.asm \
	target/sms/psg/c/sccz80/*.asm target/sms/psg/z80/*.asm \
	target/sms/vdp/c/sccz80/*.asm target/sms/vdp/z80/*.asm \
	target/sms/vram/c/sccz80/*.asm target/sms/vram/z80/*.asm 


SMS_TARGETS := target/sms/obj/target-sms-sms classic/video/tms9918/obj/sms classic/games/obj/.stamp-sms classic/gfx/obj/.stamp-sms
		

CLEAN += target-sms-clean
TOCREATE += $(call check_target,sms,sms_clib.lib)

$(eval $(call gfx_stamp_args,sms,TARGET=sms))
$(eval $(call buildvideo,tms9918,TMS9918,sms,))
$(eval $(call buildtargetasm,target/sms,z80,sms,-mz80,$(SMS_GLOBS),$(SMS_GLOBS_ex)))

sms_clib.lib: $(TARGET_CLIB_DEPS) $(SMS_TARGETS)
	TARGET=sms TYPE=z80 $(LIBLINKER) -DFORsms -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sms_clib @$(TARGET_DIRECTORY)/sms/sms.lst


target-sms: $(SMS_TARGETS)

.PHONY: target-sms target-sms-clean




target-sms-clean:
	$(RM) -fr target/sms/obj
