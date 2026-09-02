ATTACHE_GLOBS := \
	"target/attache/bios/*.asm" \
	"target/attache/graphics/*.asm" \
	"target/attache/psg/*.asm" \
	"target/attache/time/*.asm" 

ATTACHE_GLOBS_ex := \
	target/attache/bios/*.asm \
	target/attache/graphics/*.asm \
	target/attache/psg/*.asm \
	target/attache/time/*.asm


ATTACHE_TARGETS := target/attache/obj/target-attache-attache classic/games/obj/.stamp-cpm-attache classic/gfx/obj/.stamp-cpm-attache
		

CLEAN += target-attache-clean
attache.lib: cpm_clib.lib $(ATTACHE_TARGETS)
	@echo ''
	@echo '--- Building Otrona Attache Library ---'
	@echo ''
	TARGET=attache TYPE=z80 $(LIBLINKER) -DFORattache -x$(OUTPUT_DIRECTORY)/attache @$(TARGET_DIRECTORY)/attache/attache.lst

TOCREATE += $(call check_target,attache,attache.lib $(CPMLIBS))

target-attache: $(ATTACHE_TARGETS)

.PHONY: target-attache target-attache-clean


$(eval $(call buildtargetasm,target/attache,z80,attache,-mz80,$(ATTACHE_GLOBS),$(ATTACHE_GLOBS_ex)))

target-attache-clean:
	$(RM) -fr target/attache/obj
