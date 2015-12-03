
; size_t bv_stack_capacity(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_capacity

EXTERN asm_bv_stack_capacity

defc bv_stack_capacity = asm_bv_stack_capacity
