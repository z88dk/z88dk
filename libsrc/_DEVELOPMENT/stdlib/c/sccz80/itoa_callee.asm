
; char *itoa(int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC itoa_callee

EXTERN asm_itoa

itoa_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_itoa
