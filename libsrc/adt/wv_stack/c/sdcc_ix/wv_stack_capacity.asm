
; size_t wv_stack_capacity(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_capacity

EXTERN _w_vector_capacity

defc _wv_stack_capacity = _w_vector_capacity
