
; char *ultoa_callee(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ultoa_callee

EXTERN asm_ultoa

_ultoa_callee:

   pop af
   pop hl
   pop de
   pop ix
   pop bc
   push af
   
   jp asm_ultoa
