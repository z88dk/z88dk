
; size_t ba_stack_capacity_fastcall(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_capacity_fascall

EXTERN asm_ba_stack_capacity

defc _ba_stack_capacity_fastcall = asm_ba_stack_capacity
