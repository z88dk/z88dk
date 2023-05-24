
TIME_CFILES = $(notdir $(wildcard time/*.c))
TIME_AFILES = $(notdir $(wildcard time/*.asm))

TIME_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/time/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/time/z80/*.asm"
TIME_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/time/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/time/z80/*.asm

TIME_NEWLIB_TARGETS := time/obj/newlib-z80-time time/obj/newlib-z80n-time time/obj/newlib-r2k-time time/obj/newlib-ixiy-time time/obj/newlib-8080-time time/obj/newlib-gbz80-time

TIME_OBJECTS = $(TIME_CFILES:.c=.o) $(TIME_AFILES:.asm=.o)

TIME_OBJS = $(addprefix time/obj/z80/, $(TIME_OBJECTS)) $(addprefix time/obj/r2k/,$(TIME_OBJECTS)) $(addprefix time/obj/ixiy/,$(TIME_OBJECTS))  $(addprefix time/obj/z80n/,$(TIME_OBJECTS)) $(addprefix time/obj/8080/,$(TIME_OBJECTS))  $(addprefix time/obj/gbz80/,$(TIME_OBJECTS))


OBJS += $(TIME_OBJS) $(TIME_NEWLIB_TARGETS)
CLEAN += time-clean

time: $(TIME_OBJS) $(TIME_NEWLIB_TARGETS)

.PHONY: time time-clean

$(eval $(call buildbit,time,z80,test))
$(eval $(call buildbit,time,ixiy,test,-Ca-IXIY))
$(eval $(call buildbit,time,8080,test,-clib=8080))
$(eval $(call buildbit,time,gbz80,test,-clib=gbz80))
$(eval $(call buildbit,time,r2k,test,-clib=rabbit))
$(eval $(call buildbit,time,z80n,test,-clib=z80n))


time/obj/newlib-z80-time: $(TIME_NEWLIBGLOBS_ex)
	@mkdir -p time/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=time/obj/z80/x -I.. -mz80 -D__CLASSIC $(TIME_NEWLIBGLOBS)

time/obj/newlib-r2k-time: $(TIME_NEWLIBGLOBS_ex)
	@mkdir -p time/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=time/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(TIME_NEWLIBGLOBS)

time/obj/newlib-z80n-time: $(TIME_NEWLIBGLOBS_ex)
	@mkdir -p time/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=time/obj/z80n/x -I.. -mz80n -D__CLASSIC $(TIME_NEWLIBGLOBS)

time/obj/newlib-ixiy-time: $(TIME_NEWLIBGLOBS_ex)
	@mkdir -p time/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=time/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(TIME_NEWLIBGLOBS)

time/obj/newlib-8080-time: $(TIME_NEWLIBGLOBS_ex)
	@mkdir -p time/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=time/obj/8080/x -I.. -m8080 -D__CLASSIC $(TIME_NEWLIBGLOBS)

time/obj/newlib-gbz80-time: $(TIME_NEWLIBGLOBS_ex)
	@mkdir -p time/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=time/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(TIME_NEWLIBGLOBS)

time/obj/%:
	@mkdir -p $@

time-clean:
	$(RM) -fr time/obj
