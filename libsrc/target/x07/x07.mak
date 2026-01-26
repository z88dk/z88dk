

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

X07_OFILES = $(addprefix target/x07/obj/x07/, $(X07_CFILES:.c=.o)) 



X07_TARGETS := target/x07/obj/target-x07-x07  $(X07_OFILES) 
		

CLEAN += target-x07-clean

target-x07: $(X07_TARGETS)

.PHONY: target-x07 target-x07-clean


$(eval $(call buildtargetasm,target/x07,8080,x07,-m8080,$(X07_GLOBS),$(X07_GLOBS_ex)))
$(eval $(call buildtargetc,target/x07,x07))


target-x07-clean:
	$(RM) -fr target/x07/obj
