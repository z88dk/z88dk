PK8000_GLOBS := \
	"target/pk8000/input/*.asm" \
	"target/pk8000/stdio/*.asm" 

PK8000_GLOBS_ex := \
	target/pk8000/input/*.asm \
	target/pk8000/stdio/*.asm 


PK8000_TARGETS := target/pk8000/obj/target-pk8000-pk8000
		

CLEAN += target-pk8000-clean

target-pk8000: $(PK8000_TARGETS)

.PHONY: target-pk8000 target-pk8000-clean


$(eval $(call buildtargetasm,target/pk8000,8080,pk8000,-m8080,$(PK8000_GLOBS),$(PK8000_GLOBS_ex)))

target-pk8000-clean:
	$(RM) -fr target/pk8000/obj
