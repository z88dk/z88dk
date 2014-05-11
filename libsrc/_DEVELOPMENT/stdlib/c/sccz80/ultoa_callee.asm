
; char *ultoa(unsigned long num, char *buf, int radix)

PUBLIC ultoa_callee

ultoa_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af
   
   INCLUDE "stdlib/z80/asm_ultoa.asm"
