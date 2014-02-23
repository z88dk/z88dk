
; char *gets_unlocked(char *s)

XDEF gets_unlocked

gets_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_gets_unlocked.asm"
