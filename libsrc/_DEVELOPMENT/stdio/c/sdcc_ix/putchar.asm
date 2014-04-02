
; int putchar(int c)

XDEF _putchar

_putchar:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_putchar
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_putchar.asm"
