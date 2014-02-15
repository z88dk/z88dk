
; char *strstrip(const char *s)

XDEF strstrip

strstrip:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_strstrip.asm"
