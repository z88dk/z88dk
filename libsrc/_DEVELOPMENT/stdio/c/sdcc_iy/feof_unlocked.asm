
; int feof_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _feof_unlocked

EXTERN asm_feof_unlocked

_feof_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_feof_unlocked
