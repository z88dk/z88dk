
; void *w_vector_at(b_vector_t *v, size_t idx)

XDEF w_vector_at_callee

LIB w_array_at_callee

defc w_vector_at_callee = w_array_at_callee

INCLUDE "../../z80/asm_w_vector_at.asm"
