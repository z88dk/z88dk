
; int fputs_unlocked(const char *s, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fputs_unlocked_callee

EXTERN asm_fputs_unlocked

fputs_unlocked_callee:

   pop hl
   pop de
   ex (sp),hl

   push ix
   push de
   pop ix

   call asm_fputs_unlocked
   pop ix
   ret
