
; int fgetc_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _fgetc_unlocked_fastcall

_fgetc_unlocked_fastcall:
   
   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fgetc_unlocked.asm"
