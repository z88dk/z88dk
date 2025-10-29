;       Z88 Small C+ Run time Library
;       l_gint1sp variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint1sp

l_gint1sp:
   ld hl,3
   add hl,sp
   ld  hl,(hl)

   ret
