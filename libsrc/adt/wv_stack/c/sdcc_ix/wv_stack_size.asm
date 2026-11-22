
; size_t wv_stack_size(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_size

EXTERN _w_vector_size

defc _wv_stack_size = _w_vector_size
