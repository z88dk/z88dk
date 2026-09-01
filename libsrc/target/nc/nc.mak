NC_GLOBS := \
	"target/nc/*.asm" \
	"target/nc/fcntl/*.asm" \
	"target/nc/games/*.asm" \
	"target/nc/graphics/*.asm" \
	"target/nc/input/*.asm" \
	"target/nc/stdio/*.asm"

NC_GLOBS_ex := \
	target/nc/*.asm \
	target/nc/fcntl/*.asm \
	target/nc/games/*.asm \
	target/nc/graphics/*.asm \
	target/nc/input/*.asm \
	target/nc/stdio/*.asm

NC_CFILES := $(wildcard target/nc/fcntl/*.c)
NC_OFILES := $(addprefix target/nc/obj/nc/,$(NC_CFILES:.c=.o))

NC_TARGETS := target/nc/obj/target-nc-nc $(NC_OFILES) classic/games/obj/.stamp-nc classic/gfx/obj/.stamp-nc
NC100_TARGETS := target/nc/obj/target-nc-nc100 classic/games/obj/.stamp-nc100 classic/gfx/obj/.stamp-nc100
ZCN_TARGETS := target/nc/obj/target-nc-zcn classic/games/obj/.stamp-zcn classic/gfx/obj/.stamp-zcn
NC200_TARGETS := target/nc/obj/target-nc-nc200 classic/games/obj/.stamp-nc200 classic/gfx/obj/.stamp-nc200

CLEAN += target-nc-clean

$(eval $(call gfx_stamp_args,nc,TARGET=nc))
$(eval $(call gfx_stamp_args,nc100,TARGET=nc FLAVOUR=wide SUBTYPE=nc100))
$(eval $(call gfx_stamp_args,zcn,TARGET=nc FLAVOUR=wide SUBTYPE=zcn))
$(eval $(call gfx_stamp_args,nc200,TARGET=nc FLAVOUR=wide SUBTYPE=nc200))

target-nc: $(NC_TARGETS) $(NC100_TARGETS) $(ZCN_TARGETS) $(NC200_TARGETS)

.PHONY: target-nc target-nc-clean

define nc_asm
target/nc/obj/target-nc-$(1): $(NC_GLOBS_ex)
	@mkdir -p target/nc/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/nc/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/nc -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/nc/def -Itarget/nc -Itarget/nc/obj/$(1) -I$$(Z88DK_LIBSRC)/classic -mz80 $(2) -I$$(Z88DK_LIB) -D__CLASSIC $$(NC_GLOBS)
	$$(Q)touch $$@
endef

$(eval $(call nc_asm,nc,-DFORnc))
$(eval $(call nc_asm,nc100,-DFORnc -DFORnc100))
$(eval $(call nc_asm,zcn,-DFORnc -DFORnc100 -DFORzcn))
$(eval $(call nc_asm,nc200,-DFORnc -DFORnc200))

target/nc/obj/nc/target/nc/fcntl/%.o: target/nc/fcntl/%.c
	@mkdir -p $(dir $@)
	$(ZCC) +nc $(CFLAGS) -c -o $@ $<

target-nc-clean:
	$(RM) -fr target/nc/obj
