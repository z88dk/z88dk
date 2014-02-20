
; int b_vector_at(b_vector_t *v, size_t idx)

XDEF b_vector_at

b_vector_at:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_b_vector_at.asm"
