
; int fseek_unlocked_callee(FILE *stream, long offset, int whence)

SECTION code_clib
SECTION code_stdio

PUBLIC _fseek_unlocked_callee

EXTERN asm_fseek_unlocked

_fseek_unlocked_callee:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_fseek_unlocked
