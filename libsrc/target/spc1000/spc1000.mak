SPC1000_GLOBS := \
	"target/spc1000/*.asm" \
	"target/spc1000/games/*.asm" \
	"target/spc1000/graphics/*.asm" \
	"target/spc1000/input/*.asm" \
	"target/spc1000/psg/*.asm" \
	"target/spc1000/stdio/*.asm" 

SPC1000_GLOBS_ex := \
	target/spc1000/*.asm \
	target/spc1000/games/*.asm \
	target/spc1000/graphics/*.asm \
	target/spc1000/input/*.asm \
	target/spc1000/psg/*.asm \


SPC1000_TARGETS := target/spc1000/obj/target-spc1000-spc1000 classic/video/tms9918/obj/spc1000 classic/video/mc6847/obj/spc1000 classic/games/obj/.stamp-spc1000 classic/gfx/obj/.stamp-spc1000
		

CLEAN += target-spc1000-clean
spc1000_clib.lib: $(TARGET_CLIB_DEPS) $(SPC1000_TARGETS)
	@echo ''
	@echo '--- Building Samsung SPC-1000 Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=spc1000
	$(MAKE) -C classic/video/mc6847 TARGET=spc1000
	TARGET=spc1000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORspc1000 -x$(OUTPUT_DIRECTORY)/spc1000_clib @$(TARGET_DIRECTORY)/spc1000/spc1000.lst

TOCREATE += $(call check_target,spc1000,spc1000_clib.lib)

$(eval $(call gfx_stamp_args,spc1000,TARGET=spc1000))

target-spc1000: $(SPC1000_TARGETS)

.PHONY: target-spc1000 target-spc1000-clean

$(eval $(call buildtms9918,spc1000,spc1000))

classic/video/mc6847/obj/spc1000:
	$(Q)$(MAKE) -C classic/video/mc6847 TARGET=spc1000


$(eval $(call buildtargetasm,target/spc1000,ez80,spc1000,-mz80,$(SPC1000_GLOBS),$(SPC1000_GLOBS_ex)))

target-spc1000-clean:
	$(RM) -fr target/spc1000/obj
