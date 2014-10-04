
; int wv_stack_reserve(wv_stack_t *s, size_t n)

SECTION seg_code_wv_stack

PUBLIC wv_stack_reserve

EXTERN w_vector_reserve

defc wv_stack_reserve = w_vector_reserve
