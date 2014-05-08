
; char *strrev(char *s)

PUBLIC _strrev

_strrev:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm_strrev.asm"
