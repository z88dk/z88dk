
; void *b_vector_data(b_vector_t *v)

XDEF b_vector_data

LIB b_array_data

b_vector_data:

   jp b_array_data

   INCLUDE "adt/b_vector/z80/asm_b_vector_data.asm"
