CPC_SOURCES := $(shell find target/cpc -type f -name '*.asm' ! -name 'fill.asm' ! -name 'multiplication1.asm' ! -name 'multiplication2.asm')
CPC_CFILES := $(shell find target/cpc/fcntl -type f -name '*.c')
CPC_OFILES := $(addprefix target/cpc/obj/cpc/,$(CPC_CFILES:.c=.o))
CPC_FCNTL_OFILES := $(CPC_OFILES)

CPC_TARGETS := target/cpc/obj/target-cpc-cpc $(CPC_OFILES) classic/games/obj/.stamp-cpc classic/gfx/obj/.stamp-cpc

CLEAN += target-cpc-clean

$(eval $(call gfx_stamp_args,cpc,TARGET=cpc FLAVOUR=wide))

target-cpc: $(CPC_TARGETS)

.PHONY: target-cpc target-cpc-clean

$(eval $(call buildtargetasm,target/cpc,z80,cpc,-mz80,$(CPC_SOURCES),$(CPC_SOURCES)))
$(eval $(call buildtargetc,target/cpc,cpc))

target-cpc-clean:
	$(RM) -fr target/cpc/obj
