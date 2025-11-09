TIME_AFILES := 
TIME_CFILES := $(patsubst %,cimpl/%,$(notdir $(wildcard time/cimpl/*.c)))


TIME_OBJECTS := $(TIME_CFILES:.c=.o) $(TIME_AFILES:.asm=.o)

TIME_GLOBS := "time/c/sccz80/*.asm" "time/z80/*.asm" \

TIME_GLOBS_ex := \
		time/z80/*.asm \
		time/c/sccz80/*.asm 


TIME_TARGETS := time/obj/newlib-z80-time \
		time/obj/newlib-8080-time \
		time/obj/newlib-8085-time \
		time/obj/newlib-gbz80-time \
		time/obj/newlib-z80n-time \
		time/obj/newlib-r2ka-time \
		time/obj/newlib-r4k-time \
		time/obj/newlib-kc160-time \
		time/obj/newlib-z180-time \
		time/obj/newlib-ez80_z80-time \
		time/obj/newlib-kc160-time \
		time/obj/newlib-ixiy-time  

TIME_OBJECTS := $(TIME_CFILES:.c=.o) $(TIME_AFILES:.asm=.o)

TIME_OBJS := $(addprefix time/obj/z80/, $(TIME_OBJECTS)) \
	$(addprefix time/obj/8080/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/8085/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/gbz80/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/ixiy/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/z80n/,$(TIME_OBJECTS)) \
	$(addprefix time/obj/r2ka/, $(TIME_OBJECTS)) \
	$(addprefix time/obj/r4k/, $(TIME_OBJECTS)) \
	$(addprefix time/obj/z180/, $(TIME_OBJECTS)) \
	$(addprefix time/obj/ez80_z80/, $(TIME_OBJECTS)) \
	$(addprefix time/obj/kc160/, $(TIME_OBJECTS))


OBJS += $(TIME_OBJS) $(TIME_TARGETS)
CLEAN += time-clean

time: $(TIME_OBJS) $(TIME_TARGETS)

.PHONY: time time-clean

$(eval $(call buildbit,time,z80,test))
$(eval $(call buildbit,time,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,time,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,time,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,time,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,time,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,time,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,time,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,time,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,time,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,time,kc160,test,-clib=kc160,-mkc160))

$(eval $(call buildnew,time,z80,-mz80,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,r2ka,-mr2ka,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,r4k,-mr4k,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,z80n,-mz80n,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,ixiy,-mz80 -IXIY,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,8080,-m8080,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,8085,-m8085,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,gbz80,-mgbz80,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,z180,-mz180,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,ez80_z80,-mez80_z80,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,time,kc160,-mkc160,$(TIME_GLOBS),$(TIME_GLOBS_ex)))


time-clean:
	$(RM) -fr time/obj 
