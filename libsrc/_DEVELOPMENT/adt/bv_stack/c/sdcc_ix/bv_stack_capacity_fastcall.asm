
; size_t bv_stack_capacity_fastcall(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_capacity_fastcall

EXTERN asm_bv_stack_capacity

defc _bv_stack_capacity_fastcall = asm_bv_stack_capacity
