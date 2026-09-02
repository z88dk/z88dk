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

$(eval $(call gfx_stamp_portable_args,pmd85,TARGET=pmd85 FLAVOUR=wide))

target-pmd85: $(PMD85_TARGETS)

.PHONY: target-pmd85 target-pmd85-clean

$(eval $(call buildtargetasm,target/pmd85,8080,pmd85,-m8080,$(PMD85_GLOBS),$(PMD85_GLOBS_ex)))

target-pmd85-clean:
	$(RM) -fr target/pmd85/obj
