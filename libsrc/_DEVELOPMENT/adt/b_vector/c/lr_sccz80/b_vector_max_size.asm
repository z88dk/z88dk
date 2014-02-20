
; void *b_vector_max_size(b_vector_t *v)

XDEF b_vector_max_size
XDEF b_vector_capacity, b_vector_size, b_vector_data

defc b_vector_capacity = asm_b_vector_capacity
defc b_vector_size = asm_b_vector_size
defc b_vector_data = asm_b_vector_data

b_vector_max_size:

   INCLUDE "../../z80/asm_b_vector_max_size.asm"
