
; void wv_stack_clear(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_clear

EXTERN _w_vector_clear

defc _wv_stack_clear = _w_vector_clear
