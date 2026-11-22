;       Z88 Small C+ Run time Library
;       l_gint4 variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint4

l_gint4:
   ld bc,4
   add hl,bc
   ld hl,(hl)

   ret
