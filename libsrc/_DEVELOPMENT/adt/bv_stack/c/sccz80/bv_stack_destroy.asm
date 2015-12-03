
; void bv_stack_destroy(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_destroy

EXTERN asm_bv_stack_destroy

defc bv_stack_destroy = asm_bv_stack_destroy
