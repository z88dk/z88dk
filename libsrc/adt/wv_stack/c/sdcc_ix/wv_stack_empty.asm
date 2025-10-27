
; int wv_stack_empty(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_empty

EXTERN _w_vector_empty

defc _wv_stack_empty = _w_vector_empty
