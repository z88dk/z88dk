
; void b_vector_empty(b_vector_t *v)

PUBLIC _b_vector_empty

EXTERN _b_array_empty

_b_vector_empty:

   jp _b_array_empty

   INCLUDE "adt/b_vector/z80/asm_b_vector_empty.asm"
