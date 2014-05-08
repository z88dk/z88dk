
; int bv_stack_push(bv_stack_t *s, int c)

PUBLIC bv_stack_push

EXTERN b_vector_append

;defc bv_stack_push = b_vector_append

bv_stack_push:

   jp b_vector_append
