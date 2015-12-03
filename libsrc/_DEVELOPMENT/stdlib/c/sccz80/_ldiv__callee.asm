
; void _ldiv_(ldiv_t *ld, long numer, long denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ldiv__callee

EXTERN asm__ldiv

_ldiv__callee:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   exx
   pop bc
   push af
   
   jp asm__ldiv
