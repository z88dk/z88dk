
ASSERT_CFILES = $(notdir $(wildcard assert/*.c))
ASSERT_AFILES = $(notdir $(wildcard assert/*.asm))

ASSERT_OBJECTS = $(ASSERT_CFILES:.c=.o) $(ASSERT_AFILES:.asm=.o)

ASSERT_OBJS = $(addprefix assert/obj/z80/, $(ASSERT_OBJECTS)) $(addprefix assert/obj/r2k/,$(ASSERT_OBJECTS)) $(addprefix assert/obj/ixiy/,$(ASSERT_OBJECTS))  $(addprefix assert/obj/z80n/,$(ASSERT_OBJECTS)) $(addprefix assert/obj/8080/,$(ASSERT_OBJECTS))  $(addprefix assert/obj/gbz80/,$(ASSERT_OBJECTS))

OBJS += $(ASSERT_OBJS)
DIRS += assert-dirs
CLEAN += assert-clean

assert: assert-dirs $(ASSERT_OBJS)

.PHONY: assert assert-dirs assert-clean

$(eval $(call buildbit,assert,z80,test))
$(eval $(call buildbit,assert,ixiy,test,-Ca-IXIY))
$(eval $(call buildbit,assert,8080,test,-clib=8080))
$(eval $(call buildbit,assert,gbz80,test,-clib=gbz80))
$(eval $(call buildbit,assert,r2k,test,-clib=rabbit))
$(eval $(call buildbit,assert,z80n,test,-clib=z80n))


assert-dirs:
	@mkdir -p assert/obj/z80 assert/obj/r2k assert/obj/8080 assert/obj/gbz80 assert/obj/z80n assert/obj/ixiy

assert-clean:
	$(RM) -fr assert/obj
