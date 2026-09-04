RC700_GLOBS := \
	"target/rc700/*.asm" \
	"target/rc700/graphics/*.asm" \
	"target/rc700/time/*.asm" 

RC700_GLOBS_ex := \
	target/rc700/*.asm \
	target/rc700/graphics/*.asm \
	target/rc700/time/*.asm 


RC700_TARGETS := target/rc700/obj/target-rc700-rc700 classic/games/obj/.stamp-cpm-rc700 classic/gfx/obj/.stamp-cpm-rc700
		

CLEAN += target-rc700-clean
TOCREATE += $(call check_target,rc700,rc700.lib $(CPMLIBS))
$(eval $(call gfx_stamp_portable_args,cpm-rc700,TARGET=cpm SUBTYPE=rc700 FLAVOUR="narrow gencon"))
$(eval $(call buildtargetasm,target/rc700,z80,rc700,-mz80,$(RC700_GLOBS),$(RC700_GLOBS_ex)))

rc700.lib: cpm_clib.lib $(RC700_TARGETS)
	@echo ''
	@echo '--- Building RC-700 Library ---'
	@echo ''
	TARGET=rc700 TYPE=z80 $(LIBLINKER) -DFORrc700 -x$(OUTPUT_DIRECTORY)/rc700 @$(TARGET_DIRECTORY)/rc700/rc700.lst



target-rc700: $(RC700_TARGETS)

.PHONY: target-rc700 target-rc700-clean



target-rc700-clean:
	$(RM) -fr target/rc700/obj
