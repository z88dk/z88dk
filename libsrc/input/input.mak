
INPUT_CFILES := $(notdir $(wildcard input/*.c))
INPUT_AFILES := $(notdir $(wildcard input/*.asm))

INPUT_OBJECTS := $(INPUT_CFILES:.c=.o) $(INPUT_AFILES:.asm=.o)

INPUT_OBJS := $(addprefix input/obj/z80/, $(INPUT_OBJECTS)) \
	$(addprefix input/obj/r2ka/,$(INPUT_OBJECTS)) \
	$(addprefix input/obj/ixiy/,$(INPUT_OBJECTS)) \
	$(addprefix input/obj/z80n/,$(INPUT_OBJECTS)) \
	$(addprefix input/obj/8080/,$(INPUT_OBJECTS)) \
	$(addprefix input/obj/z180/,$(INPUT_OBJECTS)) \
	$(addprefix input/obj/r4k/,$(INPUT_OBJECTS)) \
	$(addprefix input/obj/kc160/,$(INPUT_OBJECTS)) \
	$(addprefix input/obj/ez80_z80/,$(INPUT_OBJECTS)) 

OBJS += $(INPUT_OBJS)
CLEAN += input-clean

input: $(INPUT_OBJS)

.PHONY: input input-clean

$(eval $(call buildbit,input,z80,test))
$(eval $(call buildbit,input,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,input,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,input,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,input,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,input,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,input,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,input,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,input,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,input,kc160,test,-clib=kc160,-mkc160))



input-clean:
	$(RM) -fr input/obj input/*.o
