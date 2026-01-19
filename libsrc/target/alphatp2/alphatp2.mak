

ALPHATP2_GLOBS := \
	"target/alphatp2/stdio/*.asm" \
	"target/alphatp2/graphics/*.asm" 

ALPHATP2_GLOBS_ex := \
	target/alphatp2/stdio/*.asm \
	target/alphatp2/graphics/*.asm 



ALPHATP2_CFILES = 

ALPHATP2_OFILES = $(addprefix target/alphatp2/obj/alphatp2/, $(ALPHATP2_CFILES:.c=.o)) 



ALPHATP2_TARGETS := target/alphatp2/obj/target-alphatp2-alphatp2  $(ALPHATP2_OFILES) 
		

CLEAN += target-alphatp2-clean

target-alphatp2: $(ALPHATP2_TARGETS)

.PHONY: target-alphatp2 target-alphatp2-clean


$(eval $(call buildtargetasm,target/alphatp2,8080,alphatp2,-m8080,$(ALPHATP2_GLOBS),$(ALPHATP2_GLOBS_ex)))
$(eval $(call buildtargetc,target/alphatp2,alphatp2))


target-alphatp2-clean:
	$(RM) -fr target/alphatp2/obj
