
; void _ldiv(ldiv_t *ld, long numer, long denom)

XDEF _ldiv

_ldiv:

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
   exx
   push de
   push hl
   exx
   push bc
   push af
   
   INCLUDE "../../z80/asm__ldiv.asm"
