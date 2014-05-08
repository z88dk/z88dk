
; size_t w_vector_erase(w_vector_t *v, size_t idx)

PUBLIC w_vector_erase

EXTERN w_array_erase

;defc w_vector_erase = w_array_erase

w_vector_erase:

   jp w_array_erase
