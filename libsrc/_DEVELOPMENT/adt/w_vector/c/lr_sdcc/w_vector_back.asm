
; void *w_vector_back(b_vector_t *v)

XDEF w_vector_back

LIB w_array_back

defc w_vector_back = w_array_back

INCLUDE "../../z80/asm_w_vector_back.asm"
