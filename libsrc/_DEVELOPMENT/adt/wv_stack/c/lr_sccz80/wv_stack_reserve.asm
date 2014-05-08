
; int wv_stack_reserve(wv_stack_t *s, size_t n)

PUBLIC wv_stack_reserve

EXTERN w_vector_reserve

;defc wv_stack_reserve = w_vector_reserve

wv_stack_reserve:

   jp w_vector_reserve

