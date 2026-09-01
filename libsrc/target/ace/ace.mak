ACE_SOURCES := $(shell find target/ace -type f -name '*.asm')
ACE_CFILES := $(wildcard target/ace/tape/*.c)
ACE_OFILES := $(addprefix target/ace/obj/ace/,$(ACE_CFILES:.c=.o))

ACE_TARGETS := target/ace/obj/target-ace-ace $(ACE_OFILES) classic/games/obj/.stamp-ace classic/gfx/obj/.stamp-ace
ACEUDG_TARGETS := target/ace/obj/target-ace-aceudg classic/gfx/obj/.stamp-ace-udg

CLEAN += target-ace-clean

$(eval $(call gfx_stamp_args,ace,TARGET=ace FLAVOUR="text narrow"))
$(eval $(call gfx_stamp_args,ace-udg,TARGET=ace SUBTYPE=aceudg FLAVOUR="gencon text6 narrow"))

target-ace: $(ACE_TARGETS) $(ACEUDG_TARGETS)

.PHONY: target-ace target-ace-clean

$(eval $(call buildtargetasm,target/ace,z80,ace,-mz80,$(ACE_SOURCES),$(ACE_SOURCES)))
$(eval $(call buildtargetasm,target/ace,z80,aceudg,-mz80,$(ACE_SOURCES),$(ACE_SOURCES)))
$(eval $(call buildtargetc,target/ace,ace))

target-ace-clean:
	$(RM) -fr target/ace/obj
