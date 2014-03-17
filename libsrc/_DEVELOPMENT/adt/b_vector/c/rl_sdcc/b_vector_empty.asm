
; void b_vector_empty(b_vector_t *v)

XDEF b_vector_empty

LIB b_array_empty

defc b_vector_empty = b_array_empty

INCLUDE "../../z80/asm_b_vector_empty.asm"
