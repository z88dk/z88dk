RC700_GLOBS := \
	"target/rc700/*.asm" \
	"target/rc700/graphics/*.asm" \
	"target/rc700/time/*.asm" 

RC700_GLOBS_ex := \
	target/rc700/*.asm \
	target/rc700/graphics/*.asm \
	target/rc700/time/*.asm 


RC700_CFILES = $(wildcard target/rc700/*.c)
RC700_OFILES = $(addprefix target/rc700/obj/rc700/, $(RC700_CFILES:.c=.o))

RC700_TARGETS := target/rc700/obj/target-rc700-rc700 $(RC700_OFILES)
		

CLEAN += target-rc700-clean

target-rc700: $(RC700_TARGETS)

.PHONY: target-rc700 target-rc700-clean


$(eval $(call buildtargetasm,target/rc700,z80,rc700,-mz80,$(RC700_GLOBS),$(RC700_GLOBS_ex)))

# rc700 is a cpm subtype (no standalone target config), so C sources compile
# with "+cpm -subtype=rc700" rather than the generic buildtargetc rule.
target/rc700/obj/rc700/%.o: %.c
	@mkdir -p $(dir $@)
	$(ZCC) +cpm -subtype=rc700 -O2 -c -o $@ $^

target-rc700-clean:
	$(RM) -fr target/rc700/obj
