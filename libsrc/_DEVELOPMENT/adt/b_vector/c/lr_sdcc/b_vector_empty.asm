
; void b_vector_empty(b_vector_t *v)

XDEF b_vector_empty

LIB b_array_empty

defc b_vector_empty = b_array_empty

INCLUDE "adt/b_vector/z80/asm_b_vector_empty.asm"
