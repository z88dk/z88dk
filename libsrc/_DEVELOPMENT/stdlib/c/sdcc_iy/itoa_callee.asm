
; char *itoa_callee(int num, char *buf, int radix)

SECTION code_stdlib

PUBLIC _itoa_callee

_itoa_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm_itoa.asm"
