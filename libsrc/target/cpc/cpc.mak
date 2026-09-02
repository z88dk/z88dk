CPC_SOURCES := $(shell find target/cpc -type f -name '*.asm' ! -name 'fill.asm' ! -name 'multiplication1.asm' ! -name 'multiplication2.asm')
CPC_CFILES := $(shell find target/cpc/fcntl -type f -name '*.c')
CPC_OFILES := $(patsubst target/cpc/%,target/cpc/obj/cpc/%,$(CPC_CFILES:.c=.o))
CPC_FCNTL_OFILES := $(CPC_OFILES)

CPC_TARGETS := target/cpc/obj/target-cpc-cpc $(CPC_OFILES) classic/games/obj/.stamp-cpc classic/gfx/obj/.stamp-cpc

rs232cpc_booster.lib:
	$(MAKE) -C target/cpc/rs232/booster all

rs232cpc_sti.lib:
	$(MAKE) -C target/cpc/rs232/sti all

CLEAN += target-cpc-clean
cpc_clib.lib:  $(TARGET_CLIB_DEPS) $(CPC_TARGETS)
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcpc -x$(OUTPUT_DIRECTORY)/cpc_clib @$(TARGET_DIRECTORY)/cpc/cpc.lst
	@touch $@

cpccpm.lib:  cpc_clib.lib $(TARGET_CLIB_DEPS) $(CPC_TARGETS)
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpccpm @$(TARGET_DIRECTORY)/cpc/cpc_cpm.lst
	@touch $@

cpcfs.lib: $(CPC_FCNTL_OFILES)
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpcfs @$(TARGET_DIRECTORY)/cpc/fcntl/cpcfs.lst
	@touch $@
cpc_math.lib:
	@echo ''
	@echo '--- Building Amstrad CPC Maths Libraries ---'
	@echo ''
	$(MAKE) -C math/float/cpcmath

TOCREATE += $(call check_target,cpc,cpc_clib.lib cpcfs.lib cpc_math.lib cpccpm.lib rs232cpc_booster.lib rs232cpc_sti.lib)

$(eval $(call gfx_stamp_args,cpc,TARGET=cpc FLAVOUR=wide))

target-cpc: $(CPC_TARGETS)

.PHONY: target-cpc target-cpc-clean

$(eval $(call buildtargetasm,target/cpc,z80,cpc,-mz80,$(CPC_SOURCES),$(CPC_SOURCES)))
$(eval $(call buildtargetc,target/cpc,cpc))

target-cpc-clean:
	$(RM) -fr target/cpc/obj
