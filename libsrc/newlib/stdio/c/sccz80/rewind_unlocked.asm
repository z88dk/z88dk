
; void rewind_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC rewind_unlocked

EXTERN asm_rewind_unlocked

rewind_unlocked:

   push hl
   ex (sp),ix

   call asm_rewind_unlocked
   pop ix
   ret
