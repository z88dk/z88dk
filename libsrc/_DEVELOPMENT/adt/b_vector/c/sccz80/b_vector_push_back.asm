
; size_t b_vector_push_back(b_vector_t *v, int c)

SECTION seg_code_b_vector

PUBLIC b_vector_push_back

EXTERN b_vector_append

defc b_vector_push_back = b_vector_append
