
; char *itoa(int num, char *buf, int radix)

PUBLIC _itoa

_itoa:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm_itoa.asm"
