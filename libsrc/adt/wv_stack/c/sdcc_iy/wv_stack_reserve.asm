
; int wv_stack_reserve(wv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_reserve

EXTERN _w_vector_reserve

defc _wv_stack_reserve = _w_vector_reserve
