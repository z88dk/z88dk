
; int fileno_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _fileno_unlocked_fastcall

_fileno_unlocked_fastcall:
   
   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fileno_unlocked.asm"
