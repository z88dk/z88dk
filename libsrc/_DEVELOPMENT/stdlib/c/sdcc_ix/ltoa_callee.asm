
; char *ltoa_callee(unsigned long num, char *buf, int radix)

SECTION code_stdlib

PUBLIC _ltoa_callee, l0_ltoa_callee

_ltoa:

   pop af
   pop hl
   pop de
   exx
   pop bc
   exx
   pop bc
   push af

l0_ltoa_callee:
   
   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_ltoa
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_ltoa.asm"
