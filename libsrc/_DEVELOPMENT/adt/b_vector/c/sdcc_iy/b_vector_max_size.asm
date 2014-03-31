
; void *b_vector_max_size(b_vector_t *v)

XDEF b_vector_max_size

b_vector_max_size:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/b_vector/z80/asm_b_vector_max_size.asm"
