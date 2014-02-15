
; char *strrev(char *s)

XDEF strrev

strrev:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_strrev.asm"
