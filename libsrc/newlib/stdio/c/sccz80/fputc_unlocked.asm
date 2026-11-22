
; int fputc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fputc_unlocked

EXTERN asm_fputc_unlocked

fputc_unlocked:

   pop af
   pop ix
   pop de
   
   push de
   push hl
   push af
   
   jp asm_fputc_unlocked
