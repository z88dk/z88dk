
; void *w_vector_pop_back(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_pop_back

EXTERN _w_array_pop_back

defc _w_vector_pop_back = _w_array_pop_back
