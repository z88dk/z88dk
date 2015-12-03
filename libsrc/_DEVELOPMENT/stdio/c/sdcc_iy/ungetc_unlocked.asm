
; int ungetc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ungetc_unlocked

EXTERN asm_ungetc_unlocked

_ungetc_unlocked:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_ungetc_unlocked
