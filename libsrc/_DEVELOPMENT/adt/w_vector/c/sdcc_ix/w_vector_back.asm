
; void *w_vector_back(b_vector_t *v)

PUBLIC _w_vector_back

EXTERN _w_array_back

defc _w_vector_back = _w_array_back

INCLUDE "adt/w_vector/z80/asm_w_vector_back.asm"
