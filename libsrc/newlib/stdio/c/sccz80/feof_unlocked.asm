
; int feof_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC feof_unlocked

EXTERN asm_feof_unlocked

feof_unlocked:

   push hl
   pop ix
   
   jp asm_feof_unlocked
