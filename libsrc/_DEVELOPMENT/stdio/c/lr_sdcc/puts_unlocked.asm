
; int puts_unlocked(const char *s)

XDEF puts_unlocked

puts_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_puts_unlocked.asm"
