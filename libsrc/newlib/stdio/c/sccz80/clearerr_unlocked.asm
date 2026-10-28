
; void clearerr_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC clearerr_unlocked

EXTERN asm_clearerr_unlocked

clearerr_unlocked:

   push hl
   ex (sp),ix

   call asm_clearerr_unlocked
   pop ix
   ret
