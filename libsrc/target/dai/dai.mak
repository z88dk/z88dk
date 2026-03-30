DAI_GLOBS := \
	"target/dai/stdio/*.asm" 

DAI_GLOBS_ex := \
	target/dai/stdio/*.asm 


DAI_TARGETS := target/dai/obj/target-dai-dai
		

CLEAN += target-dai-clean

target-dai: $(DAI_TARGETS)

.PHONY: target-dai target-dai-clean


$(eval $(call buildtargetasm,target/dai,8080,dai,-m8080,$(DAI_GLOBS),$(DAI_GLOBS_ex)))

target-dai-clean:
	$(RM) -fr target/dai/obj
