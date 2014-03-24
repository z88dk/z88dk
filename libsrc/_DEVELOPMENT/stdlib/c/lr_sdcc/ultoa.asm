
; char *ultoa(unsigned long num, char *buf, int radix)

XDEF ultoa

ultoa:

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
   
   call asm_ultoa
   
   pop ix
   ret

   INCLUDE "stdlib/z80/asm_ultoa.asm"
