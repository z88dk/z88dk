PHC25_GLOBS := \
	"target/phc25/games/*.asm" \
	"target/phc25/graphics/*.asm" \
	"target/phc25/input/*.asm" \
	"target/phc25/interrupt/*.asm" \
	"target/phc25/psg/*.asm" \
	"target/phc25/stdio/*.asm" 

PHC25_GLOBS_ex := \
	target/phc25/games/*.asm \
	target/phc25/graphics/*.asm \
	target/phc25/input/*.asm \
	target/phc25/interrupt/*.asm \
	target/phc25/psg/*.asm \
	target/phc25/stdio/*.asm


PHC25_TARGETS := target/phc25/obj/target-phc25-phc25
		

CLEAN += target-phc25-clean

target-phc25: $(PHC25_TARGETS)

.PHONY: target-phc25 target-phc25-clean


$(eval $(call buildtargetasm,target/phc25,z80,phc25,-mz80,$(PHC25_GLOBS),$(MULTI8_GLOBS_ex)))

target-phc25-clean:
	$(RM) -fr target/phc25/obj
