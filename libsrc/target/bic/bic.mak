BIC_GLOBS := \
	"target/bic/psg/*.asm" 

BIC_GLOBS_ex := \
	target/bic/psg/*.asm 


BIC_TARGETS := target/bic/obj/target-bic-bic
		

CLEAN += target-bic-clean

target-bic: $(BIC_TARGETS)

.PHONY: target-bic target-bic-clean


$(eval $(call buildtargetasm,target/bic,z80,bic,-mz80,$(BIC_GLOBS),$(BIC_GLOBS_ex)))

target-bic-clean:
	$(RM) -fr target/bic/obj
