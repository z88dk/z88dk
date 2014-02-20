
; int b_vector_shrink_to_fit(b_vector_t *v)

XDEF b_vector_shrink_to_fit

b_vector_shrink_to_fit:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_b_vector_shrink_to_fit.asm"
