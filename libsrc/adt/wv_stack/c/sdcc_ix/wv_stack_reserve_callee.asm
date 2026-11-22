
; int wv_stack_reserve_callee(wv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_reserve_callee

EXTERN _w_vector_reserve_callee

defc _wv_stack_reserve_callee = _w_vector_reserve_callee
