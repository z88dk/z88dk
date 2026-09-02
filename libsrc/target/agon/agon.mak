AGON_GLOBS := \
	"target/agon/agon/*.asm" \
	"target/agon/graphics/*.asm" \
	"target/agon/fcntl/*.asm" \
	"target/agon/stdio/*.asm" 

AGON_GLOBS_ex := \
	target/agon/agon/*.asm \
	target/agon/graphics/*.asm \
	target/agon/fcntl/*.asm \
	target/agon/stdio/*.asm 


AGON_TARGETS := target/agon/obj/target-agon-agon classic/games/obj/.stamp-agon classic/gfx/obj/.stamp-agon
		

CLEAN += target-agon-clean
agon_clib.lib: $(TARGET_CLIB_DEPS) $(AGON_TARGETS)
	@echo ''
	@echo '--- Building Agon Light Library ---'
	@echo ''
	TARGET=agon TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -DFORagon -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/agon_clib @$(TARGET_DIRECTORY)/agon/agon.lst

TOCREATE += $(call check_target,agon,agon_clib.lib)

$(eval $(call gfx_stamp_args,agon,TARGET=agon FLAVOUR=wide))

target-agon: $(AGON_TARGETS)

.PHONY: target-agon target-agon-clean


$(eval $(call buildtargetasm,target/agon,ez80_z80,agon,-mez80_z80,$(AGON_GLOBS),$(AGON_GLOBS_ex)))

target-agon-clean:
	$(RM) -fr target/agon/obj
