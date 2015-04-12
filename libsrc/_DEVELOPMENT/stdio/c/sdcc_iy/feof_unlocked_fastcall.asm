
; int feof_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _feof_unlocked_fastcall

_feof_unlocked_fastcall:
   
   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_feof_unlocked.asm"
