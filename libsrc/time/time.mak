
TIME_CFILES := $(notdir $(wildcard time/*.c))
TIME_AFILES := $(notdir $(wildcard time/*.asm))

TIME_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/time/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/time/z80/*.asm"
TIME_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/time/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/time/z80/*.asm

TIME_NEWLIB_TARGETS := time/obj/newlib-z80-time \
		time/obj/newlib-z80n-time \
		time/obj/newlib-r2ka-time \
		time/obj/newlib-ixiy-time \
		time/obj/newlib-8080-time \
		time/obj/newlib-gbz80-time \
		time/obj/newlib-ez80_z80-time \
		time/obj/newlib-z180-time \
		time/obj/newlib-r4k-time \
		time/obj/newlib-kc160-time

TIME_OBJECTS := $(TIME_CFILES:.c=.o) $(TIME_AFILES:.asm=.o)

TIME_OBJS := $(addprefix time/obj/z80/, $(TIME_OBJECTS)) \
	$(addprefix time/obj/r2ka/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/ixiy/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/z80n/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/8080/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/gbz80/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/ez80_z80/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/z180/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/r4k/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/kc160/,$(TIME_OBJECTS))


OBJS += $(TIME_OBJS) $(TIME_NEWLIB_TARGETS)
CLEAN += time-clean

time: $(TIME_OBJS) $(TIME_NEWLIB_TARGETS)

.PHONY: time time-clean

$(eval $(call buildbit,time,z80,test))
$(eval $(call buildbit,time,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,time,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,time,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,time,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,time,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,time,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,time,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,time,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,time,kc160,test,-clib=kc160,-mkc160))

$(eval $(call buildnew,time,z80,-mz80,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,r2ka,-mr2ka,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,r4k,-mr4k,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,z80n,-mz80n,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,ixiy,-mz80 -IXIY,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,8080,-m8080,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,gbz80,-mgbz80,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,z180,-mz180,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,ez80_z80,-mez80_z80,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,time,kc160,-mkc160,$(TIME_NEWLIBGLOBS),$(TIME_NEWLIBGLOBS_ex)))

time-clean:
	$(RM) -fr time/obj time/*.o
