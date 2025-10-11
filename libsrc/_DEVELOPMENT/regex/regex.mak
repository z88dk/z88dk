
REGEX_CFILES :=  $(notdir $(wildcard _DEVELOPMENT/regex/*.c))
REGEX_AFILES :=  $(notdir $(wildcard _DEVELOPMENT/regex/*.asm))

REGEX_OBJECTS := $(REGEX_CFILES:.c=.o) $(REGEX_AFILES:.asm=.o)

REGEX_OBJS := $(addprefix _DEVELOPMENT/regex/obj/z80/, $(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/r2ka/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/ixiy/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/z80n/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/8080/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/8085/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/gbz80/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/ez80_z80/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/z180/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/r4k/,$(REGEX_OBJECTS)) \
	$(addprefix _DEVELOPMENT/regex/obj/kc160/,$(REGEX_OBJECTS))

OBJS += $(REGEX_OBJS)
CLEAN += regex-clean

regex: $(REGEX_OBJS)

.PHONY: regex regex-clean

$(eval $(call buildbit,_DEVELOPMENT/regex,z80,test))
$(eval $(call buildbit,_DEVELOPMENT/regex,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,_DEVELOPMENT/regex,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,_DEVELOPMENT/regex,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,_DEVELOPMENT/regex,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,_DEVELOPMENT/regex,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,_DEVELOPMENT/regex,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,_DEVELOPMENT/regex,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,_DEVELOPMENT/regex,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,_DEVELOPMENT/regex,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,_DEVELOPMENT/regex,kc160,test,-clib=kc160,-mkc160))


regex-clean:
	$(RM) -fr _DEVELOPMENT/regex/obj 
