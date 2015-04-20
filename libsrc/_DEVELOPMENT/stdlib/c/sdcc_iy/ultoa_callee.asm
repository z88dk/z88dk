
; char *ultoa_callee(unsigned long num, char *buf, int radix)

SECTION code_stdlib

PUBLIC _ultoa_callee

_ultoa_callee:

   pop af
   pop hl
   pop de
   pop ix
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm_ultoa.asm"
