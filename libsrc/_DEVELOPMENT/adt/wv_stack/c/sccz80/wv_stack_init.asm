
; wv_stack_t *wv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_init

EXTERN w_vector_init

defc wv_stack_init = w_vector_init
