
; wv_stack_t *wv_stack_init_callee(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_init_callee

EXTERN _w_vector_init_callee

defc _wv_stack_init_callee = _w_vector_init_callee
