SC3000_GLOBS := \
	"target/sc3000/games/*.asm" \
	"target/sc3000/input/*.asm" \
	"target/sc3000/stdio/*.asm" \
	"target/sc3000/time/*.asm" 

SC3000_GLOBS_ex := \
	target/sc3000/games/*.asm \
	target/sc3000/input/*.asm \
	target/sc3000/stdio/*.asm \
	target/sc3000/time/*.asm 


SC3000_TARGETS := target/sc3000/obj/target-sc3000-sc3000 classic/video/tms9918/obj/sc3000 classic/games/obj/.stamp-sc3000 classic/gfx/obj/.stamp-sc3000
		

CLEAN += target-sc3000-clean
TOCREATE += $(call check_target,sc3000,sc3000_clib.lib)

sc3000_clib.lib: $(TARGET_CLIB_DEPS) $(SC3000_TARGETS)
	$(MAKE) -C classic/video/tms9918 TARGET=sc3000
	TARGET=sc3000 TYPE=z80 $(LIBLINKER) -DFORsc3000 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sc3000_clib @$(TARGET_DIRECTORY)/sc3000/sc3000.lst

$(eval $(call gfx_stamp_args,sc3000,TARGET=sc3000))

target-sc3000: $(SC3000_TARGETS)

.PHONY: target-sc3000 target-sc3000-clean

$(eval $(call buildtms9918,sc3000,sc3000))


$(eval $(call buildtargetasm,target/sc3000,z80,sc3000,-mz80,$(SC3000_GLOBS),$(SC3000_GLOBS_ex)))

target-sc3000-clean:
	$(RM) -fr target/sc3000/obj
