X1_GLOBS := \
	"target/x1/graphics/*.asm" \
	"target/x1/input/*.asm" \
	"target/x1/psg/*.asm" \
	"target/x1/stdio/*.asm" \
	"target/x1/stdio/ansi/*.asm" \
	"target/x1/x1/*.asm"

X1_GLOBS_ex := \
	target/x1/graphics/*.asm \
	target/x1/input/*.asm \
	target/x1/psg/*.asm \
	target/x1/stdio/*.asm \
	target/x1/stdio/ansi/*.asm \
	target/x1/x1/*.asm

X1_CFILES := $(wildcard target/x1/x1/*.c) $(wildcard target/x1/time/*.c)
X1_OFILES := $(patsubst target/x1/%,target/x1/obj/x1/%,$(X1_CFILES:.c=.o))

X1_TARGETS := target/x1/obj/target-x1-x1 $(X1_OFILES) classic/games/obj/.stamp-x1 classic/gfx/obj/.stamp-x1
X1_CPM_TARGETS := target/x1/obj/target-x1-x1 $(X1_OFILES) classic/gfx/obj/.stamp-cpm-x1

CLEAN += target-x1-clean
TOCREATE += $(call check_target,x1,x1_clib.lib x1_cpm.lib $(CPMLIBS))
$(eval $(call gfx_stamp_args,x1,TARGET=x1 FLAVOUR=wide))
$(eval $(call buildtargetasm,target/x1,z80,x1,-mz80,$(X1_GLOBS),$(X1_GLOBS_ex)))
$(eval $(call buildtargetc,target/x1,x1))

x1_cpm.lib: x1_clib.lib $(X1_CPM_TARGETS)
	@echo ''
	@echo '--- Building Sharp X1 Library ---'
	@echo ''
	TARGET=x1 TYPE=z80 $(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1_cpm @$(TARGET_DIRECTORY)/x1/x1_common.lst

x1_clib.lib: $(TARGET_CLIB_DEPS) $(X1_TARGETS)
	@echo ''
	@echo '--- Building Sharp X1 Library ---'
	@echo ''
	TARGET=x1 TYPE=z80 $(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1_clib @$(TARGET_DIRECTORY)/x1/x1.lst



target-x1: $(X1_TARGETS) $(X1_CPM_TARGETS)

.PHONY: target-x1 target-x1-clean


target-x1-clean:
	$(RM) -fr target/x1/obj
