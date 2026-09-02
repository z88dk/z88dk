PHC25_GLOBS := \
	"target/phc25/games/*.asm" \
	"target/phc25/graphics/*.asm" \
	"target/phc25/input/*.asm" \
	"target/phc25/interrupt/*.asm" \
	"target/phc25/psg/*.asm" \
	"target/phc25/stdio/*.asm" 

PHC25_GLOBS_ex := \
	target/phc25/games/*.asm \
	target/phc25/graphics/*.asm \
	target/phc25/input/*.asm \
	target/phc25/interrupt/*.asm \
	target/phc25/psg/*.asm \
	target/phc25/stdio/*.asm


PHC25_TARGETS := target/phc25/obj/target-phc25-phc25 classic/games/obj/.stamp-phc25 classic/gfx/obj/.stamp-phc25
		

CLEAN += target-phc25-clean
TOCREATE += $(call check_target,phc25,phc25_clib.lib)

phc25_clib.lib: $(TARGET_CLIB_DEPS) $(PHC25_TARGETS)
	$(MAKE) -C classic/video/mc6847 TARGET=phc25
	TARGET=phc25 TYPE=z80 $(LIBLINKER) -DFORphc25 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/phc25_clib @$(TARGET_DIRECTORY)/phc25/phc25.lst

$(eval $(call gfx_stamp_args,phc25,TARGET=phc25))

target-phc25: $(PHC25_TARGETS)

.PHONY: target-phc25 target-phc25-clean


$(eval $(call buildtargetasm,target/phc25,z80,phc25,-mz80,$(PHC25_GLOBS),$(MULTI8_GLOBS_ex)))

target-phc25-clean:
	$(RM) -fr target/phc25/obj
