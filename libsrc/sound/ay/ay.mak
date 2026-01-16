SOUND_AY_AFILES := 
SOUND_AY_CFILES := $(patsubst %,cimpl/%,$(notdir $(wildcard sound/ay/cimpl/*.c)))

SOUND_AY_R2KA_AFILES := 
SOUND_AY_R2KA_CFILES := $(patsubst %,cimpl/%,$(notdir $(wildcard sound/ay/cimpl/*.c)))


SOUND_AY_OBJECTS := $(SOUND_AY_CFILES:.c=.o) $(SOUND_AY_AFILES:.asm=.o)
SOUND_AY_R2KA_OBJECTS := $(SOUND_AY_R2KA_CFILES:.c=.o) $(SOUND_AY_R2KA_AFILES:.asm=.o)

SOUND_AY_GLOBS := "sound/ay/c/sccz80/wyz/*.asm" "sound/ay/z80/wyz/*.asm" \
		 "sound/ay/z80/vt2/*.asm" \
		"sound/ay/c/sccz80/arkos/*.asm" \
		"sound/ay/c/c/*.asm" 

SOUND_AY_GLOBS_ex := sound/ay/c/sccz80/wyz/*.asm sound/ay/z80/wyz/*.asm \
		sound/ay/z80/vt2/*.asm \
		sound/ay/c/sccz80/arkos/*.asm \
		sound/ay/c/c/*.asm


SOUND_AY_TARGETS := sound/ay/obj/newlib-z80-sound-ay \
		sound/ay/obj/newlib-8080-sound-ay \
		sound/ay/obj/newlib-8085-sound-ay \
		sound/ay/obj/newlib-gbz80-sound-ay \
		sound/ay/obj/newlib-z80n-sound-ay \
		sound/ay/obj/newlib-ixiy-sound-ay  

SOUND_AY_OBJECTS := $(SOUND_AY_CFILES:.c=.o) $(SOUND_AY_AFILES:.asm=.o)

SOUND_AY_OBJS := $(addprefix sound/ay/obj/z80/, $(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/8080/,$(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/8085/,$(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/gbz80/,$(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/ixiy/,$(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/z80n/,$(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/r2ka/, $(SOUND_AY_R2KA_OBJECTS)) \
	$(addprefix sound/ay/obj/r4k/, $(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/z180/, $(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/ez80_z80/, $(SOUND_AY_OBJECTS)) \
	$(addprefix sound/ay/obj/kc160/, $(SOUND_AY_OBJECTS))


OBJS += $(SOUND_AY_OBJS) $(SOUND_AY_TARGETS)
CLEAN += sound-ay-clean

sound-ay: $(SOUND_AY_OBJS) $(SOUND_AY_TARGETS)

.PHONY: sound-ay sound-ay-clean

$(eval $(call buildbit,sound/ay,z80,test))
$(eval $(call buildbit,sound/ay,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,sound/ay,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,sound/ay,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,sound/ay,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,sound/ay,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,sound/ay,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,sound/ay,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,sound/ay,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,sound/ay,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,sound/ay,kc160,test,-clib=kc160,-mkc160))

$(eval $(call buildnew,sound/ay,z80,-mz80,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,r2ka,-mr2ka,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,r4k,-mr4k,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,z80n,-mz80n,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,ixiy,-mz80 -IXIY,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,8080,-m8080,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,8085,-m8085,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,gbz80,-mgbz80,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,z180,-mz180,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,ez80_z80,-mez80_z80,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))
$(eval $(call buildnew,sound/ay,kc160,-mkc160,$(SOUND_AY_GLOBS),$(SOUND_AY_GLOBS_ex)))


sound-ay-clean:
	$(RM) -fr sound/ay/obj 
