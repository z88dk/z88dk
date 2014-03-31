
; void *b_vector_size(b_vector_t *v)

XDEF b_vector_size

LIB b_array_size

b_vector_size:

   jp b_array_size

   INCLUDE "adt/b_vector/z80/asm_b_vector_size.asm"
