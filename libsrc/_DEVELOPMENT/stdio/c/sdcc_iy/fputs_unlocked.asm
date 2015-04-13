
; int fputs_unlocked(const char *s, FILE *stream)

SECTION code_stdio

PUBLIC _fputs_unlocked

_fputs_unlocked:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af

   INCLUDE "stdio/z80/asm_fputs_unlocked.asm"
