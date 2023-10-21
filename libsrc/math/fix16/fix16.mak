
FIX16_CFILES = $(patsubst %,cimpl/%,$(notdir $(wildcard math/fix16/cimpl/*.c)))
FIX16_AFILES = $(patsubst %,c/sccz80/%,$(notdir $(wildcard math/fix16/c/sccz80/*.asm))) \
		$(patsubst %,z80/%,$(notdir $(wildcard math/fix16/z80/*.asm)))


FIX16_OBJECTS = $(FIX16_CFILES:.c=.o) $(FIX16_AFILES:.asm=.o)

FIX16_OBJS = $(addprefix math/fix16/obj/z80/, $(FIX16_OBJECTS)) \
	$(addprefix math/fix16/obj/r2ka/,$(FIX16_OBJECTS)) \
	$(addprefix math/fix16/obj/r4k/,$(FIX16_OBJECTS)) \
	$(addprefix math/fix16/obj/ixiy/,$(FIX16_OBJECTS)) \
	$(addprefix math/fix16/obj/z80n/,$(FIX16_OBJECTS))  \
	$(addprefix math/fix16/obj/z180/,$(FIX16_OBJECTS))  \
	$(addprefix math/fix16/obj/ez80_z80/,$(FIX16_OBJECTS)) \
	$(addprefix math/fix16/obj/kc160/,$(FIX16_OBJECTS))

OBJS += $(FIX16_OBJS)
CLEAN += fix16-clean

fix16: $(FIX16_OBJS)

.PHONY: math/fix16 math/fix16-clean

$(eval $(call buildbit,math/fix16,z80,test))
$(eval $(call buildbit,math/fix16,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,math/fix16,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,math/fix16,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,math/fix16,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,math/fix16,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,math/fix16,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,math/fix16,kc160,test,-clib=kc160,-mkc160))


fix16-clean:
	$(RM) -fr math/fix16/obj math/fix16/*.o
