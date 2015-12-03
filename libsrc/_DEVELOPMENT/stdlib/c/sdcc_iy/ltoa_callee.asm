
; char *ltoa_callee(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ltoa_callee

EXTERN asm_ltoa

_ltoa_callee:

   pop af
   pop hl
   pop de
   pop ix
   pop bc
   push af
   
   jp asm_ltoa
