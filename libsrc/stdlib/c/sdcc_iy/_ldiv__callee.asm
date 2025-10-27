
; void _ldiv__callee(ldiv_t *ld, long numer, long denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __ldiv__callee

EXTERN asm__ldiv

__ldiv__callee:

   pop af
   pop bc
   exx
   pop hl
   pop de
   exx
   pop hl
   pop de
   push af
   
   jp asm__ldiv
