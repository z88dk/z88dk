
; int w_vector_shrink_to_fit(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_shrink_to_fit

EXTERN _b_vector_shrink_to_fit

defc _w_vector_shrink_to_fit = _b_vector_shrink_to_fit
