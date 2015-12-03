
; char *ltoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC ltoa_callee

EXTERN asm_ltoa

ltoa_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af
   
   jp asm_ltoa
