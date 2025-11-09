
SOUND_SAA1099_GLOBS := "sound/saa1099/c/smallc/*.asm" \
		"sound/saa1099/z80/*.asm"

SOUND_SAA1099_GLOBS_ex := sound/saa1099/c/smallc/*.asm \
		sound/saa1099/z80/*.asm


SOUND_SAA1099_TARGETS := sound/saa1099/obj/newlib-z80-sound-saa1099 \
		sound/saa1099/obj/newlib-z80n-sound-saa1099 

OBJS += $(SOUND_SAA1099_TARGETS)
CLEAN += sound-saa1099-clean

sound-saa1099: $(SOUND_SAA1099_TARGETS)

.PHONY: sound-saa1099 sound-saa1099-clean


$(eval $(call buildnew,sound/saa1099,z80,-mz80,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,r2ka,-mr2ka,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,r4k,-mr4k,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,z80n,-mz80n,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,ixiy,-mz80 -IXIY,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,8080,-m8080,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,8085,-m8085,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,gbz80,-mgbz80,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,z180,-mz180,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,ez80_z80,-mez80_z80,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))
$(eval $(call buildnew,sound/saa1099,kc160,-mkc160,$(SOUND_SAA1099_GLOBS),$(SOUND_SAA1099_GLOBS_ex)))


sound-saa1099-clean:
	$(RM) -fr sound/saa1099/obj 
