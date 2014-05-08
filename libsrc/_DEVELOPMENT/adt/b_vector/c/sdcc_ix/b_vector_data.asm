
; void *b_vector_data(b_vector_t *v)

PUBLIC _b_vector_data

EXTERN _b_array_data

_b_vector_data:

   jp _b_array_data

   INCLUDE "adt/b_vector/z80/asm_b_vector_data.asm"
