;       Z88 Small C+ Run time Library
;       l_gint1sp variant to be used sometimes by the peephole optimizer
;       8085: ld de,sp+* / ld hl,(de)

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint1sp

l_gint1sp:
   push de
   ld de,sp+5
   ld hl,(de)
   pop de
   ret
