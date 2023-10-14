
ZX7_CFILES := $(notdir $(wildcard compress/zx7/*.c))
ZX7_AFILES := $(notdir $(wildcard compress/zx7/*.asm))


ZX7_OBJECTS := $(ZX7_CFILES:.c=.o) $(ZX7_AFILES:.asm=.o)

ZX7_OBJS := $(addprefix compress/zx7/obj/z80/, $(ZX7_OBJECTS)) \
	$(addprefix compress/zx7/obj/r2ka/,$(ZX7_OBJECTS)) \
	$(addprefix compress/zx7/obj/r4k/,$(ZX7_OBJECTS)) \
	$(addprefix compress/zx7/obj/ixiy/,$(ZX7_OBJECTS)) \
	$(addprefix compress/zx7/obj/z80n/,$(ZX7_OBJECTS)) \
	$(addprefix compress/zx7/obj/gbz80/,$(ZX7_OBJECTS)) \
	$(addprefix compress/zx7/obj/z180/,$(ZX7_OBJECTS)) \
	$(addprefix compress/zx7/obj/ez80_z80/,$(ZX7_OBJECTS))  \
	$(addprefix compress/zx7/obj/kc160/,$(ZX7_OBJECTS)) 


OBJS += $(ZX7_OBJS) 
CLEAN += compress-zx7-clean

compress-zx7: $(ZX7_OBJS) $(ZX7_NEWLIB_TARGETS)

.PHONY: compress-zx7 compress-zx7-clean

$(eval $(call buildbit,compress/zx7,z80,test))
$(eval $(call buildbit,compress/zx7,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,compress/zx7,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,compress/zx7,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,compress/zx7,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,compress/zx7,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,compress/zx7,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,compress/zx7,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,compress/zx7,kc160,test,-clib=kc160,-mkc160))


compress-zx7-clean:
	$(RM) -fr compress/zx7/obj compress/zx7/*.o
