
; int b_vector_at(b_vector_t *v, size_t idx)

XDEF _b_vector_at

LIB _b_array_at

_b_vector_at:

   jp _b_array_at

   INCLUDE "adt/b_vector/z80/asm_b_vector_at.asm"
