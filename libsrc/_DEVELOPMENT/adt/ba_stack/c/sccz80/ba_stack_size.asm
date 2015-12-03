
; size_t ba_stack_size(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_size

EXTERN asm_ba_stack_size

defc ba_stack_size = asm_ba_stack_size
