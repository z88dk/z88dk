
; void rewind_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC rewind_unlocked

EXTERN asm_rewind_unlocked

rewind_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_rewind_unlocked
