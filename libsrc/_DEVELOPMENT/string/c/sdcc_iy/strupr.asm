
; char *strupr(char *s)

XDEF strupr

strupr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm_strupr.asm"
