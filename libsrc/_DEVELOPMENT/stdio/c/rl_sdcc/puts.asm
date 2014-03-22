
; int puts(const char *s)

XDEF puts

puts:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_puts
   
   pop ix
   ret

   INCLUDE "../../z80/asm_puts.asm"
