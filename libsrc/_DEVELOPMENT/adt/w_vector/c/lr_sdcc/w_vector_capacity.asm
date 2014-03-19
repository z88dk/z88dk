
; size_t w_vector_capacity(w_vector_t *v)

XDEF w_vector_capacity

LIB w_array_capacity

defc w_vector_capacity = w_array_capacity

INCLUDE "../../z80/asm_w_vector_capacity.asm"
