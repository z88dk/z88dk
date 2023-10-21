
SETJMP_CFILES := $(notdir $(wildcard setjmp/*.c))
SETJMP_AFILES := $(notdir $(wildcard setjmp/*.asm))

SETJMP_OBJECTS := $(SETJMP_CFILES:.c=.o) $(SETJMP_AFILES:.asm=.o)

SETJMP_OBJS := $(addprefix setjmp/obj/z80/, $(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/r2ka/,$(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/r4k/,$(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/ixiy/,$(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/z80n/,$(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/8080/,$(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/gbz80/,$(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/z180/,$(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/ez80_z80/,$(SETJMP_OBJECTS)) \
	$(addprefix setjmp/obj/kc160/,$(SETJMP_OBJECTS))

OBJS += $(SETJMP_OBJS)
CLEAN += setjmp-clean

setjmp: $(SETJMP_OBJS)

.PHONY: setjmp setjmp-clean

$(eval $(call buildbit,setjmp,z80,test))
$(eval $(call buildbit,setjmp,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,setjmp,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,setjmp,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,setjmp,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,setjmp,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,setjmp,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,setjmp,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,setjmp,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,setjmp,kc160,test,-clib=kc160,-mkc160))


setjmp-clean:
	$(RM) -fr setjmp/obj setjmp/*.o
