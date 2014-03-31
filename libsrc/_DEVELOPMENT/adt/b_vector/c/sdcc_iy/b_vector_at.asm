
; int b_vector_at(b_vector_t *v, size_t idx)

XDEF b_vector_at

LIB b_array_at

b_vector_at:

   jp b_array_at

   INCLUDE "adt/b_vector/z80/asm_b_vector_at.asm"
