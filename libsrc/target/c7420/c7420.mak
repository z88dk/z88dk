C7420_GLOBS := \
	"target/c7420/stdio/*.asm"

C7420_GLOBS_ex := \
	target/c7420/stdio/*.asm 


C7420_TARGETS := target/c7420/obj/target-c7420-c7420 classic/gfx/obj/.stamp-c7420
		

CLEAN += target-c7420-clean
TOCREATE += $(call check_target,c7420,c7420_clib.lib)

c7420_clib.lib: $(TARGET_CLIB_DEPS) $(C7420_TARGETS)
	TARGET=c7420 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORc7420 -x$(OUTPUT_DIRECTORY)/c7420_clib.lib @$(TARGET_DIRECTORY)/c7420/c7420.lst

$(eval $(call gfx_stamp_args,c7420,TARGET=c7420))

target-c7420: $(C7420_TARGETS)

.PHONY: target-c7420 target-c7420-clean


$(eval $(call buildtargetasm,target/c7420,z80,c7420,-mz80,$(C7420_GLOBS),$(C7420_GLOBS_ex)))

target-c7420-clean:
	$(RM) -fr target/c7420/obj
