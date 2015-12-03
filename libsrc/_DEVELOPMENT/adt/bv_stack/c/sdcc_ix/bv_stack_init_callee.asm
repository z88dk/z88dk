
; bv_stack_t *bv_stack_init_callee(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_init_callee

EXTERN _b_vector_init_callee

defc _bv_stack_init_callee = _b_vector_init_callee
