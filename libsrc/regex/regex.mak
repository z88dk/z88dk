
REGEX_CFILES = $(notdir $(wildcard regex/*.c))
REGEX_AFILES = $(notdir $(wildcard regex/*.asm))

REGEX_OBJECTS = $(REGEX_CFILES:.c=.o) $(REGEX_AFILES:.asm=.o)

REGEX_OBJS = $(addprefix regex/obj/z80/, $(REGEX_OBJECTS)) $(addprefix regex/obj/r2k/,$(REGEX_OBJECTS)) $(addprefix regex/obj/ixiy/,$(REGEX_OBJECTS))  $(addprefix regex/obj/z80n/,$(REGEX_OBJECTS)) $(addprefix regex/obj/8080/,$(REGEX_OBJECTS))  $(addprefix regex/obj/gbz80/,$(REGEX_OBJECTS))

OBJS += $(REGEX_OBJS)
CLEAN += regex-clean

regex: $(REGEX_OBJS)

.PHONY: regex regex-clean

$(eval $(call buildbit,regex,z80,test))
$(eval $(call buildbit,regex,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,regex,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,regex,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,regex,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,regex,z80n,test,-clib=z80n,-mz80n))


regex-clean:
	$(RM) -fr regex/obj regex/*.o
