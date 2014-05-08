
; int wv_stack_push(wv_stack_t *s, void *item)

PUBLIC wv_stack_push

EXTERN w_vector_append

;defc wv_stack_push = w_vector_append

wv_stack_push:

   jp w_vector_append
