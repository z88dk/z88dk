ALTAIR8800_GLOBS := \
	"target/altair8800/stdio/*.asm" 

ALTAIR8800_GLOBS_ex := \
	target/altair8800/stdio/*.asm 


ALTAIR8800_TARGETS := target/altair8800/obj/target-altair8800-altair8800
		

CLEAN += target-altair8800-clean

target-altair8800: $(ALTAIR8800_TARGETS)

.PHONY: target-altair8800 target-altair8800-clean


$(eval $(call buildtargetasm,target/altair8800,8080,altair8800,-m8080,$(ALTAIR8800_GLOBS),$(ALTAIR8800_GLOBS_ex)))

target-altair8800-clean:
	$(RM) -fr target/altair8800/obj
