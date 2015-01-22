
; char *ultoa(unsigned long num, char *buf, int radix)

SECTION code_stdlib

PUBLIC _ultoa

_ultoa:

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
   
   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_ultoa
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_ultoa.asm"
