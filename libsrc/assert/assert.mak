
ASSERT_CFILES := $(notdir $(wildcard assert/*.c))
ASSERT_AFILES := $(notdir $(wildcard assert/*.asm))

ASSERT_OBJECTS := $(ASSERT_CFILES:.c=.o) $(ASSERT_AFILES:.asm=.o)

ASSERT_OBJS := $(addprefix assert/obj/z80/, $(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/r2ka/,$(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/r4k/,$(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/ixiy/,$(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/z80n/,$(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/8080/,$(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/gbz80/,$(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/z180/,$(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/ez80_z80/,$(ASSERT_OBJECTS)) \
	$(addprefix assert/obj/kc160/,$(ASSERT_OBJECTS))

OBJS += $(ASSERT_OBJS)
CLEAN += assert-clean

assert: $(ASSERT_OBJS)

.PHONY: assert assert-clean

$(eval $(call buildbit,assert,z80,test))
$(eval $(call buildbit,assert,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,assert,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,assert,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,assert,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,assert,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,assert,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,assert,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,assert,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,assert,kc160,test,-clib=kc160,-mkc160))


assert-clean:
	$(RM) -fr assert/obj assert/*.o
