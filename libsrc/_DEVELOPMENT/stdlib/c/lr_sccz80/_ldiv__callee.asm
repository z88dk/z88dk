
; void _ldiv_(ldiv_t *ld, long numer, long denom)

PUBLIC _ldiv__callee

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
   
   INCLUDE "stdlib/z80/asm__ldiv.asm"
