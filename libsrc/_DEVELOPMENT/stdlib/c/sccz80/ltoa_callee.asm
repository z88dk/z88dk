
; char *ltoa(unsigned long num, char *buf, int radix)

SECTION seg_code_stdlib

PUBLIC ltoa_callee

ltoa_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af
   
   INCLUDE "stdlib/z80/asm_ltoa.asm"
