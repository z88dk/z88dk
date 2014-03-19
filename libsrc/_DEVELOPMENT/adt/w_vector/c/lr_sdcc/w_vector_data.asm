
; void *w_vector_data(b_vector_t *v)

XDEF w_vector_data

LIB w_array_data

defc w_vector_data = w_array_data

INCLUDE "../../z80/asm_w_vector_data.asm"
