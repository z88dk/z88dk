
; int abs(int j)

PUBLIC _abs

_abs:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdlib/z80/asm_abs.asm"
