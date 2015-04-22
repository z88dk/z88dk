
; char *fgets_unlocked_callee(char *s, int n, FILE *stream)

SECTION code_stdio

PUBLIC _fgets_unlocked_callee

_fgets_unlocked_callee:

   pop af
   pop de
   pop bc
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fgets_unlocked.asm"
