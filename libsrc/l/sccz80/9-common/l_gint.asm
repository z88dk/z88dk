;       Z88 Small C+ Run time Library
;       l_gint variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint, l_gint1, l_gint2, l_gint3

l_gint3:
   inc hl
l_gint2:
   inc hl
l_gint1:
   inc hl
l_gint:

   ld a,(hl+)
   ld h,(hl)
   ld l,a
   
   ret
