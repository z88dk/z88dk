SV8000_GLOBS := \
	"target/sv8000/games/*.asm" \
	"target/sv8000/interrupts/*.asm" \
	"target/sv8000/psg/*.asm" 

SV8000_GLOBS_ex := \
	target/sv8000/games/*.asm \
	target/sv8000/interrupts/*.asm \
	target/sv8000/psg/*.asm 


SV8000_TARGETS := target/sv8000/obj/target-sv8000-sv8000 classic/games/obj/.stamp-sv8000 classic/gfx/obj/.stamp-sv8000
		

CLEAN += target-sv8000-clean
sv8000_clib.lib: $(TARGET_CLIB_DEPS) $(SV8000_TARGETS)
	@echo ''
	@echo '--- Building Bandai Supervision 8000 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6847 TARGET=sv8000
	TARGET=sv8000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsv8000 -x$(OUTPUT_DIRECTORY)/sv8000_clib @$(TARGET_DIRECTORY)/sv8000/sv8000.lst

TOCREATE += $(call check_target,sv8000,sv8000_clib.lib)

$(eval $(call gfx_stamp_args,sv8000,TARGET=sv8000))

target-sv8000: $(SV8000_TARGETS)

.PHONY: target-sv8000 target-sv8000-clean


$(eval $(call buildtargetasm,target/sv8000,z80,sv8000,-mz80,$(SV8000_GLOBS),$(SV8000_GLOBS_ex)))

target-sv8000-clean:
	$(RM) -fr target/sv8000/obj
