
; void _ldivu_(ldivu_t *ld, unsigned long numer, unsigned long denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ldivu_

EXTERN asm__ldivu

_ldivu_:

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
   
   jp asm__ldivu
