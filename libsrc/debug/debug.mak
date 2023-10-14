
DEBUG_CFILES := $(notdir $(wildcard debug/*.c))
DEBUG_AFILES := $(notdir $(wildcard debug/*.asm))

DEBUG_OBJECTS := $(DEBUG_CFILES:.c=.o) $(DEBUG_AFILES:.asm=.o)

DEBUG_OBJS := $(addprefix debug/obj/z80/, $(DEBUG_OBJECTS)) \
	$(addprefix debug/obj/r2ka/,$(DEBUG_OBJECTS)) \
	$(addprefix debug/obj/r4k/,$(DEBUG_OBJECTS)) \
	$(addprefix debug/obj/ixiy/,$(DEBUG_OBJECTS)) \
	$(addprefix debug/obj/z80n/,$(DEBUG_OBJECTS))  \
	$(addprefix debug/obj/z180/,$(DEBUG_OBJECTS))  \
	$(addprefix debug/obj/ez80_z80/,$(DEBUG_OBJECTS)) \
	$(addprefix debug/obj/kc160/,$(DEBUG_OBJECTS))

OBJS += $(DEBUG_OBJS)
CLEAN += debug-clean

debug: $(DEBUG_OBJS)

.PHONY: debug debug-clean

$(eval $(call buildbit,debug,z80,test))
$(eval $(call buildbit,debug,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,debug,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,debug,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,debug,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,debug,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,debug,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,debug,kc160,test,-clib=kc160,-mkc160))


debug-clean:
	$(RM) -fr debug/obj debug/*.o
