
; size_t b_vector_erase(b_vector_t *v, size_t idx)

PUBLIC _b_vector_erase

EXTERN _b_array_erase

_b_vector_erase:

   jp _b_array_erase

   INCLUDE "adt/b_vector/z80/asm_b_vector_erase.asm"
