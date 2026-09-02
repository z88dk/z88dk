SPECIAL_SOURCES := $(shell find target/special -type f -name '*.asm')
SPECIAL_SOURCES_EX := $(SPECIAL_SOURCES)

SPECIAL_TARGETS := target/special/obj/target-special-special classic/gfx/obj/.stamp-special

$(eval $(call gfx_stamp_portable_args,special,TARGET=special FLAVOUR=wide))

$(eval $(call buildtargetasm,target/special,8080,special,-m8080,$(SPECIAL_SOURCES),$(SPECIAL_SOURCES_EX)))

CLEAN += target-special-clean

target-special: $(SPECIAL_TARGETS)

.PHONY: target-special target-special-clean

target-special-clean:
	$(RM) -fr target/special/obj
