
; int fileno_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fileno_unlocked

EXTERN asm_fileno_unlocked

fileno_unlocked:

   push hl
   pop ix
   
   jp asm_fileno_unlocked
