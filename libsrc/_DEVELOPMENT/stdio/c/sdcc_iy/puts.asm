
; int puts(const char *s)

XDEF puts

puts:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdio/z80/asm_puts.asm"
