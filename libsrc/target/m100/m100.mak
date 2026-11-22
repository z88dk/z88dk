M100_GLOBS := \
	"target/m100/graphics/*.asm" \
	"target/m100/stdio/*.asm"

M100_GLOBS_ex := \
	target/m100/graphics/*.asm \
	target/m100/stdio/*.asm


M100_TARGETS := target/m100/obj/target-m100-m100 classic/games/obj/.stamp-m100 classic/gfx/obj/.stamp-m100


CLEAN += target-m100-clean
TOCREATE += $(call check_target,m100,m100_clib.lib)
$(eval $(call gfx_stamp_args,m100,TARGET=m100 FLAVOUR=narrow))
$(eval $(call buildtargetasm,target/m100,8085,m100,-m8085,$(M100_GLOBS),$(M100_GLOBS_ex)))

m100_clib.lib: $(TARGET_CLIB_DEPS) $(M100_TARGETS)
	@echo ''
	@echo '--- Building m100 Library ---'
	@echo ''
	TARGET=m100 TYPE=8085 $(LIBLINKER) -m8085 -DFORm100 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/m100_clib @$(TARGET_DIRECTORY)/m100/m100.lst



target-m100: $(M100_TARGETS)

.PHONY: target-m100 target-m100-clean


target-m100-clean:
	$(RM) -fr target/m100/obj
