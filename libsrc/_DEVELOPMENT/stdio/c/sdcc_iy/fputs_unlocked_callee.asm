
; int fputs_unlocked_callee(const char *s, FILE *stream)

SECTION code_stdio

PUBLIC _fputs_unlocked_callee

_fputs_unlocked_callee:

   pop af
   pop hl
   pop ix
   push af

   INCLUDE "stdio/z80/asm_fputs_unlocked.asm"
