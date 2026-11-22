
; int ungetc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC ungetc_unlocked_callee

EXTERN asm_ungetc_unlocked

ungetc_unlocked_callee:

   pop hl
   pop de
   ex (sp),hl

   push ix
   push de
   pop ix

   call asm_ungetc_unlocked
   pop ix
   ret
