
INPUT_CFILES := $(notdir $(wildcard classic/input/*.c))
INPUT_AFILES := $(notdir $(wildcard classic/input/*.asm))

INPUT_OBJECTS := $(INPUT_CFILES:.c=.o) $(INPUT_AFILES:.asm=.o)

INPUT_OBJS := $(addprefix classic/input/obj/z80/, $(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/r2ka/,$(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/ixiy/,$(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/z80n/,$(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/8080/,$(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/8085/,$(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/z180/,$(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/r4k/,$(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/kc160/,$(INPUT_OBJECTS)) \
	$(addprefix classic/input/obj/ez80_z80/,$(INPUT_OBJECTS)) 

OBJS += $(INPUT_OBJS)
CLEAN += classic-input-clean

input: $(INPUT_OBJS)

.PHONY: classic-input classic-input-clean

$(eval $(call buildbit,classic/input,z80,test))
$(eval $(call buildbit,classic/input,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/input,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/input,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/input,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/input,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/input,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/input,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/input,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/input,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/input,kc160,test,-clib=kc160,-mkc160))



classic-input-clean:
	$(RM) -fr classic/input/obj classic/input/*.o
