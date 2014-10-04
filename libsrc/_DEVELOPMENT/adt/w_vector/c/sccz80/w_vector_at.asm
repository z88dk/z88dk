
; void *w_vector_at(b_vector_t *v, size_t idx)

SECTION seg_code_w_vector

PUBLIC w_vector_at

EXTERN w_array_at

defc w_vector_at = w_array_at
