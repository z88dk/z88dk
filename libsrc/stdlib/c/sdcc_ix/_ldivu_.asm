
; void _ldivu_(ldivu_t *ld, unsigned long numer, unsigned long denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __ldivu_

EXTERN l0__ldivu__callee

__ldivu_:

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
   push de
   push hl
   push bc
   push af

   jp l0__ldivu__callee
