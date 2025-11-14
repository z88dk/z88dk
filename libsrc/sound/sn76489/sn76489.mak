

SOUND_SN76489_GLOBS := "sound/sn76489/z80/*.asm" \
		"sound/sn76489/c/sccz80/*.asm" \
		"sound/sn76489/c/smallc/*.asm" 

SOUND_SN76489_GLOBS_ex := sound/sn76489/z80/*.asm \
		sound/sn76489/c/sccz80/*.asm \
		sound/sn76489/c/smallc/*.asm


SOUND_SN76489_TARGETS := sound/sn76489/obj/newlib-z80-sound-sn76489 \
		sound/sn76489/obj/newlib-z80n-sound-sn76489 \
		sound/sn76489/obj/newlib-ixiy-sound-sn76489 \
		sound/sn76489/obj/newlib-z80_latch-sound-sn76489 \
		sound/sn76489/obj/newlib-z80n_latch-sound-sn76489 \
		sound/sn76489/obj/newlib-ixiy_latch-sound-sn76489 \
		sound/sn76489/obj/newlib-z80_16bit-sound-sn76489 \
		sound/sn76489/obj/newlib-z80n_16bit-sound-sn76489 \
		sound/sn76489/obj/newlib-ixiy_16bit-sound-sn76489

OBJS += $(SOUND_SN76489_TARGETS)
CLEAN += sound-sn76489-clean

sound-sn76489: $(SOUND_SN76489_TARGETS)

.PHONY: sound-sn76489 sound-sn76489-clean

$(eval $(call buildnew,sound/sn76489,z80,-mz80,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,z80n,-mz80n,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,ixiy,-mz80 -IXIY,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,z180,-mz180,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,ez80_z80,-mez80_z80,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,kc160,-mkc160,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))

$(eval $(call buildnew,sound/sn76489,z80_latch,-mz80 -DSN76489_HAS_LATCH_PORT,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,z80n_latch,-mz80n -DSN76489_HAS_LATCH_PORT,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,ixiy_latch,-mz80 -IXIY -DSN76489_HAS_LATCH_PORT,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,z180_latch,-mz180 -DSN76489_HAS_LATCH_PORT,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,ez80_z80_latch,-mez80_z80 -DSN76489_HAS_LATCH_PORT,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,kc160_latch,-mkc160 -DSN76489_HAS_LATCH_PORT,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))

$(eval $(call buildnew,sound/sn76489,z80_16bit,-mz80 -DSN76489_HAS_16BIT_IO,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,z80n_16bit,-mz80n -DSN76489_HAS_16BIT_IO,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,ixiy_16bit,-mz80 -IXIY -DSN76489_HAS_16BIT_IO,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,z180_16bit,-mz180 --DSN76489_HAS_16BIT_IO,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,ez80_z80_16bit,-mez80_z80 -DSN76489_HAS_16BIT_IO,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))
$(eval $(call buildnew,sound/sn76489,kc160_16bit,-mkc160 -DSN76489_HAS_16BIT_IO,$(SOUND_SN76489_GLOBS),$(SOUND_SN76489_GLOBS_ex)))

sound-sn76489-clean:
	$(RM) -fr sound/sn76489/obj 
