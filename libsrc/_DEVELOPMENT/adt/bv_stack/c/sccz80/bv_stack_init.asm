
; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)

PUBLIC bv_stack_init

EXTERN b_vector_init

;defc bv_stack_init = b_vector_init

bv_stack_init:

   jp b_vector_init
