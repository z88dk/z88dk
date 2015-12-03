
; wv_stack_t *wv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_init_callee

EXTERN w_vector_init_callee

defc wv_stack_init_callee = w_vector_init_callee
