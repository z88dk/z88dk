
; int b_vector_at(b_vector_t *v, size_t idx)

PUBLIC b_vector_at

EXTERN b_array_at

;defc b_vector_at = b_array_at

b_vector_at:

   jp b_array_at
