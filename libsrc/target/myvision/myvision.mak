MYVISION_GLOBS := \
	"target/myvision/games/*.asm" \
	"target/myvision/input/*.asm" \
	"target/myvision/psg/*.asm" 

MYVISION_GLOBS_ex := \
	target/myvision/games/*.asm \
	target/myvision/input/*.asm \
	target/myvision/psg/*.asm 


MYVISION_TARGETS := target/myvision/obj/target-myvision-myvision classic/video/tms9918/obj/myvision classic/games/obj/.stamp-myvision classic/gfx/obj/.stamp-myvision
		

CLEAN += target-myvision-clean
TOCREATE += $(call check_target,myvision,myvision_clib.lib)
$(eval $(call gfx_stamp_args,myvision,TARGET=myvision))
$(eval $(call buildvideo,tms9918,TMS9918,myvision,))
$(eval $(call buildtargetasm,target/myvision,z80,myvision,-mz80,$(MYVISION_GLOBS),$(MYVISION_GLOBS_ex)))

myvision_clib.lib: $(TARGET_CLIB_DEPS) $(MYVISION_TARGETS)
	@echo ''
	@echo '--- Building Nichibutsu My Vision Library ---'
	@echo ''
	TARGET=myvision TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmyvision -x$(OUTPUT_DIRECTORY)/myvision_clib @$(TARGET_DIRECTORY)/myvision/myvision.lst



target-myvision: $(MYVISION_TARGETS)

.PHONY: target-myvision target-myvision-clean




target-myvision-clean:
	$(RM) -fr target/myvision/obj
