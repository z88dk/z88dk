
; char *ultoa(unsigned long num, char *buf, int radix)

XDEF ultoa

ultoa:

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
   
   call asm_ultoa
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_ultoa.asm"
