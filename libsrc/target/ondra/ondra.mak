ONDRA_GLOBS := \
	"target/ondra/games/*.asm" \
	"target/ondra/graphics/*.asm" \
	"target/ondra/input/*.asm" \
	"target/ondra/stdio/*.asm" 

ONDRA_GLOBS_ex := \
	target/ondra/games/*.asm \
	target/ondra/graphics/*.asm \
	target/ondra/input/*.asm \
	target/ondra/stdio/*.asm 


ONDRA_TARGETS := target/ondra/obj/target-ondra-ondra classic/games/obj/.stamp-ondra classic/gfx/obj/.stamp-ondra
		

CLEAN += target-ondra-clean
ondra_clib.lib: $(TARGET_CLIB_DEPS) $(ONDRA_TARGETS)
	@echo ''
	@echo '--- Building Ondra Library ---'
	@echo ''
	TARGET=ondra TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORondra -x$(OUTPUT_DIRECTORY)/ondra_clib @$(TARGET_DIRECTORY)/ondra/ondra.lst

TOCREATE += $(call check_target,ondra,ondra_clib.lib)

$(eval $(call gfx_stamp_args,ondra,TARGET=ondra FLAVOUR=wide))

target-ondra: $(ONDRA_TARGETS)

.PHONY: target-ondra target-ondra-clean


$(eval $(call buildtargetasm,target/ondra,z80,ondra,-mz80,$(ONDRA_GLOBS),$(ONDRA_GLOBS_ex)))

target-ondra-clean:
	$(RM) -fr target/ondra/obj
