
; char *utoa_callee(unsigned int num, char *buf, int radix)

SECTION code_stdlib

PUBLIC _utoa_callee

_utoa_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm_utoa.asm"
