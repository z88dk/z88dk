PENCIL2_GLOBS := \
	"target/pencil2/games/*.asm" \
	"target/pencil2/input/*.asm" \
	"target/pencil2/stdio/*.asm" 

PENCIL2_GLOBS_ex := \
	target/pencil2/games/*.asm \
	target/pencil2/input/*.asm \
	target/pencil2/stdio/*.asm 


PENCIL2_TARGETS := target/pencil2/obj/target-pencil2-pencil2 classic/video/tms9918/obj/pencil2 classic/games/obj/.stamp-pencil2 classic/gfx/obj/.stamp-pencil2
		

CLEAN += target-pencil2-clean
TOCREATE += $(call check_target,pencil2,pencil2_clib.lib)

pencil2_clib.lib: $(TARGET_CLIB_DEPS) $(PENCIL2_TARGETS)
	$(MAKE) -C classic/video/tms9918 TARGET=pencil2
	TARGET=pencil2 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpencil2 -x$(OUTPUT_DIRECTORY)/pencil2_clib @$(TARGET_DIRECTORY)/pencil2/pencil2.lst

$(eval $(call gfx_stamp_args,pencil2,TARGET=pencil2))

target-pencil2: $(PENCIL2_TARGETS)

.PHONY: target-pencil2 target-pencil2-clean

$(eval $(call buildtms9918,pencil2,pencil2))


$(eval $(call buildtargetasm,target/pencil2,z80,pencil2,-mz80,$(PENCIL2_GLOBS),$(PENCIL2_GLOBS_ex)))

target-pencil2-clean:
	$(RM) -fr target/pencil2/obj
