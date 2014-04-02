
; char *gets(char *s)

XDEF _gets

_gets:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_gets
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_gets.asm"
