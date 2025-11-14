
; char *utoa_callee(unsigned int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _utoa_callee, l0_utoa_callee

EXTERN asm_utoa

_utoa_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_utoa_callee:

   push ix
   
   call asm_utoa
   
   pop ix
   ret
