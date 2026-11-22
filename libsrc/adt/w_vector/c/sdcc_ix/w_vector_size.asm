
; void *w_vector_size(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_size

EXTERN _w_array_size

defc _w_vector_size = _w_array_size
