

X07_GLOBS := \
	"target/x07/stdio/*.asm" \
	"target/x07/graphics/*.asm" \
	"target/x07/*.asm"

X07_GLOBS_ex := \
	target/x07/stdio/*.asm \
	target/x07/graphics/*.asm \
	target/x07/graphics/*.inc \
	target/x07/*.asm



X07_CFILES = 

X07_OFILES = $(patsubst target/x07/%,target/x07/obj/x07/%,$(X07_CFILES:.c=.o))



X07_TARGETS := target/x07/obj/target-x07-x07  $(X07_OFILES) classic/games/obj/.stamp-x07 classic/gfx/obj/.stamp-x07
		

CLEAN += target-x07-clean
x07_clib.lib: $(TARGET_CLIB_DEPS) $(X07_TARGETS)
	@echo ''
	@echo '--- Building Canon X-07 Library ---'
	@echo ''
	TARGET=x07 TYPE=z80 $(LIBLINKER) -mz80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/x07_clib @$(TARGET_DIRECTORY)/x07/x07.lst

TOCREATE += $(call check_target,x07,x07_clib.lib)

$(eval $(call gfx_stamp_args,x07,TARGET=x07 FLAVOUR=narrow))

target-x07: $(X07_TARGETS)

.PHONY: target-x07 target-x07-clean


$(eval $(call buildtargetasm,target/x07,8080,x07,-m8080,$(X07_GLOBS),$(X07_GLOBS_ex)))
$(eval $(call buildtargetc,target/x07,x07))


target-x07-clean:
	$(RM) -fr target/x07/obj
