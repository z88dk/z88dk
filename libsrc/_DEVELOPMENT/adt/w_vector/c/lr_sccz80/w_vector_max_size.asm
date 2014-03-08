
; void *w_vector_max_size(w_vector_t *v)

XDEF w_vector_max_size
XDEF w_vector_capacity, w_vector_size

defc w_vector_capacity = asm_w_vector_capacity
defc w_vector_size = asm_w_vector_size

w_vector_max_size:

   INCLUDE "../../z80/asm_w_vector_max_size.asm"
