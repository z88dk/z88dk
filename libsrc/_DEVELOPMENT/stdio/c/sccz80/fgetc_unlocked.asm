
; int fgetc_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fgetc_unlocked

EXTERN asm_fgetc_unlocked

fgetc_unlocked:

   push hl
   pop ix
   
   jp asm_fgetc_unlocked
