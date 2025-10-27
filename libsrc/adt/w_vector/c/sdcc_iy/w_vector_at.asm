
; void *w_vector_at(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_at

EXTERN _w_array_at

defc _w_vector_at = _w_array_at
