;       Z88 Small C+ Run time Library
;       l_gint8 variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint8

l_gint8:
   ld bc,8
   add hl,bc
   ld  hl,(hl)

   ret
