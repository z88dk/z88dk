;       Z88 Small C+ Run time Library
;       l_gint variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gintsp, l_gintsp_gint

l_gintsp:

   add hl,sp
   inc hl
   inc hl

l_gintsp_gint:

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ret
