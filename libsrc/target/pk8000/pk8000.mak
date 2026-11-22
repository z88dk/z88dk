PK8000_GLOBS := \
	"target/pk8000/input/*.asm" \
	"target/pk8000/stdio/*.asm" 

PK8000_GLOBS_ex := \
	target/pk8000/input/*.asm \
	target/pk8000/stdio/*.asm 


PK8000_TARGETS := target/pk8000/obj/target-pk8000-pk8000 classic/gfx/obj/.stamp-pk8000
		

CLEAN += target-pk8000-clean
TOCREATE += $(call check_target,pk8000,pk8000_clib.lib)

$(eval $(call gfx_stamp_portable,pk8000,pk8000))
$(eval $(call buildtargetasm,target/pk8000,8080,pk8000,-m8080,$(PK8000_GLOBS),$(PK8000_GLOBS_ex)))

pk8000_clib.lib: $(TARGET_CLIB_DEPS) $(PK8000_TARGETS)
	TARGET=pk8000 TYPE=8080 $(LIBLINKER) -m8080 -DFORpk8000 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pk8000_clib @$(TARGET_DIRECTORY)/pk8000/pk8000.lst


target-pk8000: $(PK8000_TARGETS)

.PHONY: target-pk8000 target-pk8000-clean



target-pk8000-clean:
	$(RM) -fr target/pk8000/obj
