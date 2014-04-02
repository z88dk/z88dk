
; char *strupr(char *s)

XDEF _strupr

_strupr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm_strupr.asm"
