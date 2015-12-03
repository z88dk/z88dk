
; size_t wv_stack_max_size(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_max_size

EXTERN _w_vector_max_size

defc _wv_stack_max_size = _w_vector_max_size
