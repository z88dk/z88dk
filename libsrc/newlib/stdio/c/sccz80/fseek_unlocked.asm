
; int fseek_unlocked(FILE *stream, long offset, int whence)

SECTION code_clib
SECTION code_stdio

PUBLIC fseek_unlocked

EXTERN asm_fseek_unlocked

fseek_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   
   push hl
   push de
   push hl
   push bc
   push af
   
   jp asm_fseek_unlocked
