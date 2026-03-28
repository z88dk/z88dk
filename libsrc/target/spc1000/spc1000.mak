SPC1000_GLOBS := \
	"target/spc1000/*.asm" \
	"target/spc1000/games/*.asm" \
	"target/spc1000/input/*.asm" \
	"target/spc1000/psg/*.asm" \
	"target/spc1000/stdio/*.asm" 

SPC1000_GLOBS_ex := \
	target/spc1000/*.asm \
	target/spc1000/games/*.asm \
	target/spc1000/input/*.asm \
	target/spc1000/psg/*.asm \


SPC1000_TARGETS := target/spc1000/obj/target-spc1000-spc1000
		

CLEAN += target-spc1000-clean

target-spc1000: $(SPC1000_TARGETS)

.PHONY: target-spc1000 target-spc1000-clean


$(eval $(call buildtargetasm,target/spc1000,ez80,spc1000,-mz80,$(SPC1000_GLOBS),$(SPC1000_GLOBS_ex)))

target-spc1000-clean:
	$(RM) -fr target/spc1000/obj
