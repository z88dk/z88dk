
; size_t bv_stack_size(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_size

EXTERN asm_bv_stack_size

defc bv_stack_size = asm_bv_stack_size
