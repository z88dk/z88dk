
; size_t b_vector_capacity(b_vector_t *v)

XDEF b_vector_capacity

LIB b_array_capacity

b_vector_capacity:

   jp b_array_capacity

   INCLUDE "adt/b_vector/z80/asm_b_vector_capacity.asm"
