;       Z88 Small C+ Run Time Library 
;       l_glong variant to be used sometimes by the peephole optimizer


SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_glongsp


.l_glongsp
   add	hl,sp
   inc hl
   inc hl
   defb $ed, $07	;ld bc,(hl)
   inc hl
   inc hl
   defb $ed, $17	;ld de,(hl)

   pop  hl	;Return address
   push de
   push bc
   push hl
   ld   h,b
   ld   l,c
   ret
