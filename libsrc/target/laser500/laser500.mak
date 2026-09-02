LASER500_GLOBS := \
	"target/laser500/*.asm" \
	"target/laser500/games/*.asm" \
	"target/laser500/graphics/*.asm" \
	"target/laser500/input/*.asm" \
	"target/laser500/stdio/*.asm" 

LASER500_GLOBS_ex := \
	target/laser500/*.asm \
	target/laser500/games/*.asm \
	target/laser500/graphics/*.asm \
	target/laser500/input/*.asm \
	target/laser500/stdio/*.asm 


LASER500_TARGETS := target/laser500/obj/target-laser500-laser500 classic/games/obj/.stamp-laser500 classic/gfx/obj/.stamp-laser500
		

CLEAN += target-laser500-clean
laser500_clib.lib: $(TARGET_CLIB_DEPS) $(LASER500_TARGETS)
	@echo ''
	@echo '--- Building VTech Laser 350/500/700 Library ---'
	@echo ''
	TARGET=laser500 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlaser500 -x$(OUTPUT_DIRECTORY)/laser500_clib @$(TARGET_DIRECTORY)/laser500/laser500.lst

TOCREATE += $(call check_target,laser500,laser500_clib.lib)

$(eval $(call gfx_stamp_args,laser500,TARGET=laser500 FLAVOUR=wide))

target-laser500: $(LASER500_TARGETS)

.PHONY: target-laser500 target-laser500-clean


$(eval $(call buildtargetasm,target/laser500,z80,laser500,-mz80,$(LASER500_GLOBS),$(LASER500_GLOBS_ex)))

target-laser500-clean:
	$(RM) -fr target/laser500/obj
