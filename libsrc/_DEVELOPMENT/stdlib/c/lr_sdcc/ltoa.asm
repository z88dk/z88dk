
; char *ltoa(unsigned long num, char *buf, int radix)

XDEF ltoa

ltoa:

   pop af
   pop bc
   exx
   pop bc
   exx
   pop hl
   pop de
   
   push de
   push hl
   exx
   push bc
   exx
   push bc
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
