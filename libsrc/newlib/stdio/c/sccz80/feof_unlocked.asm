
; int feof_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC feof_unlocked

EXTERN asm_feof_unlocked

feof_unlocked:

   push hl
   ex (sp),ix

   call asm_feof_unlocked
   pop ix
   ret
