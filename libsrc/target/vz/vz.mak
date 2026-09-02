VZ_GLOBS := \
	"target/vz/games/*.asm" \
	"target/vz/graphics/*.asm" \
	"target/vz/*.asm" \
	"target/vz/input/*.asm" \
	"target/vz/stdio/*.asm" \
	"target/vz/stdio/ansi/*.asm" 

VZ_GLOBS_ex := \
	target/vz/games/*.asm \
	target/vz/graphics/*.asm \
	target/vz/*.asm \
	target/vz/input/*.asm \
	target/vz/stdio/*.asm \
	target/vz/stdio/ansi/*.asm 


VZ_TARGETS := target/vz/obj/target-vz-vz classic/games/obj/.stamp-vz classic/gfx/obj/.stamp-vz

$(eval $(call gfx_stamp_args,vz,TARGET=vz))
		

CLEAN += target-vz-clean
vz_clib.lib: $(TARGET_CLIB_DEPS) $(VZ_TARGETS)
	@echo ''
	@echo '--- Building VZ200/300 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6847 TARGET=vz
	TARGET=vz TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORvz -x$(OUTPUT_DIRECTORY)/vz_clib @$(TARGET_DIRECTORY)/vz/vz200.lst


TOCREATE += $(call check_target,vz,vz_clib.lib)

target-vz: $(VZ_TARGETS)

.PHONY: target-vz target-vz-clean


$(eval $(call buildtargetasm,target/vz,z80,vz,-mz80,$(VZ_GLOBS),$(VZ_GLOBS_ex)))

target-vz-clean:
	$(RM) -fr target/vz/obj
