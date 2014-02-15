
; char *strchrnul(const char *s, int c)

XDEF strchrnul

strchrnul:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_strchrnul.asm"
