
; size_t w_array_push_back_callee(w_array_t *a, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_push_back_callee

EXTERN _w_array_append_callee

defc _w_array_push_back_callee = _w_array_append_callee
