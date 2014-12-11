
; void _ldiv_(ldiv_t *ld, long numer, long denom)

SECTION code_stdlib

PUBLIC __ldiv_

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
   exx
   push de
   push hl
   exx
   push bc
   push af
   
   INCLUDE "stdlib/z80/asm__ldiv.asm"
