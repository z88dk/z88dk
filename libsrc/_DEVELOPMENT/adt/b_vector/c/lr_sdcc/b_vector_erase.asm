
; size_t b_vector_erase(b_vector_t *v, size_t idx)

XDEF b_vector_erase

b_vector_erase:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_b_vector_erase.asm"
