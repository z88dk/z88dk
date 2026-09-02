MICRO8085_GLOBS := \
	"target/micro8085/drv/*.asm" \
	"target/micro8085/stdio/*.asm" 

MICRO8085_GLOBS_ex := \
	target/micro8085/drv/*.asm \
	target/micro8085/stdio/*.asm 


MICRO8085_TARGETS := target/micro8085/obj/target-micro8085-micro8085 classic/gfx/obj/.stamp-micro8085

micro8085_clib.lib: $(TARGET_CLIB_DEPS) $(MICRO8085_TARGETS)
	TARGET=micro8085 TYPE=8085 $(LIBLINKER) -m8085 -DFORmicro8085 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/micro8085_clib @$(TARGET_DIRECTORY)/micro8085/micro8085.lst
		

CLEAN += target-micro8085-clean
TOCREATE += $(call check_target,micro8085,micro8085_clib.lib)

$(eval $(call gfx_stamp_args,micro8085,TARGET=micro8085))

target-micro8085: $(MICRO8085_TARGETS)

.PHONY: target-micro8085 target-micro8085-clean

$(eval $(call buildtargetasm,target/micro8085,8085,micro8085,-m8085,$(MICRO8085_GLOBS),$(MICRO8085_GLOBS_ex)))

target-micro8085-clean:
	$(RM) -fr target/micro8085/obj
