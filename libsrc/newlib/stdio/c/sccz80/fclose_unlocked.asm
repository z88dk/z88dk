
; int fclose_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fclose_unlocked

EXTERN asm_fclose_unlocked

fclose_unlocked:

   push hl
   ex (sp),ix

   call asm_fclose_unlocked
   pop ix
   ret
