
; size_t w_vector_push_back(w_vector_t *v, int c)

PUBLIC w_vector_push_back

EXTERN w_vector_append

;defc w_vector_push_back = w_vector_append

w_vector_push_back:

   jp w_vector_append
