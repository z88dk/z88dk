
; int feof_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _feof_unlocked_fastcall

EXTERN asm_feof_unlocked

_feof_unlocked_fastcall:
   
   push hl
   pop ix
   
   jp asm_feof_unlocked
