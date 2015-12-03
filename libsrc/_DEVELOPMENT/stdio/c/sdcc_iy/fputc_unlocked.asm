
; int fputc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fputc_unlocked

EXTERN asm_fputc_unlocked

_fputc_unlocked:

   pop af
   pop de
   pop ix
   
   push hl
   push de
   push af
   
   jp asm_fputc_unlocked
