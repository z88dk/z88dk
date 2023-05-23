
REGEX_CFILES = $(notdir $(wildcard regex/*.c))
REGEX_AFILES = $(notdir $(wildcard regex/*.asm))

REGEX_OBJECTS = $(REGEX_CFILES:.c=.o) $(REGEX_AFILES:.asm=.o)

REGEX_OBJS = $(addprefix regex/obj/z80/, $(REGEX_OBJECTS)) $(addprefix regex/obj/r2k/,$(REGEX_OBJECTS)) $(addprefix regex/obj/ixiy/,$(REGEX_OBJECTS))  $(addprefix regex/obj/z80n/,$(REGEX_OBJECTS)) $(addprefix regex/obj/8080/,$(REGEX_OBJECTS))  $(addprefix regex/obj/gbz80/,$(REGEX_OBJECTS))

OBJS += $(REGEX_OBJS)
DIRS += regex-dirs
CLEAN += regex-clean

regex: regex-dirs $(REGEX_OBJS)

.PHONY: regex regex-dirs regex-clean

$(eval $(call buildbit,regex,z80,test))
$(eval $(call buildbit,regex,ixiy,test,-Ca-IXIY))
$(eval $(call buildbit,regex,8080,test,-clib=8080))
$(eval $(call buildbit,regex,gbz80,test,-clib=gbz80))
$(eval $(call buildbit,regex,r2k,test,-clib=rabbit))
$(eval $(call buildbit,regex,z80n,test,-clib=z80n))


regex-dirs:
	@mkdir -p regex/obj/z80/regex regex/obj/r2k/regex regex/obj/8080/regex regex/obj/gbz80/regex regex/obj/z80n/regex regex/obj/ixiy/regex

regex-clean:
	$(RM) -fr regex/obj
