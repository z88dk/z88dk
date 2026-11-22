RCMX000_SOURCES := $(call rwildcard,target/rcmx000,*.asm)
RCMX000_TARGETS := target/rcmx000/obj/target-rcmx000-rcmx000 \
	classic/gfx/obj/.stamp-rcmx000

$(eval $(call gfx_stamp_args,rcmx000,TARGET=rcmx000))
CLEAN += target-rcmx000-clean
TOCREATE += $(call check_target,rcmx000,rcmx000_clib.lib)
$(eval $(call buildtargetasm,target/rcmx000,r2ka,rcmx000,-mr2ka,$(RCMX000_SOURCES),$(RCMX000_SOURCES)))

rcmx000_clib.lib: $(TARGET_CLIB_DEPS) $(RCMX000_TARGETS)
	@echo ''
	@echo '--- Building RCM2/3000 Library ---'
	@echo ''
	TARGET=rcmx000 TYPE=r2ka $(LIBLINKER) -mr2ka -DSTANDARDESCAPECHARS -DFORrcmx000 -x$(OUTPUT_DIRECTORY)/rcmx000_clib @$(TARGET_DIRECTORY)/rcmx000/rcmx000.lst

target-rcmx000: $(RCMX000_TARGETS)

.PHONY: target-rcmx000 target-rcmx000-clean

target-rcmx000-clean:
	$(RM) -fr target/rcmx000/obj
