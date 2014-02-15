
; char *itoa(int num, char *buf, int radix)

XDEF itoa

itoa:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   push ix
   
   call asm_itoa
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_itoa.asm"
