
; char *ltoa(unsigned long num, char *buf, int radix)

XDEF ltoa

ltoa:

   pop af
   pop hl
   pop de
   exx
   pop bc
   exx
   pop bc
   
   push bc
   exx
   push bc
   exx
   push de
   push hl
   push af
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_ltoa
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_ltoa.asm"
