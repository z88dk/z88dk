TIME_AFILES := 
TIME_CFILES := $(patsubst %,cimpl/%,$(notdir $(wildcard _DEVELOPMENT/time/cimpl/*.c)))


TIME_OBJECTS := $(TIME_CFILES:.c=.o) $(TIME_AFILES:.asm=.o)

TIME_GLOBS := "$(NEWLIB_DIRECTORY)/time/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/time/z80/*.asm" \

TIME_GLOBS_ex := \
		$(NEWLIB_DIRECTORY)/time/z80/*.asm \
		$(NEWLIB_DIRECTORY)/time/c/sccz80/*.asm 


TIME_TARGETS := _DEVELOPMENT/time/obj/newlib-z80-time \
		_DEVELOPMENT/time/obj/newlib-8080-time \
		_DEVELOPMENT/time/obj/newlib-8085-time \
		_DEVELOPMENT/time/obj/newlib-gbz80-time \
		_DEVELOPMENT/time/obj/newlib-z80n-time \
		_DEVELOPMENT/time/obj/newlib-ixiy-time  

TIME_OBJECTS := $(TIME_CFILES:.c=.o) $(TIME_AFILES:.asm=.o)

TIME_OBJS := $(addprefix _DEVELOPMENT/time/obj/z80/, $(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/8080/,$(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/8085/,$(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/gbz80/,$(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/ixiy/,$(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/z80n/,$(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/r2ka/, $(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/r4k/, $(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/z180/, $(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/ez80_z80/, $(TIME_OBJECTS)) \
	$(addprefix _DEVELOPMENT/time/obj/kc160/, $(TIME_OBJECTS))


OBJS += $(TIME_OBJS) $(TIME_TARGETS)
CLEAN += time-clean

time: $(TIME_OBJS) $(TIME_TARGETS)

.PHONY: time time-clean

$(eval $(call buildbit,_DEVELOPMENT/time,z80,test))
$(eval $(call buildbit,_DEVELOPMENT/time,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,_DEVELOPMENT/time,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,_DEVELOPMENT/time,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,_DEVELOPMENT/time,gbz80,test,-clib=8085,-m8085))
$(eval $(call buildbit,_DEVELOPMENT/time,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,_DEVELOPMENT/time,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,_DEVELOPMENT/time,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,_DEVELOPMENT/time,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,_DEVELOPMENT/time,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,_DEVELOPMENT/time,kc160,test,-clib=kc160,-mkc160))

$(eval $(call buildnew,_DEVELOPMENT/time,z80,-mz80,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,r2ka,-mr2ka,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,r4k,-mr4k,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,z80n,-mz80n,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,ixiy,-mz80 -IXIY,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,8080,-m8080,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,8085,-m8085,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,gbz80,-mgbz80,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,z180,-mz180,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,ez80_z80,-mez80_z80,$(TIME_GLOBS),$(TIME_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/time,kc160,-mkc160,$(TIME_GLOBS),$(TIME_GLOBS_ex)))


time-clean:
	$(RM) -fr _DEVELOPMENT/time/obj 
