
; int wv_stack_push(wv_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_push

EXTERN _w_vector_append

defc _wv_stack_push = _w_vector_append
