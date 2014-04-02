
; void _ldiv(ldiv_t *ld, long numer, long denom)

XDEF __ldiv

__ldiv:

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
   
   INCLUDE "stdlib/z80/asm__ldiv.asm"
