# crt0 objects, built directly into libsrc's own dependency graph.
#
# This was a recursive $(MAKE) -C classic/z80_crt0s. Running the assembler from
# libsrc/ instead removes two pieces of machinery that only existed to bridge
# the two make processes:
#
#   - obj/<cpu>-crt0.parent.d, a second dependency pass whose only job was to
#     respell the sub-make's paths as libsrc-relative ones. lstdeps.awk run
#     from here emits those paths directly.
#   - the serialisation. Eleven crt0 stamps meant up to eleven concurrent
#     sub-makes into one directory, so the crt0 libraries were chained
#     (z80 -> ez80_z80 -> ... -> kc160) to keep them apart. With one make
#     process there is nothing to serialise and the chain is gone.
#
# Paths inside a z80asm @list-file resolve against the list file's own
# directory, so the .lst files keep their ../../ spellings unchanged; only the
# assembler's cwd moves. NEWLIB_ROOT is the prefix the l/*.lst files apply to
# their entries and is empty here because libsrc/ is already the root.

CRT0_DIR    = classic/z80_crt0s
CRT0S       = z80 ixiy z80n 8080 8085 gbz80 z180 ez80_z80 r2ka r4k kc160

# NEWLIB_ROOT is the prefix the l/*.lst files apply to their entries. It must
# end in a slash: those files are inconsistent, spelling entries both as
# ${NEWLIB_ROOT}l/x and ${NEWLIB_ROOT}/l/x, and only a trailing slash makes both
# resolve (the second becomes .//l/x, which normalises). It was ../../ when this
# ran from classic/z80_crt0s; from libsrc/ the root is ./ -- not empty.
CRT0_ROOT   = ./

LSTDEPS_AWK = lstdeps.awk
LSTDEPS     = NEWLIB_ROOT=$(CRT0_ROOT) awk -v INC=classic -v EMIT_LSTS=1 -f $(LSTDEPS_AWK)

# lstdeps resolves a name against the include path, so entries reached through
# this directory come back as classic/z80_crt0s/../../arch/x.asm, and the root
# prefix above leaves a ./ on the rest. Collapse both, as z80asm's own
# norm_filename does, so a source has ONE name in the graph whether it is
# reached from here or from $(OBJS). Getting this wrong does not fail loudly --
# it silently splits the node in two and the crt0 libraries stop relinking when
# their sources change.
NORMDEPS    = sed -e 's|//*|/|g' -e ':a' -e 's|[^/][^/]*/\.\./||' -e 'ta' -e 's|^\./||'

# Stamp file standing in for "this cpu's crt0 objects are up to date".
CRT0_STAMP  = $(CRT0_DIR)/obj/$(1)-crt0

# $(1) = cpu tag / obj subdir
# $(2) = list file, relative to $(CRT0_DIR)
# $(3) = assembler flags
define crt0
$(CRT0_DIR)/obj/$(strip $(1))-crt0.d: $(CRT0_DIR)/$(strip $(2)) $$(LSTDEPS_AWK) | $(CRT0_DIR)/obj
	$(Q)( $$(LSTDEPS)                $(CRT0_DIR)/$(strip $(2)) | $$(NORMDEPS) | sed 's|^|$(CRT0_DIR)/obj/$(strip $(1))-crt0: |'; \
	      $$(LSTDEPS) -v ONLY_LSTS=1 $(CRT0_DIR)/$(strip $(2)) | $$(NORMDEPS) | sed 's|^|$(CRT0_DIR)/obj/$(strip $(1))-crt0.d: |' ) > $$@

$(CRT0_DIR)/obj/$(strip $(1))-crt0: | $(CRT0_DIR)/obj
	$(Q)NEWLIB_ROOT=$$(CRT0_ROOT) $$(ASSEMBLER) -d -O$(CRT0_DIR)/obj/$(strip $(1)) -Iclassic $(strip $(3)) @$(CRT0_DIR)/$(strip $(2))
	@touch $$@

-include $(CRT0_DIR)/obj/$(strip $(1))-crt0.d
endef

$(eval $(call crt0,z80,      crt0_z80.lst,   -D__SDCC_IX -D__CLASSIC -mz80))
$(eval $(call crt0,ixiy,     crt0_z80.lst,   -IXIY -D__SDCC_IX -D__CLASSIC))
$(eval $(call crt0,z80n,     crt0_z80n.lst,  -D__SDCC_IX -D__CLASSIC -mz80n))
$(eval $(call crt0,8080,     crt0_8080.lst,  -DCPU_8080 -D__CLASSIC -m8080))
$(eval $(call crt0,8085,     crt0_8085.lst,  -DCPU_8085 -D__CLASSIC -m8085))
$(eval $(call crt0,gbz80,    crt0_gbz80.lst, -DCPU_GBZ80 -D__CLASSIC -mgbz80))
$(eval $(call crt0,z180,     crt0_z180.lst,  -D__SDCC_IX -D__CLASSIC -mz180))
$(eval $(call crt0,ez80_z80, crt0_ez80.lst,  -D__SDCC_IX -D__CLASSIC -mez80_z80 -DEZ80))
$(eval $(call crt0,r2ka,     crt0_r2ka.lst,  -D__SDCC_IX -D__CLASSIC -mr2ka))
$(eval $(call crt0,r4k,      crt0_r2ka.lst,  -D__SDCC_IX -D__CLASSIC -mr4k))
$(eval $(call crt0,kc160,    crt0_kc160.lst, -D__SDCC_IX -D__CLASSIC -mkc160))

$(CRT0_DIR)/obj:
	@mkdir -p $@

CLEAN += crt0s-clean

.PHONY: crt0s-clean

crt0s-clean:
	$(RM) -r $(CRT0_DIR)/obj
