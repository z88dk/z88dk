
; void *w_vector_front(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_front

EXTERN _w_array_front

defc _w_vector_front = _w_array_front
