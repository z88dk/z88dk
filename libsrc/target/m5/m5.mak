M5_GLOBS := \
	"target/m5/games/*.asm" \
	"target/m5/stdio/*.asm"

M5_GLOBS_ex := \
	target/m5/games/*.asm \
	target/m5/stdio/*.asm


M5_TARGETS := target/m5/obj/target-m5-m5 classic/video/tms9918/obj/m5 classic/games/obj/.stamp-m5 classic/gfx/obj/.stamp-m5


CLEAN += target-m5-clean
TOCREATE += $(call check_target,m5,m5_clib.lib)

$(eval $(call gfx_stamp_args,m5,TARGET=m5))
$(eval $(call buildvideo,tms9918,TMS9918,m5,))
$(eval $(call buildtargetasm,target/m5,z80,m5,-mz80,$(M5_GLOBS),$(M5_GLOBS_ex)))

m5_clib.lib: $(TARGET_CLIB_DEPS) $(M5_TARGETS)
	TARGET=m5 TYPE=z80 $(LIBLINKER) -DFORm5 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/m5_clib @$(TARGET_DIRECTORY)/m5/m5.lst


target-m5: $(M5_TARGETS)

.PHONY: target-m5 target-m5-clean



target-m5-clean:
	$(RM) -fr target/m5/obj
