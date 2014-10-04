
; void *w_vector_at(b_vector_t *v, size_t idx)

SECTION seg_code_w_vector

PUBLIC _w_vector_at

EXTERN _w_array_at

defc _w_vector_at = _w_array_at

INCLUDE "adt/w_vector/z80/asm_w_vector_at.asm"
