
; char *gets(char *s)

XDEF gets

gets:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdio/z80/asm_gets.asm"
