
; void bv_stack_clear(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_clear

EXTERN asm_bv_stack_clear

defc bv_stack_clear = asm_bv_stack_clear
