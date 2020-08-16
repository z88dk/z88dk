;       Z88 Small C+ Run Time Library 
;       l_glong variant to be used sometimes by the peephole optimizer
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_glongsp

l_glongsp:

   add	hl,sp
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl
   pop bc
   push de
   push hl
   push bc
   ret
