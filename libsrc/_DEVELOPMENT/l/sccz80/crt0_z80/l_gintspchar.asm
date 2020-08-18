;       Z88 Small C+ Run time Library
;       l_gint+l_gchar variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gintspchar

l_gintspchar:

   add hl,sp
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld a,(hl)
   ld l,a
   rlca
   sbc   a,a
   ld h,a
   ret
