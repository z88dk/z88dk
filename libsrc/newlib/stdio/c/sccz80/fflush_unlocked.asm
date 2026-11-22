
; int fflush_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fflush_unlocked

EXTERN asm_fflush_unlocked

fflush_unlocked:

   push hl
   ex (sp),ix

   call asm_fflush_unlocked
   pop ix
   ret
