
; int b_vector_at(b_vector_t *v, size_t idx)

XDEF b_vector_at

b_vector_at:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_b_vector_at.asm"
