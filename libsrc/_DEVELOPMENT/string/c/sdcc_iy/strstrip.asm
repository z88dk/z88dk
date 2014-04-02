
; char *strstrip(const char *s)

XDEF _strstrip

_strstrip:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm_strstrip.asm"
