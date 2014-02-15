
; char *utoa(unsigned int num, char *buf, int radix)

XDEF utoa

utoa:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   push ix
   
   call asm_utoa
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_utoa.asm"
