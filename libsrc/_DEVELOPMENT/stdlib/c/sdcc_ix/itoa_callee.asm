
; char *itoa_callee(int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _itoa_callee, l0_itoa_callee

EXTERN asm_itoa

_itoa_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_itoa_callee:

   push ix
   
   call asm_itoa
   
   pop ix
   ret
