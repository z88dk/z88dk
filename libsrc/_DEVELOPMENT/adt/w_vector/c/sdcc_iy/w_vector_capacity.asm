
; size_t w_vector_capacity(w_vector_t *v)

SECTION seg_code_w_vector

PUBLIC _w_vector_capacity

EXTERN _w_array_capacity

defc _w_vector_capacity = _w_array_capacity

INCLUDE "adt/w_vector/z80/asm_w_vector_capacity.asm"
