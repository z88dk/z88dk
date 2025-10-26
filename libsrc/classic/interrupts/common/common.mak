
INT_COMMON_CFILES := $(notdir $(wildcard classic/interrupts/common/*.c))
INT_COMMON_AFILES := $(notdir $(wildcard classic/interrupts/common/*.asm))


INT_COMMON_OBJECTS := $(INT_COMMON_CFILES:.c=.o) $(INT_COMMON_AFILES:.asm=.o)

INT_COMMON_OBJS := $(addprefix classic/interrupts/common/obj/z80/, $(INT_COMMON_OBJECTS)) \
	$(addprefix classic/interrupts/common/obj/ixiy/,$(INT_COMMON_OBJECTS)) \
	$(addprefix classic/interrupts/common/obj/z80n/,$(INT_COMMON_OBJECTS)) \
	$(addprefix classic/interrupts/common/obj/8080/,$(INT_COMMON_OBJECTS)) \
	$(addprefix classic/interrupts/common/obj/8085/,$(INT_COMMON_OBJECTS)) \
	$(addprefix classic/interrupts/common/obj/gbz80/,$(INT_COMMON_OBJECTS)) \
	$(addprefix classic/interrupts/common/obj/z180/,$(INT_COMMON_OBJECTS)) \
	$(addprefix classic/interrupts/common/obj/ez80_z80/,$(INT_COMMON_OBJECTS)) \
	$(addprefix classic/interrupts/common/obj/kc160/,$(INT_COMMON_OBJECTS))


OBJS += $(INT_COMMON_OBJS) 
CLEAN += interrupts-common-clean

interrupts-common: $(INT_COMMON_OBJS) $(INT_COMMON_NEWLIB_TARGETS)

.PHONY: interrupts-common interrupts-common-clean

$(eval $(call buildbit,classic/interrupts/common,z80,test))
$(eval $(call buildbit,classic/interrupts/common,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/interrupts/common,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/interrupts/common,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/interrupts/common,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/interrupts/common,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/interrupts/common,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/interrupts/common,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/interrupts/common,kc160,test,-clib=kc160,-mkc160))


interrupts-common-clean:
	$(RM) -fr classic/interrupts/common/obj
