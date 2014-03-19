
; int wv_stack_reserve(wv_stack_t *s, size_t n)

XDEF wv_stack_reserve_callee

LIB w_vector_reserve_callee

defc wv_stack_reserve_callee = w_vector_reserve_callee

INCLUDE "../../z80/asm_wv_stack_reserve.asm"
