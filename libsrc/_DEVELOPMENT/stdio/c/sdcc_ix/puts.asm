
; int puts(const char *s)

XDEF _puts

_puts:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_puts
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_puts.asm"
