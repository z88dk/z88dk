NANOS_GLOBS := \
	"target/nanos/graphics/*.asm" \
	"target/nanos/stdio/*.asm" 

NANOS_GLOBS_ex := \
	target/nanos/graphics/*.asm \
	target/nanos/stdio/*.asm 


NANOS_TARGETS := target/nanos/obj/target-nanos-nanos classic/games/obj/.stamp-cpm-nanos classic/gfx/obj/.stamp-cpm-nanos
		

CLEAN += target-nanos-clean
TOCREATE += $(call check_target,nanos,nanos.lib)
$(eval $(call buildtargetasm,target/nanos,z80,nanos,-mz80,$(NANOS_GLOBS),$(NANOS_GLOBS_ex)))

nanos.lib:  $(TARGET_CLIB_DEPS) $(NANOS_TARGETS) classic/gfx/obj/.stamp-h19 classic/gfx/obj/.stamp-h19alt
	TARGET=nanos TYPE=z80 $(LIBLINKER) -mz80 -DFORnanos -x$(OUTPUT_DIRECTORY)/nanos @$(Z88DK_LIBSRC)/target/nanos/nanos.lst
	@touch $@

target-nanos: $(NANOS_TARGETS)

.PHONY: target-nanos target-nanos-clean



target-nanos-clean:
	$(RM) -fr target/nanos/obj
