
; size_t b_vector_erase(b_vector_t *v, size_t idx)

PUBLIC b_vector_erase

EXTERN b_array_erase

;defc b_vector_erase = b_array_erase

b_vector_erase:

   jp b_array_erase
