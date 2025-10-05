
; int fputc_unlocked_callee(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fputc_unlocked_callee

EXTERN asm_fputc_unlocked

_fputc_unlocked_callee:

   pop af
   pop de
   pop ix
   push af
   
   jp asm_fputc_unlocked
