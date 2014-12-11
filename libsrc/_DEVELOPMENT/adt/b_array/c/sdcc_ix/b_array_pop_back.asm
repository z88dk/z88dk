
; int b_array_pop_back(b_array_t *a)

SECTION code_adt_b_array

PUBLIC _b_array_pop_back

_b_array_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/b_array/z80/asm_b_array_pop_back.asm"
