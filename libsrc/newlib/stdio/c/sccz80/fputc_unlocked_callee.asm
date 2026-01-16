
; int fputc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fputc_unlocked_callee

EXTERN asm_fputc_unlocked

fputc_unlocked_callee:

   pop af
   pop ix
   pop de
   push af
   
   jp asm_fputc_unlocked
