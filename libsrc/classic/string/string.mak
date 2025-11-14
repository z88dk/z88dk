string_AFILES := memopd.asm memopd_callee.asm memopi.asm memopi_callee.asm memops.asm $(wildcard classic/string/_*.asm)
string_CFILES := 

string_8080_AFILES := 
string_GBZ80_AFILES := 

string_OBJECTS := $(string_CFILES:.c=.o) $(string_AFILES:.asm=.o)
string_8080_OBJECTS := $(string_CFILES:.c=.o) $(string_8080_AFILES:.asm=.o)
string_GBZ80_OBJECTS := $(string_CFILES:.c=.o) $(string_GBZ80_AFILES:.asm=.o)


string_OBJECTS := $(string_CFILES:.c=.o) $(string_AFILES:.asm=.o)

string_OBJS := $(addprefix classic/string/obj/z80/, $(string_OBJECTS)) \
	$(addprefix classic/string/obj/r2ka/,$(string_OBJECTS)) \
	$(addprefix classic/string/obj/r4k/,$(string_OBJECTS)) \
	$(addprefix classic/string/obj/ixiy/,$(string_OBJECTS)) \
	$(addprefix classic/string/obj/z80n/,$(string_OBJECTS)) \
	$(addprefix classic/string/obj/8080/,$(string_8080_OBJECTS)) \
	$(addprefix classic/string/obj/8085/,$(string_8080_OBJECTS)) \
	$(addprefix classic/string/obj/gbz80/,$(string_GBZ80_OBJECTS)) \
	$(addprefix classic/string/obj/z180/,$(string_OBJECTS)) \
	$(addprefix classic/string/obj/ez80_z80/,$(string_OBJECTS))  \
	$(addprefix classic/string/obj/kc160/,$(string_OBJECTS)) 

OBJS += $(string_OBJS) 
CLEAN += classic-string-clean

classic-string: $(string_OBJS) 

.PHONY: classic-string classic-string-clean

$(eval $(call buildbit,classic/string,z80,test))
$(eval $(call buildbit,classic/string,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/string,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/string,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/string,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/string,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/string,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/string,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/string,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/string,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/string,kc160,test,-clib=kc160,-mkc160))


classic-string-clean:
	$(RM) -fr string/obj 
