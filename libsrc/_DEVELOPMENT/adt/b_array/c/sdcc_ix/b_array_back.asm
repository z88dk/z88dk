
; int b_array_back(b_array_t *a)

PUBLIC _b_array_back

_b_array_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/b_array/z80/asm_b_array_back.asm"
