
INT_NMI_CFILES := $(notdir $(wildcard classic/interrupts/nmi/*.c))
INT_NMI_AFILES := $(notdir $(wildcard classic/interrupts/nmi/*.asm))


INT_NMI_OBJECTS := $(INT_NMI_CFILES:.c=.o) $(INT_NMI_AFILES:.asm=.o)

INT_NMI_OBJS := $(addprefix classic/interrupts/nmi/obj/z80/, $(INT_NMI_OBJECTS)) \
	$(addprefix classic/interrupts/nmi/obj/ixiy/,$(INT_NMI_OBJECTS)) \
	$(addprefix classic/interrupts/nmi/obj/z80n/,$(INT_NMI_OBJECTS)) \
	$(addprefix classic/interrupts/nmi/obj/8080/,$(INT_NMI_OBJECTS)) \
	$(addprefix classic/interrupts/nmi/obj/8085/,$(INT_NMI_OBJECTS)) \
	$(addprefix classic/interrupts/nmi/obj/gbz80/,$(INT_NMI_OBJECTS)) \
	$(addprefix classic/interrupts/nmi/obj/z180/,$(INT_NMI_OBJECTS)) \
	$(addprefix classic/interrupts/nmi/obj/ez80_z80/,$(INT_NMI_OBJECTS)) \
	$(addprefix classic/interrupts/nmi/obj/kc160/,$(INT_NMI_OBJECTS))


OBJS += $(INT_NMI_OBJS) 
CLEAN += interrupts-nmi-clean

interrupts-nmi: $(INT_NMI_OBJS) $(INT_NMI_NEWLIB_TARGETS)

.PHONY: interrupts-nmi interrupts-nmi-clean

$(eval $(call buildbit,classic/interrupts/nmi,z80,test))
$(eval $(call buildbit,classic/interrupts/nmi,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/interrupts/nmi,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/interrupts/nmi,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/interrupts/nmi,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/interrupts/nmi,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/interrupts/nmi,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/interrupts/nmi,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/interrupts/nmi,kc160,test,-clib=kc160,-mkc160))


interrupts-nmi-clean:
	$(RM) -fr classic/interrupts/nmi/obj classic/interrupts/nmi/*.o
