
; int b_vector_shrink_to_fit(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC _b_vector_shrink_to_fit

_b_vector_shrink_to_fit:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/b_vector/z80/asm_b_vector_shrink_to_fit.asm"
