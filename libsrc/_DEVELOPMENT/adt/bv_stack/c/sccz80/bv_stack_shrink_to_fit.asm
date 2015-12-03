
; int bv_stack_shrink_to_fit(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_shrink_to_fit

EXTERN asm_bv_stack_shrink_to_fit

defc bv_stack_shrink_to_fit = asm_bv_stack_shrink_to_fit
