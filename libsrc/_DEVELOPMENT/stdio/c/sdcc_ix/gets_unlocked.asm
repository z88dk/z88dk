
; char *gets_unlocked(char *s)

XDEF _gets_unlocked

_gets_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_gets_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_gets_unlocked.asm"
