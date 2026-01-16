;       Z88 Small C+ Run time Library
;       l_gint7 variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint7

l_gint7:
   ld bc,7
   add hl,bc
   ld a,(hl+)
   ld h,(hl)
   ld l,a

   ret
