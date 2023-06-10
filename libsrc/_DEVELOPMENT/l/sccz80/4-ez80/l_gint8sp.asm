;       Z88 Small C+ Run time Library
;       l_gint8sp variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint8sp

l_gint8sp:
   ld hl,10
   add hl,sp
   ld hl,(hl)

   ret
