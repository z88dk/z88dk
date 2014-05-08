
; int fputc_unlocked(int c, FILE *stream)

PUBLIC fputc_unlocked

EXTERN asm_fputc_unlocked

fputc_unlocked:

   pop af
   pop ix
   pop de
   
   push de
   push ix
   push af
   
   jp asm_fputc_unlocked
