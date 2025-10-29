
; int fflush_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fflush_unlocked_fastcall

EXTERN asm_fflush_unlocked

_fflush_unlocked_fastcall:
   
   push hl
   pop ix
   
   jp asm_fflush_unlocked
