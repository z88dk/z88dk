
; int putchar(int c)

XDEF _putchar

_putchar:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdio/z80/asm_putchar.asm"
