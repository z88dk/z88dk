
; char *ltoa_callee(unsigned long num, char *buf, int radix)

SECTION code_stdlib

PUBLIC _ltoa_callee

_ltoa_callee:

   pop af
   pop hl
   pop de
   pop ix
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm_ltoa.asm"
