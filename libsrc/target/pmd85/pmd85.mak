PMD85_GLOBS := \
	"target/pmd85/games/*.asm" \
	"target/pmd85/graphics/*.asm" \
	"target/pmd85/stdio/*.asm"

PMD85_GLOBS_ex := \
	target/pmd85/games/*.asm \
	target/pmd85/graphics/*.asm \
	target/pmd85/stdio/*.asm


PMD85_TARGETS := target/pmd85/obj/target-pmd85-pmd85 classic/games/obj/.stamp-pmd85 classic/gfx/obj/.stamp-pmd85


CLEAN += target-pmd85-clean
TOCREATE += $(call check_target,pmd85,pmd85_clib.lib)

$(eval $(call gfx_stamp_portable_args,pmd85,TARGET=pmd85 FLAVOUR=wide))
$(eval $(call buildtargetasm,target/pmd85,8080,pmd85,-m8080,$(PMD85_GLOBS),$(PMD85_GLOBS_ex)))

pmd85_clib.lib: $(TARGET_CLIB_DEPS) $(PMD85_TARGETS)
	TARGET=pmd85 TYPE=8080 $(LIBLINKER) -m8080 -DFORpmd85 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pmd85_clib @$(TARGET_DIRECTORY)/pmd85/pmd85.lst


target-pmd85: $(PMD85_TARGETS)

.PHONY: target-pmd85 target-pmd85-clean


target-pmd85-clean:
	$(RM) -fr target/pmd85/obj
