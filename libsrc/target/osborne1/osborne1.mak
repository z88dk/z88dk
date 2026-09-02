OSBORNE1_GLOBS := \
	"target/osborne1/graphics/*.asm"

OSBORNE1_GLOBS_ex := \
	target/osborne1/graphics/*.asm


OSBORNE1_TARGETS := target/osborne1/obj/target-osborne1-osborne1 classic/gfx/obj/.stamp-cpm-osborne1


CLEAN += target-osborne1-clean
gfxosborne1.lib: cpm_clib.lib $(TARGET_CLIB_DEPS) $(OSBORNE1_TARGETS)
	@echo ''
	@echo '--- Building Osborne 1 graphics Library ---'
	@echo ''
	TARGET=osborne1 TYPE=z80 $(LIBLINKER) -DFORosborne1 -x$(OUTPUT_DIRECTORY)/gfxosborne1 @$(TARGET_DIRECTORY)/osborne1/gfxosborne1.lst

TOCREATE += $(call check_target,osborne,gfxosborne1.lib $(CPMLIBS))

target-osborne1: $(OSBORNE1_TARGETS)

.PHONY: target-osborne1 target-osborne1-clean

$(eval $(call buildtargetasm,target/osborne1,z80,osborne1,-mz80,$(OSBORNE1_GLOBS),$(OSBORNE1_GLOBS_ex)))

target-osborne1-clean:
	$(RM) -fr target/osborne1/obj
