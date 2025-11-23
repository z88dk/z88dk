;       Z88 Small C+ Run time Library
;       l_gint6sp variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint6sp

l_gint6sp:
   ld hl,8
   add hl,sp
   ld a,(hl+)
   ld h,(hl)
   ld l,a

   ret
