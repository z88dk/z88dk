
; void *w_vector_back(b_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_back

EXTERN _w_array_back

defc _w_vector_back = _w_array_back
