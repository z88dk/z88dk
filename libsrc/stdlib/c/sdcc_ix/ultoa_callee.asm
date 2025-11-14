
; char *ultoa_callee(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ultoa_callee, l0_ultoa_callee

EXTERN asm_ultoa

_ultoa_callee:

   pop af
   pop hl
   pop de
   exx
   pop bc
   exx
   pop bc
   push af

l0_ultoa_callee:
   
   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_ultoa
   
   pop ix
   ret
