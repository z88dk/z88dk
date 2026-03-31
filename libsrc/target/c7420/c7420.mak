C7420_GLOBS := \
	"target/c7420/stdio/*.asm"

C7420_GLOBS_ex := \
	target/c7420/stdio/*.asm 


C7420_TARGETS := target/c7420/obj/target-c7420-c7420
		

CLEAN += target-c7420-clean

target-c7420: $(C7420_TARGETS)

.PHONY: target-c7420 target-c7420-clean


$(eval $(call buildtargetasm,target/c7420,z80,c7420,-mz80,$(C7420_GLOBS),$(C7420_GLOBS_ex)))

target-c7420-clean:
	$(RM) -fr target/c7420/obj
