
; int wv_stack_push_callee(wv_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_push_callee

EXTERN _w_vector_append_callee

defc _wv_stack_push_callee = _w_vector_append_callee
