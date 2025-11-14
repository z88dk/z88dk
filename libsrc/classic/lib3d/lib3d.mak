
lib3d_CFILES := $(notdir $(wildcard classic/lib3d/*.c))
lib3d_AFILES := $(notdir $(wildcard classic/lib3d/*.asm))

lib3d_OBJECTS := $(lib3d_CFILES:.c=.o) $(lib3d_AFILES:.asm=.o)

lib3d_OBJS := $(addprefix classic/lib3d/obj/z80/, $(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/r2ka/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/ixiy/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/z80n/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/8080/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/8085/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/gbz80/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/ez80_z80/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/z180/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/r4k/,$(lib3d_OBJECTS)) \
	$(addprefix classic/lib3d/obj/kc160/,$(lib3d_OBJECTS))

OBJS += $(lib3d_OBJS)
CLEAN += classic-lib3d-clean

classic-lib3d: $(lib3d_OBJS)

.PHONY: classic-lib3d classic-lib3d-clean

$(eval $(call buildbit,classic/lib3d,z80,test))
$(eval $(call buildbit,classic/lib3d,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/lib3d,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/lib3d,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/lib3d,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/lib3d,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/lib3d,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/lib3d,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/lib3d,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/lib3d,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/lib3d,kc160,test,-clib=kc160,-mkc160))


lib3d-clean:
	$(RM) -fr classic/lib3d/obj classic/lib3d/*.o
