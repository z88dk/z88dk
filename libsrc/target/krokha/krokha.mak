KROKHA_GLOBS := \
	"target/krokha/games/*.asm" \
	"target/krokha/graphics/*.asm" \
	"target/krokha/stdio/*.asm" 

KROKHA_GLOBS_ex := \
	target/krokha/games/*.asm \
	target/krokha/graphics/*.asm \
	target/krokha/stdio/*.asm 


KROKHA_TARGETS := target/krokha/obj/target-krokha-krokha classic/games/obj/.stamp-krokha classic/gfx/obj/.stamp-krokha
		

CLEAN += target-krokha-clean

$(eval $(call gfx_stamp_args,krokha,TARGET=krokha FLAVOUR="gencon portable"))

target-krokha: $(KROKHA_TARGETS)

.PHONY: target-krokha target-krokha-clean


$(eval $(call buildtargetasm,target/krokha,8080,krokha,-m8080,$(KROKHA_GLOBS),$(KROKHA_GLOBS_ex)))

target-krokha-clean:
	$(RM) -fr target/krokha/obj
