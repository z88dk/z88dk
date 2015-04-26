
; void *w_vector_at_callee(b_vector_t *v, size_t idx)

SECTION code_adt_w_vector

PUBLIC _w_vector_at_callee

EXTERN _w_array_at_callee

defc _w_vector_at_callee = _w_array_at_callee

INCLUDE "adt/w_vector/z80/asm_w_vector_at.asm"
