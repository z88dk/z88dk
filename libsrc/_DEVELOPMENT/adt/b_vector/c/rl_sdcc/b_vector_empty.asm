
; void b_vector_empty(b_vector_t *v)

XDEF b_vector_empty

b_vector_empty:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_b_vector_empty.asm"
