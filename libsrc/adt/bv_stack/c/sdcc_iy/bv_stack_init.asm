
; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_init

EXTERN _b_vector_init

defc _bv_stack_init = _b_vector_init
