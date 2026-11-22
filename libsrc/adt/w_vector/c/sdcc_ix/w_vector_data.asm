
; void *w_vector_data(b_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_data

EXTERN _w_array_data

defc _w_vector_data = _w_array_data
