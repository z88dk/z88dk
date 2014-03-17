
; int b_array_back(b_array_t *a)

XDEF b_array_back

b_array_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_b_array_back.asm"
