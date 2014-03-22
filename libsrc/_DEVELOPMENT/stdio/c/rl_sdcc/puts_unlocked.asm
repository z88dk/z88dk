
; int puts_unlocked(const char *s)

XDEF puts_unlocked

puts_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_puts_unlocked
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_puts_unlocked.asm"
