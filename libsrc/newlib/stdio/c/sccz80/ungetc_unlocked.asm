
; int ungetc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC ungetc_unlocked

EXTERN asm_ungetc_unlocked

ungetc_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   jp asm_ungetc_unlocked
