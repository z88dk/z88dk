
; int bv_stack_reserve(bv_stack_t *s, size_t n)

SECTION seg_code_bv_stack

PUBLIC bv_stack_reserve_callee

EXTERN b_vector_reserve_callee

defc bv_stack_reserve_callee = b_vector_reserve_callee

INCLUDE "adt/bv_stack/z80/asm_bv_stack_reserve.asm"
