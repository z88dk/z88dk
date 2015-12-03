
; void rewind_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC rewind_unlocked

EXTERN asm_rewind_unlocked

rewind_unlocked:

   push hl
   pop ix
   
   jp asm_rewind_unlocked
