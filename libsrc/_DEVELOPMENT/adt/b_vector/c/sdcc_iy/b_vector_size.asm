
; void *b_vector_size(b_vector_t *v)

PUBLIC _b_vector_size

EXTERN _b_array_size

_b_vector_size:

   jp _b_array_size

   INCLUDE "adt/b_vector/z80/asm_b_vector_size.asm"
