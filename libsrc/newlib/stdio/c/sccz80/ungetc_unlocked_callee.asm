
; int ungetc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC ungetc_unlocked_callee

EXTERN asm_ungetc_unlocked

ungetc_unlocked_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   jp asm_ungetc_unlocked
