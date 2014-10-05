
; int abs(int j)

SECTION seg_code_stdlib

PUBLIC _abs

_abs:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdlib/z80/asm_abs.asm"
