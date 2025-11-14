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


SMS_TARGETS := target/sms/obj/target-sms-sms 
		

CLEAN += target-sms-clean

target-sms: $(SMS_TARGETS)

.PHONY: target-sms target-sms-clean


$(eval $(call buildtargetasm,target/sms,z80,sms,-mz80,$(SMS_GLOBS),$(SMS_GLOBS_ex)))

target-sms-clean:
	$(RM) -fr target/sms/obj
