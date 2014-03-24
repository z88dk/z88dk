
; void _ldiv(ldiv_t *ld, long numer, long denom)

XDEF _ldiv_callee

_ldiv_callee:

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
