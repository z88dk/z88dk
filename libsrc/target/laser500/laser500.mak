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


LASER500_TARGETS := target/laser500/obj/target-laser500-laser500
		

CLEAN += target-laser500-clean

target-laser500: $(LASER500_TARGETS)

.PHONY: target-laser500 target-laser500-clean


$(eval $(call buildtargetasm,target/laser500,z80,laser500,-mz80,$(LASER500_GLOBS),$(LASER500_GLOBS_ex)))

target-laser500-clean:
	$(RM) -fr target/laser500/obj
