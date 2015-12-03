
; void *w_vector_at(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_at_callee

EXTERN w_array_at_callee

defc w_vector_at_callee = w_array_at_callee
