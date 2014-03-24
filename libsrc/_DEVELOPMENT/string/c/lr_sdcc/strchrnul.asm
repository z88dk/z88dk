
; char *strchrnul(const char *s, int c)

XDEF strchrnul

strchrnul:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "string/z80/asm_strchrnul.asm"
