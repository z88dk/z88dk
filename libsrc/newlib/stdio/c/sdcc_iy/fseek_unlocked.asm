
; int fseek_unlocked(FILE *stream, long offset, int whence)

SECTION code_clib
SECTION code_stdio

PUBLIC _fseek_unlocked

EXTERN asm_fseek_unlocked

_fseek_unlocked:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push hl
   push af
   
   jp asm_fseek_unlocked
