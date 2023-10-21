
REGEX_CFILES := $(notdir $(wildcard regex/*.c))
REGEX_AFILES := $(notdir $(wildcard regex/*.asm))

REGEX_OBJECTS := $(REGEX_CFILES:.c=.o) $(REGEX_AFILES:.asm=.o)

REGEX_OBJS := $(addprefix regex/obj/z80/, $(REGEX_OBJECTS)) \
	$(addprefix regex/obj/r2ka/,$(REGEX_OBJECTS)) \
	$(addprefix regex/obj/ixiy/,$(REGEX_OBJECTS)) \
	$(addprefix regex/obj/z80n/,$(REGEX_OBJECTS)) \
	$(addprefix regex/obj/8080/,$(REGEX_OBJECTS)) \
	$(addprefix regex/obj/gbz80/,$(REGEX_OBJECTS)) \
	$(addprefix regex/obj/ez80_z80/,$(REGEX_OBJECTS)) \
	$(addprefix regex/obj/z180/,$(REGEX_OBJECTS)) \
	$(addprefix regex/obj/r4k/,$(REGEX_OBJECTS)) \
	$(addprefix regex/obj/kc160/,$(REGEX_OBJECTS))

OBJS += $(REGEX_OBJS)
CLEAN += regex-clean

regex: $(REGEX_OBJS)

.PHONY: regex regex-clean

$(eval $(call buildbit,regex,z80,test))
$(eval $(call buildbit,regex,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,regex,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,regex,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,regex,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,regex,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,regex,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,regex,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,regex,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,regex,kc160,test,-clib=kc160,-mkc160))


regex-clean:
	$(RM) -fr regex/obj regex/*.o
