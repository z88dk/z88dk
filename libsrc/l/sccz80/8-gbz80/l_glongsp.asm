;       Z88 Small C+ Run Time Library 
;       l_glong variant to be used sometimes by the peephole optimizer


SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_glongsp


.l_glongsp
   add	hl,sp
   inc hl
   inc hl
   ld a,(hl+)
   ld c,a
   ld a,(hl+)
   ld b,a
   ld a,(hl+)
   ld e,a
   ld a,(hl+)
   ld d,a

   pop  hl	;Return address
   push de
   push bc
   push hl
   ld   hl,bc
   ret
