
INPUT_CFILES = $(notdir $(wildcard input/*.c))
INPUT_AFILES = $(notdir $(wildcard input/*.asm))

INPUT_OBJECTS = $(INPUT_CFILES:.c=.o) $(INPUT_AFILES:.asm=.o)

INPUT_OBJS = $(addprefix input/obj/z80/, $(INPUT_OBJECTS)) $(addprefix input/obj/r2k/,$(INPUT_OBJECTS)) $(addprefix input/obj/ixiy/,$(INPUT_OBJECTS))  $(addprefix input/obj/z80n/,$(INPUT_OBJECTS)) $(addprefix input/obj/8080/,$(INPUT_OBJECTS)) 

OBJS += $(INPUT_OBJS)
DIRS += input-dirs
CLEAN += input-clean

input: input-dirs $(INPUT_OBJS)

.PHONY: input input-dirs input-clean

$(eval $(call buildbit,input,z80,test))
$(eval $(call buildbit,input,ixiy,test,-Ca-IXIY))
$(eval $(call buildbit,input,8080,test,-clib=8080))
$(eval $(call buildbit,input,gbz80,test,-clib=gbz80))
$(eval $(call buildbit,input,r2k,test,-clib=rabbit))
$(eval $(call buildbit,input,z80n,test,-clib=z80n))


input-dirs:
	@mkdir -p input/obj/z80 input/obj/r2k input/obj/8080 input/obj/gbz80 input/obj/z80n input/obj/ixiy

input-clean:
	$(RM) -fr input/obj
