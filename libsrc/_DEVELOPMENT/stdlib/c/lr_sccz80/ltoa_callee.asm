
; char *ltoa(unsigned long num, char *buf, int radix)

XDEF ltoa_callee

ltoa_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_ltoa.asm"
