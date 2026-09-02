PCW_GLOBS := \
	"target/pcw/far/*.asm" \
	"target/pcw/graphics/*.asm" \
	"target/pcw/psg/*.asm"

PCW_GLOBS_ex := \
	target/pcw/far/*.asm \
	target/pcw/graphics/*.asm \
	target/pcw/psg/*.asm


PCW_TARGETS := target/pcw/obj/target-pcw-pcw classic/games/obj/.stamp-cpm-pcw classic/gfx/obj/.stamp-cpm-pcw


CLEAN += target-pcw-clean
pcw.lib: cpm_clib.lib $(PCW_TARGETS)
	@echo ''
	@echo '--- Building Amstrad PCW Library ---'
	@echo ''
	TARGET=pcw TYPE=z80 $(LIBLINKER) -DFORpcw -x$(OUTPUT_DIRECTORY)/pcw @$(TARGET_DIRECTORY)/pcw/pcw.lst

TOCREATE += $(call check_target,pcw,pcw.lib $(CPMLIBS))

target-pcw: $(PCW_TARGETS)

.PHONY: target-pcw target-pcw-clean

$(eval $(call buildtargetasm,target/pcw,z80,pcw,-mz80,$(PCW_GLOBS),$(PCW_GLOBS_ex)))

target-pcw-clean:
	$(RM) -fr target/pcw/obj
