
; size_t ba_stack_capacity(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_capacity

EXTERN _b_array_capacity

defc _ba_stack_capacity = _b_array_capacity
