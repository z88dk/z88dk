
; void *wv_stack_top(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_top

EXTERN _w_array_back

defc _wv_stack_top = _w_array_back
