
; size_t ba_stack_size(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_size

EXTERN _b_array_size

defc _ba_stack_size = _b_array_size
