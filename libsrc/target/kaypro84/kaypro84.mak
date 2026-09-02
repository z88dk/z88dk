KAYPRO84_GLOBS := \
	"target/kaypro84/graphics/*.asm"

KAYPRO84_GLOBS_ex := \
	target/kaypro84/graphics/*.asm


KAYPRO84_TARGETS := target/kaypro84/obj/target-kaypro84-kaypro84 classic/gfx/obj/.stamp-cpm-kaypro


CLEAN += target-kaypro84-clean
gfxkp.lib: cpm_clib.lib $(TARGET_CLIB_DEPS) $(KAYPRO84_TARGETS)
	@echo ''
	@echo '--- Building Kaypro graphics Library ---'
	@echo ''
	TARGET=kaypro TYPE=z80 $(LIBLINKER) -DFORkaypro -x$(OUTPUT_DIRECTORY)/gfxkp @$(TARGET_DIRECTORY)/kaypro84/gfxkp.lst

TOCREATE += $(call check_target,kaypro,gfxkp.lib $(CPMLIBS))

target-kaypro84: $(KAYPRO84_TARGETS)

.PHONY: target-kaypro84 target-kaypro84-clean

$(eval $(call buildtargetasm,target/kaypro84,z80,kaypro84,-mz80,$(KAYPRO84_GLOBS),$(KAYPRO84_GLOBS_ex)))

target-kaypro84-clean:
	$(RM) -fr target/kaypro84/obj
