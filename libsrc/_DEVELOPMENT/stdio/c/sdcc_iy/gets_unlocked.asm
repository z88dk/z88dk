
; char *gets_unlocked(char *s)

SECTION code_stdio

PUBLIC _gets_unlocked

_gets_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdio/z80/asm_gets_unlocked.asm"
