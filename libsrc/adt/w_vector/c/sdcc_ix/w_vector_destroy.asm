
; void w_vector_destroy(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_destroy

EXTERN _b_vector_destroy

defc _w_vector_destroy = _b_vector_destroy
