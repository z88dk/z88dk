
include ../../Make.config

NEWLIB_ROOT=../../

# Expand a @list-file into its source closure so make can see what a crt0
# actually depends on. The result is cached in obj/<cpu>-crt0.d, which is
# regenerated only when one of the .lst files it walked changes.
LSTDEPS_AWK = $(Z88DK_LIBSRC)lstdeps.awk
LSTDEPS     = NEWLIB_ROOT=$(NEWLIB_ROOT) awk -v INC=.. -v EMIT_LSTS=1 -f $(LSTDEPS_AWK)

CRT0S = z80 ixiy z80n 8080 8085 gbz80 z180 ez80_z80 r2ka r4k kc160

# this directory's path as seen from libsrc/, for the parent-facing depfiles
CRT0_RELDIR = classic/z80_crt0s

all: $(addprefix obj/,$(addsuffix -crt0,$(CRT0S))) \
     $(addprefix obj/,$(addsuffix -crt0.parent.d,$(CRT0S)))

# $(1) = cpu tag / obj subdir
# $(2) = -O output directory  (the trailing components are eaten by the
#        ../../ that every path in the .lst files carries)
# $(3) = list file
# $(4) = assembler flags
define crt0
obj/$(strip $(1))-crt0.d: $(strip $(3)) $$(LSTDEPS_AWK) | obj
	$(Q)( $$(LSTDEPS)                $(strip $(3)) | sed 's|^|obj/$(strip $(1))-crt0: |'; \
	      $$(LSTDEPS) -v ONLY_LSTS=1 $(strip $(3)) | sed 's|^|obj/$(strip $(1))-crt0.d: |' ) > $$@

# The same edges, respelled relative to libsrc/ so the parent makefile can
# see them and know when to relink <cpu>_crt0.lib. Prerequisites are
# normalised rather than just prefixed: "../../l/x.asm" becomes "l/x.asm",
# not "classic/z80_crt0s/../../l/x.asm", so a source has ONE name in the
# graph whether it is reached from here or from $(OBJS).
obj/$(strip $(1))-crt0.parent.d: obj/$(strip $(1))-crt0.d
	$(Q)sed -e 's|^\(.*\): \.\./\.\./|$$(CRT0_RELDIR)/\1: |' \
	        -e 't' \
	        -e 's|^\(.*\): |$$(CRT0_RELDIR)/\1: $$(CRT0_RELDIR)/|' $$< > $$@

obj/$(strip $(1))-crt0: | obj
	NEWLIB_ROOT=$$(NEWLIB_ROOT) $$(ASSEMBLER) -d -O$(strip $(2)) -I.. $(strip $(4)) @$(strip $(3))
	@touch $$@

-include obj/$(strip $(1))-crt0.d
endef

$(eval $(call crt0,z80,     obj/z80/z80/z80,          crt0_z80.lst,   -D__SDCC_IX -D__CLASSIC -mz80))
$(eval $(call crt0,ixiy,    obj/ixiy/ixiy/ixiy,       crt0_z80.lst,   -IXIY -D__SDCC_IX -D__CLASSIC))
$(eval $(call crt0,z80n,    obj/z80n/z80n/z80n,       crt0_z80n.lst,  -D__SDCC_IX -D__CLASSIC -mz80n))
$(eval $(call crt0,8080,    obj/8080/8080/8080,       crt0_8080.lst,  -DCPU_8080 -D__CLASSIC -m8080))
$(eval $(call crt0,8085,    obj/8085/8085/8085,       crt0_8085.lst,  -DCPU_8085 -D__CLASSIC -m8085))
$(eval $(call crt0,gbz80,   obj/gbz80/gbz80/gbz80,    crt0_gbz80.lst, -DCPU_GBZ80 -D__CLASSIC -mgbz80))
$(eval $(call crt0,z180,    obj/z180/z180/z180,       crt0_z180.lst,  -D__SDCC_IX -D__CLASSIC -mz180))
$(eval $(call crt0,ez80_z80,obj/ez80_z80/ez80/ez80,   crt0_ez80.lst,  -D__SDCC_IX -D__CLASSIC -mez80_z80 -DEZ80))
$(eval $(call crt0,r2ka,    obj/r2ka/r2ka/r2ka,       crt0_r2ka.lst,  -D__SDCC_IX -D__CLASSIC -mr2ka))
$(eval $(call crt0,r4k,     obj/r4k/r4k/r4k,          crt0_r2ka.lst,  -D__SDCC_IX -D__CLASSIC -mr4k))
$(eval $(call crt0,kc160,   obj/kc160/kc160/kc160,    crt0_kc160.lst, -D__SDCC_IX -D__CLASSIC -mkc160))

obj:
	@mkdir -p obj

clean:
	@$(RM) -r obj
