
; void _div_(div_t *d, int numer, int denom)

SECTION seg_code_stdlib

PUBLIC _div__callee

_div__callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm__div.asm"
