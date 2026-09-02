MAP1010_GLOBS := \
	"target/map1010/games/*.asm" \
	"target/map1010/input/*.asm"

MAP1010_GLOBS_ex := \
	target/map1010/games/*.asm \
	target/map1010/input/*.asm


MAP1010_TARGETS := target/map1010/obj/target-map1010-map1010


CLEAN += target-map1010-clean
TOCREATE += $(call check_target,map1010,map1010.lib)

map1010.lib: phc25_clib.lib $(MAP1010_TARGETS)
	TARGET=phc25 TYPE=z80 $(LIBLINKER) -DFORmap1010 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/map1010 @$(TARGET_DIRECTORY)/map1010/map1010.lst

target-map1010: $(MAP1010_TARGETS)

.PHONY: target-map1010 target-map1010-clean

$(eval $(call buildtargetasm,target/map1010,z80,map1010,-mz80,$(MAP1010_GLOBS),$(MAP1010_GLOBS_ex)))

target-map1010-clean:
	$(RM) -fr target/map1010/obj
