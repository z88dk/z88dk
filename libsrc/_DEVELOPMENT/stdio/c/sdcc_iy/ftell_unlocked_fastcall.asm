
; unsigned long ftell_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ftell_unlocked_fastcall

EXTERN asm_ftell_unlocked

_ftell_unlocked_fastcall:

   push hl
   pop ix
   
   jp asm_ftell_unlocked
