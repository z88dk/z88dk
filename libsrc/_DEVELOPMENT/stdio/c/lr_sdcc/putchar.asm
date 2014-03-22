
; int putchar(int c)

XDEF putchar

putchar:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_putchar
   
   pop ix
   ret

   INCLUDE "../../z80/asm_putchar.asm"
