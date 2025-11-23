
; size_t w_vector_capacity(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_capacity

EXTERN _w_array_capacity

defc _w_vector_capacity = _w_array_capacity
