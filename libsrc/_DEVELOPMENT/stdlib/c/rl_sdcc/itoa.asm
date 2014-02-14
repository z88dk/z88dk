
; char *itoa(int num, char *buf, int radix)

XDEF itoa

itoa:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_itoa.asm"
