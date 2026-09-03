SPECIAL_SOURCES := $(call rwildcard,target/special,*.asm)
SPECIAL_SOURCES_EX := $(SPECIAL_SOURCES)

SPECIAL_TARGETS := target/special/obj/target-special-special classic/gfx/obj/.stamp-special

$(eval $(call gfx_stamp_portable_args,special,TARGET=special FLAVOUR=wide))

$(eval $(call buildtargetasm,target/special,8080,special,-m8080,$(SPECIAL_SOURCES),$(SPECIAL_SOURCES_EX)))

CLEAN += target-special-clean
TOCREATE += $(call check_target,special,special_clib.lib)

special_clib.lib: $(TARGET_CLIB_DEPS) $(SPECIAL_TARGETS)
	@echo ''
	@echo '--- Building Specialist Library ---'
	@echo ''
	TARGET=special TYPE=8080 $(LIBLINKER) -m8080 -DFORspecial -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/special_clib.lib @$(TARGET_DIRECTORY)/special/special.lst


target-special: $(SPECIAL_TARGETS)

.PHONY: target-special target-special-clean

target-special-clean:
	$(RM) -fr target/special/obj
