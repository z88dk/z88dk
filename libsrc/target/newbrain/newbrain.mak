NEWBRAIN_SOURCES := $(shell find target/newbrain -type f -name '*.asm')
NEWBRAIN_CFILES := $(shell find target/newbrain -type f -name '*.c')
NEWBRAIN_OFILES := $(patsubst target/newbrain/%,target/newbrain/obj/newbrain/%,$(NEWBRAIN_CFILES:.c=.o))

NEWBRAIN_TARGETS := target/newbrain/obj/target-newbrain-newbrain $(NEWBRAIN_OFILES) classic/games/obj/.stamp-newbrain classic/gfx/obj/.stamp-newbrain

CLEAN += target-newbrain-clean

$(eval $(call gfx_stamp_args,newbrain,TARGET=newbrain))

target-newbrain: $(NEWBRAIN_TARGETS)

.PHONY: target-newbrain target-newbrain-clean

$(eval $(call buildtargetasm,target/newbrain,z80,newbrain,-mz80,$(NEWBRAIN_SOURCES),$(NEWBRAIN_SOURCES)))
$(eval $(call buildtargetc,target/newbrain,newbrain))

target-newbrain-clean:
	$(RM) -fr target/newbrain/obj
