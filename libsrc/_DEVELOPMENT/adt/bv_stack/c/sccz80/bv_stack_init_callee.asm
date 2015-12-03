
; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_init_callee

EXTERN b_vector_init_callee

defc bv_stack_init_callee = b_vector_init_callee
