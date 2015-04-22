
; FILE *freopen_unlocked_callee(char *filename, char *mode, FILE *stream)

SECTION code_stdio

PUBLIC _freopen_unlocked_callee

_freopen_unlocked_callee:

   pop af
   pop hl
   pop de
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_freopen_unlocked.asm"
