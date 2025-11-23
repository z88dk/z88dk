
; int fileno_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fileno_unlocked

EXTERN asm_fileno_unlocked

_fileno_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_fileno_unlocked
