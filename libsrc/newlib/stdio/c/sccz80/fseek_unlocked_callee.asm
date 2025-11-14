
; int fseek_unlocked(FILE *stream, long offset, int whence)

SECTION code_clib
SECTION code_stdio

PUBLIC fseek_unlocked_callee

EXTERN asm_fseek_unlocked

fseek_unlocked_callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   jp asm_fseek_unlocked
