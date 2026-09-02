NEWBRAIN_SOURCES := $(shell find target/newbrain -type f -name '*.asm')
NEWBRAIN_CFILES := $(shell find target/newbrain -type f -name '*.c')
NEWBRAIN_OFILES := $(patsubst target/newbrain/%,target/newbrain/obj/newbrain/%,$(NEWBRAIN_CFILES:.c=.o))

NEWBRAIN_TARGETS := target/newbrain/obj/target-newbrain-newbrain $(NEWBRAIN_OFILES) classic/games/obj/.stamp-newbrain classic/gfx/obj/.stamp-newbrain

nbdrv.lib:
	$(MAKE) -C target/newbrain/fcntl all

CLEAN += target-newbrain-clean
newbrain_clib.lib:  $(TARGET_CLIB_DEPS) $(NEWBRAIN_TARGETS)
	TARGET=newbrain TYPE=z80 $(LIBLINKER) -DFORnewbrain -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/newbrain_clib @$(TARGET_DIRECTORY)/newbrain/newbrain.lst
	@touch $@

newbrain_cpm.lib:  $(TARGET_CLIB_DEPS) $(NEWBRAIN_TARGETS)
	TARGET=newbrain TYPE=z80 $(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/newbrain_cpm @$(TARGET_DIRECTORY)/newbrain/newbrain_cpm.lst
	@touch $@
TOCREATE += $(call check_target,newbrain,newbrain_clib.lib newbrain_cpm.lib nbdrv.lib)

$(eval $(call gfx_stamp_args,newbrain,TARGET=newbrain))

target-newbrain: $(NEWBRAIN_TARGETS)

.PHONY: target-newbrain target-newbrain-clean

$(eval $(call buildtargetasm,target/newbrain,z80,newbrain,-mz80,$(NEWBRAIN_SOURCES),$(NEWBRAIN_SOURCES)))
$(eval $(call buildtargetc,target/newbrain,newbrain))

target-newbrain-clean:
	$(RM) -fr target/newbrain/obj
