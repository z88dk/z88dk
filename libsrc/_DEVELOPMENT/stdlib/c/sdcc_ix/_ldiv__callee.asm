
; void _ldiv__callee(ldiv_t *ld, long numer, long denom)

SECTION code_stdlib

PUBLIC __ldiv__callee, l0__ldiv__callee

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

l0__ldiv__callee:

   push ix
   
   call asm__ldiv
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm__ldiv.asm"
