
; void _ldiv(ldiv_t *ld, long numer, long denom)

XDEF _ldiv

_ldiv:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push hl
   exx
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm__ldiv.asm"
