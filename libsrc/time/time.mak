
TIME_CFILES = $(notdir $(wildcard time/*.c))
TIME_AFILES = $(notdir $(wildcard time/*.asm))

TIME_OBJECTS = $(TIME_CFILES:.c=.o) $(TIME_AFILES:.asm=.o)

TIME_OBJS = $(addprefix time/obj/z80/, $(TIME_OBJECTS)) $(addprefix time/obj/r2k/,$(TIME_OBJECTS)) $(addprefix time/obj/ixiy/,$(TIME_OBJECTS))  $(addprefix time/obj/z80n/,$(TIME_OBJECTS)) $(addprefix time/obj/8080/,$(TIME_OBJECTS))  $(addprefix time/obj/gbz80/,$(TIME_OBJECTS))

OBJS += $(TIME_OBJS)
DIRS += time-dirs
CLEAN += time-clean

time: time-dirs $(TIME_OBJS)

.PHONY: time time-dirs time-clean

$(eval $(call buildbit,time,z80,test))
$(eval $(call buildbit,time,ixiy,test,-Ca-IXIY))
$(eval $(call buildbit,time,8080,test,-clib=8080))
$(eval $(call buildbit,time,gbz80,test,-clib=gbz80))
$(eval $(call buildbit,time,r2k,test,-clib=rabbit))
$(eval $(call buildbit,time,z80n,test,-clib=z80n))


time-dirs:
	@mkdir -p time/obj/z80 time/obj/r2k time/obj/8080 time/obj/gbz80 time/obj/z80n time/obj/ixiy

time-clean:
	$(RM) -fr time/obj
