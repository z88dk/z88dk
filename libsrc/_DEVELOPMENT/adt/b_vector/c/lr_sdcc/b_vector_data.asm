
; void *b_vector_data(b_vector_t *v)

XDEF b_vector_data

LIB b_array_data

defc b_vector_data = b_array_data

INCLUDE "../../z80/asm_b_vector_data.asm"
