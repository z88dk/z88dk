X820_GLOBS := \
	"target/x820/graphics/*.asm" \
	"target/x820/stdio/*.asm"

X820_GLOBS_ex := \
	target/x820/graphics/*.asm \
	target/x820/stdio/*.asm


X820_TARGETS := target/x820/obj/target-x820-x820 classic/games/obj/.stamp-cpm-x820ii classic/gfx/obj/.stamp-cpm-x820ii


CLEAN += target-x820-clean
TOCREATE += $(call check_target,x820ii,x820ii.lib $(CPMLIBS))
$(eval $(call buildtargetasm,target/x820,z80,x820,-mz80,$(X820_GLOBS),$(X820_GLOBS_ex)))

x820ii.lib: cpm_clib.lib $(X820_TARGETS)
	@echo ''
	@echo '--- Building Xerox 820 II Library ---'
	@echo ''
	TARGET=x820ii TYPE=z80 $(LIBLINKER) -DFORx820ii -x$(OUTPUT_DIRECTORY)/x820ii.lib @$(TARGET_DIRECTORY)/x820/x820ii.lst


target-x820: $(X820_TARGETS)

.PHONY: target-x820 target-x820-clean


target-x820-clean:
	$(RM) -fr target/x820/obj
