APPLE2_GLOBS := \
	"target/apple2/*.asm" \
	"target/apple2/stdio/*.asm" 

APPLE2_GLOBS_ex := \
	target/apple2/*.asm \
	target/apple2/stdio/*.asm 


APPLE2_TARGETS := target/apple2/obj/target-apple2-apple2 classic/games/obj/.stamp-cpm-apple2
		

CLEAN += target-apple2-clean
apple2.lib: cpm_clib.lib $(APPLE2_TARGETS)
	@echo ''
	@echo '--- Building Apple II SoftCard Library ---'
	@echo ''
	TARGET=apple2 TYPE=z80 $(LIBLINKER) -DFORapple2 -x$(OUTPUT_DIRECTORY)/apple2 @$(TARGET_DIRECTORY)/apple2/apple2.lst

TOCREATE += $(call check_target,apple2,apple2.lib $(CPMLIBS))

target-apple2: $(APPLE2_TARGETS)

.PHONY: target-apple2 target-apple2-clean


$(eval $(call buildtargetasm,target/apple2,z80,apple2,-mz80,$(APPLE2_GLOBS),$(APPLE2_GLOBS_ex)))

target-apple2-clean:
	$(RM) -fr target/apple2/obj
