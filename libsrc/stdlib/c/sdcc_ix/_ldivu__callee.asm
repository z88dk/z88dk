
; void _ldivu__callee(ldivu_t *ld, unsigned long numer, unsigned long denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __ldivu__callee, l0__ldivu__callee

EXTERN asm__ldivu

__ldivu__callee:

   pop af
   pop bc
   exx
   pop hl
   pop de
   exx
   pop hl
   pop de
   push af

l0__ldivu__callee:

   push ix
   
   call asm__ldivu
   
   pop ix
   ret
