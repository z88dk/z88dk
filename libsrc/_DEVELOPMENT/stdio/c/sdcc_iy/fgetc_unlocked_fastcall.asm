
; int fgetc_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgetc_unlocked_fastcall

EXTERN asm_fgetc_unlocked

_fgetc_unlocked_fastcall:
   
   push hl
   pop ix
   
   jp asm_fgetc_unlocked
