
; int puts_unlocked(const char *s)

SECTION code_stdio

PUBLIC _puts_unlocked

_puts_unlocked:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_puts_unlocked.asm"
