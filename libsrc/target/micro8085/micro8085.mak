MICRO8085_GLOBS := \
	"target/micro8085/drv/*.asm" \
	"target/micro8085/stdio/*.asm" 

MICRO8085_GLOBS_ex := \
	target/micro8085/drv/*.asm \
	target/micro8085/stdio/*.asm 


MICRO8085_TARGETS := target/micro8085/obj/target-micro8085-micro8085
		

CLEAN += target-micro8085-clean

target-micro8085: $(MICRO8085_TARGETS)

.PHONY: target-micro8085 target-micro8085-clean

$(eval $(call buildtargetasm,target/micro8085,8085,micro8085,-m8085,$(MICRO8085_GLOBS),$(MICRO8085_GLOBS_ex)))

target-micro8085-clean:
	$(RM) -fr target/micro8085/obj
