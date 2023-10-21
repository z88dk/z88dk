
INT_IM1_CFILES := $(notdir $(wildcard interrupts/im1/*.c))
INT_IM1_AFILES := $(notdir $(wildcard interrupts/im1/*.asm))


INT_IM1_OBJECTS := $(INT_IM1_CFILES:.c=.o) $(INT_IM1_AFILES:.asm=.o)

INT_IM1_OBJS := $(addprefix interrupts/im1/obj/z80/, $(INT_IM1_OBJECTS)) \
	$(addprefix interrupts/im1/obj/ixiy/,$(INT_IM1_OBJECTS)) \
	$(addprefix interrupts/im1/obj/z80n/,$(INT_IM1_OBJECTS)) \
	$(addprefix interrupts/im1/obj/8080/,$(INT_IM1_OBJECTS)) \
	$(addprefix interrupts/im1/obj/gbz80/,$(INT_IM1_OBJECTS)) \
	$(addprefix interrupts/im1/obj/z180/,$(INT_IM1_OBJECTS)) \
	$(addprefix interrupts/im1/obj/ez80_z80/,$(INT_IM1_OBJECTS)) \
	$(addprefix interrupts/im1/obj/kc160/,$(INT_IM1_OBJECTS)) 


OBJS += $(INT_IM1_OBJS) 
CLEAN += interrupts-im1-clean

interrupts-im1: $(INT_IM1_OBJS) $(INT_IM1_NEWLIB_TARGETS)

.PHONY: interrupts-im1 interrupts-im1-clean

$(eval $(call buildbit,interrupts/im1,z80,test))
$(eval $(call buildbit,interrupts/im1,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,interrupts/im1,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,interrupts/im1,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,interrupts/im1,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,interrupts/im1,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,interrupts/im1,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,interrupts/im1,kc160,test,-clib=kc160,-mkc160))


interrupts-im1-clean:
	$(RM) -fr interrupts/im1/obj interrupts/im1/*.o
