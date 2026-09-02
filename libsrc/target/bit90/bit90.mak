BIT90_GLOBS := \
	"target/bit90/games/*.asm"

BIT90_GLOBS_ex := \
	target/bit90/games/*.asm


BIT90_TARGETS := target/bit90/obj/target-bit90-bit90 classic/games/obj/.stamp-cpm-bit90


CLEAN += target-bit90-clean
bit90.lib: coleco_clib.lib $(BIT90_TARGETS)
	@echo ''
	@echo '--- Building Bit-90 Library ---'
	@echo ''
	TARGET=bit90 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -DFORbit90 -x$(OUTPUT_DIRECTORY)/bit90 @$(TARGET_DIRECTORY)/bit90/bit90.lst

TOCREATE += $(call check_target,bit90,bit90.lib coleco_clib.lib)

target-bit90: $(BIT90_TARGETS)

.PHONY: target-bit90 target-bit90-clean

$(eval $(call buildtargetasm,target/bit90,z80,bit90,-mz80,$(BIT90_GLOBS),$(BIT90_GLOBS_ex)))

target-bit90-clean:
	$(RM) -fr target/bit90/obj
