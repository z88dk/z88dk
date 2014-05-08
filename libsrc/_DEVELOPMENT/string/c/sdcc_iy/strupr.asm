
; char *strupr(char *s)

PUBLIC _strupr

_strupr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm_strupr.asm"
