
; char *ultoa(unsigned long num, char *buf, int radix)

XDEF ultoa

ultoa:

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
   
   INCLUDE "stdlib/z80/asm_ultoa.asm"
