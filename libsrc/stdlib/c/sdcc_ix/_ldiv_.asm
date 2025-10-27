
; void _ldiv_(ldiv_t *ld, long numer, long denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __ldiv_

EXTERN l0__ldiv__callee

__ldiv_:

   pop af
   pop bc
   exx
   pop hl
   pop de
   exx
   pop hl
   pop de
   
   push de
   push hl
   push de
   push hl
   push bc
   push af

   jp l0__ldiv__callee
