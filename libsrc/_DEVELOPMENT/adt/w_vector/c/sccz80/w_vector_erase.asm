
; size_t w_vector_erase(w_vector_t *v, size_t idx)

SECTION seg_code_w_vector

PUBLIC w_vector_erase

EXTERN w_array_erase

defc w_vector_erase = w_array_erase
