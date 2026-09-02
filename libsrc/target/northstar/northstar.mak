NORTHSTAR_GLOBS := \
	"target/northstar/graphics/*.asm"

NORTHSTAR_GLOBS_ex := \
	target/northstar/graphics/*.asm


NORTHSTAR_TARGETS := target/northstar/obj/target-northstar-northstar classic/games/obj/.stamp-cpm-northstar classic/gfx/obj/.stamp-cpm-northstar


CLEAN += target-northstar-clean
northstar.lib: cpm_clib.lib $(NORTHSTAR_TARGETS)
	@echo ''
	@echo '--- Building Northstar Advantage graphics Library ---'
	@echo ''
	TARGET=northstar TYPE=z80 $(LIBLINKER) -DFORnorthstar -x$(OUTPUT_DIRECTORY)/northstar @$(TARGET_DIRECTORY)/northstar/northstar.lst

TOCREATE += $(call check_target,northstar,northstar.lib $(CPMLIBS))

target-northstar: $(NORTHSTAR_TARGETS)

.PHONY: target-northstar target-northstar-clean

$(eval $(call buildtargetasm,target/northstar,z80,northstar,-mz80,$(NORTHSTAR_GLOBS),$(NORTHSTAR_GLOBS_ex)))

target-northstar-clean:
	$(RM) -fr target/northstar/obj
