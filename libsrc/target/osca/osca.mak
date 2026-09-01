OSCA_SOURCES := $(shell find target/osca -type f -name '*.asm')
OSCA_CFILES := $(shell find target/osca -type f -name '*.c')
OSCA_OFILES := $(addprefix target/osca/obj/osca/,$(OSCA_CFILES:.c=.o))

OSCA_TARGETS := target/osca/obj/target-osca-osca $(OSCA_OFILES) classic/games/obj/.stamp-osca classic/gfx/obj/.stamp-osca

CLEAN += target-osca-clean

$(eval $(call gfx_stamp_args,osca,TARGET=osca FLAVOUR=wide))

target-osca: $(OSCA_TARGETS)

.PHONY: target-osca target-osca-clean

$(eval $(call buildtargetasm,target/osca,z80,osca,-mz80,$(OSCA_SOURCES),$(OSCA_SOURCES)))
$(eval $(call buildtargetc,target/osca,osca))

target-osca-clean:
	$(RM) -fr target/osca/obj
