
; void _div__callee(div_t *d, int numer, int denom)

SECTION code_stdlib

PUBLIC __div__callee

__div__callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "stdlib/z80/asm__div.asm"
