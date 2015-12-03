
; int bv_stack_reserve(bv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_reserve

EXTERN b_vector_reserve

defc bv_stack_reserve = b_vector_reserve
