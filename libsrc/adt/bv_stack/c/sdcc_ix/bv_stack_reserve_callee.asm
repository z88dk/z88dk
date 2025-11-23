
; int bv_stack_reserve_callee(bv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_reserve_callee

EXTERN _b_vector_reserve_callee

defc _bv_stack_reserve_callee = _b_vector_reserve_callee
