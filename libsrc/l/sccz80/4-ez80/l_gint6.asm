;       Z88 Small C+ Run time Library
;       l_gint6 variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint6

l_gint6:
   ld bc,6
   add hl,bc
   ld  hl,(hl)

   ret
