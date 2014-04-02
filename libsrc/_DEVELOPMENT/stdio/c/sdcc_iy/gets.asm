
; char *gets(char *s)

XDEF _gets

_gets:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdio/z80/asm_gets.asm"
