
; char *ltoa(unsigned long num, char *buf, int radix)

XDEF ltoa

ltoa:

   pop af
   pop hl
   pop de
   pop ix
   pop bc
   
   push bc
   push ix
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm_ltoa.asm"
