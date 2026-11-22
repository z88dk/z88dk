
; void w_vector_empty(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_empty

EXTERN _w_array_empty

defc _w_vector_empty = _w_array_empty
