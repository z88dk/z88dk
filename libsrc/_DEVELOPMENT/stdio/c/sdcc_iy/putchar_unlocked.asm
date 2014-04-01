
; int putchar_unlocked(int c)

XDEF putchar_unlocked

putchar_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdio/z80/asm_putchar_unlocked.asm"
