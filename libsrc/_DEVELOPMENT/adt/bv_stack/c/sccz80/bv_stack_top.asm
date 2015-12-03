
; int bv_stack_top(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_top

EXTERN asm_bv_stack_top

defc bv_stack_top = asm_bv_stack_top
