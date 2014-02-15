
; char *utoa(unsigned int num, char *buf, int radix)

XDEF utoa

utoa:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   push ix
   
   call asm_utoa
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_utoa.asm"
