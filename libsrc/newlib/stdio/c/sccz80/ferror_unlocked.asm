
; int ferror_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC ferror_unlocked

EXTERN asm_ferror_unlocked

ferror_unlocked:

   push hl
   ex (sp),ix

   call asm_ferror_unlocked
   pop ix
   ret
