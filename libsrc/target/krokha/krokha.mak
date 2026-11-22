KROKHA_GLOBS := \
	"target/krokha/games/*.asm" \
	"target/krokha/graphics/*.asm" \
	"target/krokha/stdio/*.asm" 

KROKHA_GLOBS_ex := \
	target/krokha/games/*.asm \
	target/krokha/graphics/*.asm \
	target/krokha/stdio/*.asm 


KROKHA_TARGETS := target/krokha/obj/target-krokha-krokha classic/games/obj/.stamp-krokha classic/gfx/obj/.stamp-krokha
		

CLEAN += target-krokha-clean
TOCREATE += $(call check_target,krokha,krokha_clib.lib)
$(eval $(call gfx_stamp_portable_args,krokha,TARGET=krokha FLAVOUR=gencon))
$(eval $(call buildtargetasm,target/krokha,8080,krokha,-m8080,$(KROKHA_GLOBS),$(KROKHA_GLOBS_ex)))

krokha_clib.lib: $(TARGET_CLIB_DEPS) $(KROKHA_TARGETS)
	@echo ''
	@echo '--- Building Krokha (tiny) Library ---'
	@echo ''
	TARGET=krokha TYPE=8080 $(LIBLINKER) -m8080 -DFORkrokha -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/krokha_clib @$(TARGET_DIRECTORY)/krokha/krokha.lst



target-krokha: $(KROKHA_TARGETS)

.PHONY: target-krokha target-krokha-clean



target-krokha-clean:
	$(RM) -fr target/krokha/obj
