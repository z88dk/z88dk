KC_GLOBS := \
	"target/kc/graphics/*.asm" \
	"target/kc/stdio/*.asm" 

KC_GLOBS_ex := \
	target/kc/graphics/*.asm \
	target/kc/stdio/*.asm 


KC_TARGETS := target/kc/obj/target-kc-kc classic/games/obj/.stamp-kc classic/gfx/obj/.stamp-kc
		

CLEAN += target-kc-clean
kc_clib.lib: $(TARGET_CLIB_DEPS) $(KC_TARGETS)
	@echo ''
	@echo '--- Building VEB Mikroelektronik KC85/2..5 Library ---'
	@echo ''
	TARGET=kc TYPE=ixiy $(LIBLINKER) -IXIY -DSTANDARDESCAPECHARS -DFORkc -x$(OUTPUT_DIRECTORY)/kc_clib @$(TARGET_DIRECTORY)/kc/kc.lst

TOCREATE += $(call check_target,kc,kc_clib.lib)

$(eval $(call gfx_stamp_portable_args,kc,TARGET=kc FLAVOUR=wide))

target-kc: $(KC_TARGETS)

.PHONY: target-kc target-kc-clean


$(eval $(call buildtargetasm,target/kc,ixiy,kc,-mz80 -IXIY,$(KC_GLOBS),$(KC_GLOBS_ex)))

target-kc-clean:
	$(RM) -fr target/kc/obj
