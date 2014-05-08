
; size_t b_vector_push_back(b_vector_t *v, int c)

PUBLIC b_vector_push_back

EXTERN b_vector_append

;defc b_vector_push_back = b_vector_append

b_vector_push_back:

   jp b_vector_append
