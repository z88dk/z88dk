
; void _ldiv_(ldiv_t *ld, long numer, long denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ldiv_

EXTERN asm__ldiv

_ldiv_:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   exx
   pop bc
   
   push bc
   push de
   push hl
   push de
   push hl
   push af
   
   jp asm__ldiv
