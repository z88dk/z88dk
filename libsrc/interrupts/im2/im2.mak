
INT_IM2_CFILES := $(notdir $(wildcard interrupts/im2/*.c))
INT_IM2_AFILES := $(notdir $(wildcard interrupts/im2/*.asm))


INT_IM2_OBJECTS := $(INT_IM2_CFILES:.c=.o) $(INT_IM2_AFILES:.asm=.o)

INT_IM2_OBJS := $(addprefix interrupts/im2/obj/z80/, $(INT_IM2_OBJECTS)) \
	$(addprefix interrupts/im2/obj/ixiy/,$(INT_IM2_OBJECTS)) \
	$(addprefix interrupts/im2/obj/z80n/,$(INT_IM2_OBJECTS)) \
	$(addprefix interrupts/im2/obj/z180/,$(INT_IM2_OBJECTS)) \
	$(addprefix interrupts/im2/obj/ez80_z80/,$(INT_IM2_OBJECTS))  \
	$(addprefix interrupts/im2/obj/kc160/,$(INT_IM2_OBJECTS)) 


OBJS += $(INT_IM2_OBJS) 
CLEAN += interrupts-im2-clean

interrupts-im2: $(INT_IM2_OBJS) $(INT_IM2_NEWLIB_TARGETS)

.PHONY: interrupts-im2 interrupts-im2-clean

$(eval $(call buildbit,interrupts/im2,z80,test))
$(eval $(call buildbit,interrupts/im2,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,interrupts/im2,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,interrupts/im2,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,interrupts/im2,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,interrupts/im2,kc160,test,-clib=kc160,-mkc160))


interrupts-im2-clean:
	$(RM) -fr interrupts/im2/obj interrupts/im2/*.o
