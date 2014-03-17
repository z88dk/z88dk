
; int b_array_at(b_array_t *a, size_t idx)

XDEF b_array_at

b_array_at:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_b_array_at.asm"
